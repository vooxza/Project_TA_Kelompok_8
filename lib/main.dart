import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_ta_kelompok_8/routes/pages.dart';
import 'package:project_ta_kelompok_8/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}
