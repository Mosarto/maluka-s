import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malukas/data/provider/notifiers.dart';
import 'package:malukas/screens/app_screen.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Maluka's",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink[200]!,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffffc0ae),
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CurrentProductIndexCubit()),
          BlocProvider(create: (_) => CartCubit()),
        ],
        child: const AppScreen(),
      ),
    );
  }
}
