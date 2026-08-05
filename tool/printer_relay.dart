// Relay printer untuk menjalankan aplikasi di Android emulator.
//
// Cara pakai:
//   1. Pastikan printer thermal (MP58) terpasang di Windows.
//   2. Jalankan di laptop:   dart run tool/printer_relay.dart
//      (opsional: dart run tool/printer_relay.dart 9100 MP58)
//   3. Di aplikasi (emulator Android), buka Pengaturan Printer ->
//      "Printer Jaringan", klik tombol "Emulator / via Laptop".
//      Otomatis terhubung ke 10.0.2.2:9100.
//
// Script ini mendengarkan koneksi TCP lalu meneruskan byte ESC/POS
// ke printer Windows yang terpasang secara RAW.
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

void main(List<String> args) async {
  var port = args.isNotEmpty ? int.tryParse(args[0]) ?? 9101 : 9101;
  final requestedName = args.length > 1 ? args[1] : null;

  stdout.writeln('=== Printer Relay (untuk Emulator) ===');
  stdout.writeln('Mencari printer yang terpasang di Windows...');

  final printers = listInstalledPrinters();
  if (printers.isEmpty) {
    stdout.writeln('TIDAK ADA printer terpasang di laptop. Cek Devices & Printers.');
    return;
  }
  printers.forEach((p) => stdout.writeln('  - $p'));

  String target;
  if (requestedName == null || requestedName.isEmpty) {
    target = printers.first;
  } else {
    final match = printers
        .where((p) => p.toLowerCase().contains(requestedName.toLowerCase()))
        .toList();
    target = match.isNotEmpty ? match.first : requestedName;
  }

  // Cari port yang kosong (9100 sering dipakai DevTools / printer lain)
  ServerSocket? server;
  for (var p = port; p < port + 10; p++) {
    try {
      server = await ServerSocket.bind(InternetAddress.anyIPv4, p);
      port = p;
      break;
    } on SocketException {
      stdout.writeln('Port $p sedang dipakai, coba port lain...');
    }
  }
  if (server == null) {
    stdout.writeln('GAGAL: tidak ada port kosong antara $port dan ${port + 9}.');
    return;
  }

  stdout.writeln('Printer target : $target');
  stdout.writeln('Listening di port $port ...');
  stdout.writeln('Di aplikasi (emulator) pilih "Emulator / via Laptop" -> 10.0.2.2:$port');
  stdout.writeln('Tekan Ctrl+C untuk berhenti.');
  stdout.writeln('');

  await for (final socket in server) {
    socket.listen(
      (chunk) {
        try {
          rawPrint(target, chunk);
        } catch (e) {
          stdout.writeln('Gagal print: $e');
        }
      },
      onDone: () => socket.destroy(),
      onError: (_) => socket.destroy(),
    );
  }
}

List<String> listInstalledPrinters() {
  final names = <String>[];
  final pBuffSize = calloc<DWORD>();
  final pPrinterLen = calloc<DWORD>();
  try {
    EnumPrinters(
        PRINTER_ENUM_LOCAL, nullptr, 2, nullptr, 0, pBuffSize, pPrinterLen);
    if (pBuffSize.value == 0) return names;

    final raw = calloc<BYTE>(pBuffSize.value);
    try {
      final ok = EnumPrinters(PRINTER_ENUM_LOCAL, nullptr, 2, raw,
          pBuffSize.value, pBuffSize, pPrinterLen);
      if (ok == 0) return names;
      for (var i = 0; i < pPrinterLen.value; i++) {
        final printer = raw.cast<PRINTER_INFO_2>() + i;
        names.add(printer.ref.pPrinterName.toDartString());
      }
    } finally {
      free(raw);
    }
  } finally {
    free(pBuffSize);
    free(pPrinterLen);
  }
  return names;
}

void rawPrint(String printerName, Uint8List data) {
  final hPrinter = calloc<HANDLE>();
  final docInfo = calloc<DOC_INFO_1>();
  final printerNamePtr = printerName.toNativeUtf16();
  final docNamePtr = 'ESC/POS Print Job'.toNativeUtf16();

  try {
    if (OpenPrinter(printerNamePtr, hPrinter, nullptr) != 0) {
      final handle = hPrinter.value;

      if (StartDocPrinter(handle, 1, docInfo.cast()) != 0) {
        StartPagePrinter(handle);

        final pData = calloc<BYTE>(data.length);
        try {
          pData.asTypedList(data.length).setAll(0, data);
          final bytesWritten = calloc<DWORD>();
          WritePrinter(handle, pData, data.length, bytesWritten);
          free(bytesWritten);
        } finally {
          free(pData);
        }

        EndPagePrinter(handle);
        EndDocPrinter(handle);
      }

      ClosePrinter(handle);
    } else {
      stdout.writeln('OpenPrinter gagal untuk "$printerName"');
    }
  } finally {
    free(printerNamePtr);
    free(docNamePtr);
    free(hPrinter);
    free(docInfo);
  }
}
