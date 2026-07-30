import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfReportService {
  static Future<pw.Document> buildSalesReport({
    required List orders,
    String? periodLabel,
  }) async {
    final doc = pw.Document();

    double totalRevenue = 0;
    for (final order in orders) {
      totalRevenue += double.tryParse(order['total_price'].toString()) ?? 0;
    }

    final now = DateTime.now();
    final generatedAt = _formatDateTime(now);

    final rows = <List<String>>[];
    var no = 1;
    for (final order in orders) {
      final items = (order['items'] as List?) ?? [];
      final itemsText = items
          .map((it) => '${it['quantity']}x ${it['product_name'] ?? '-'}')
          .join(', ');
      final total = double.tryParse(order['total_price'].toString()) ?? 0;

      rows.add([
        '${no++}',
        (order['order_number'] ?? '-').toString(),
        (order['table_number'] ?? '-').toString(),
        _formatDateTime(_tryParseDate(order['created_at'])),
        itemsText.isEmpty ? '-' : itemsText,
        _formatRupiah(total),
      ]);
    }

    // Header tabel — dipakai di tableHeader supaya repeat tiap halaman
    final tableHeaders = ['No', 'Invoice', 'Pemesan', 'Tanggal', 'Item', 'Total'];

    const columnWidths = {
      0: pw.FlexColumnWidth(0.5),
      1: pw.FlexColumnWidth(1.3),
      2: pw.FlexColumnWidth(1.1),
      3: pw.FlexColumnWidth(1.4),
      4: pw.FlexColumnWidth(2.8),
      5: pw.FlexColumnWidth(1.3),
    };

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Laporan Penjualan',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              'Warung Soto Mbok Kerso',
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey700,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Periode: ${periodLabel ?? 'Semua Transaksi'}',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
            pw.Text(
              'Dicetak pada: $generatedAt',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Divider(color: PdfColors.grey400),
          ],
        ),
        footer: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              'Halaman ${context.pageNumber} dari ${context.pagesCount}',
              style: const pw.TextStyle(
                fontSize: 9,
                color: PdfColors.grey600,
              ),
            ),
          ],
        ),
        build: (context) => [
          // ── Ringkasan ──
          pw.Container(
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(
              color: PdfColors.red900,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Total Pendapatan',
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      _formatRupiah(totalRevenue),
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Jumlah Transaksi',
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '${orders.length}',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 18),

          // ── Tabel dengan header repeat tiap halaman ──
          if (rows.isEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 24),
              child: pw.Center(
                child: pw.Text(
                  'Tidak ada transaksi pada periode ini.',
                  style: const pw.TextStyle(color: PdfColors.grey600),
                ),
              ),
            )
          else
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(
                color: PdfColors.grey300,
                width: 0.5,
              ),
              columnWidths: columnWidths,
              // ✅ Header repeat otomatis tiap halaman
              headers: tableHeaders,
              headerStyle: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              headerPadding: const pw.EdgeInsets.all(6),
              data: rows,
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellPadding: const pw.EdgeInsets.all(6),
              rowDecoration: const pw.BoxDecoration(
                color: PdfColors.white,
              ),
              oddRowDecoration: const pw.BoxDecoration(
                color: PdfColors.grey50,
              ),
            ),
        ],
      ),
    );

    return doc;
  }

  static Future<void> previewSalesReport({
    required List orders,
    String? periodLabel,
  }) async {
    final doc = await buildSalesReport(
      orders: orders,
      periodLabel: periodLabel,
    );
    final bytes = await doc.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'laporan-penjualan-mbok-kerso.pdf',
    );
  }

  static DateTime? _tryParseDate(dynamic isoDate) {
    if (isoDate == null) return null;
    try {
      return DateTime.parse(isoDate.toString()).toLocal();
    } catch (_) {
      return null;
    }
  }

  static String _formatDateTime(DateTime? dt) {
    if (dt == null) return '-';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m';
  }

  static String _formatRupiah(double amount) {
    final result = amount.toInt().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return 'Rp ${result.replaceAllMapped(reg, (m) => '${m[1]}.')}';
  }
}