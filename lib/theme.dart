import 'package:flutter/material.dart';

// Palet monokrom lembut. Semua warna di app WAJIB dari sini.
const kInk = Color(0xFF424242); // gelap utama: tombol, FAB, avatar, bubble sendiri
const kText = Color(0xFF2E2E2E); // teks utama
const kSubtle = Color(0xFF8E8E8E); // teks sekunder: waktu, preview, hint
const kOnInk = Color(0xFFF5F5F5); // teks/ikon di atas kInk
const kBg = Color(0xFFF5F5F5); // background scaffold
const kChatBg = Color(0xFFECECEC); // background area pesan
const kSurface = Color(0xFFFAFAFA); // AppBar, input bar, bubble orang lain, dialog
const kField = Color(0xFFEAEAEA); // isi TextField
const kLine = Color(0xFFE4E4E4); // divider, border tipis

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: kBg,
  colorScheme: const ColorScheme.light(
    primary: kInk,
    onPrimary: kOnInk,
    surface: kSurface,
    onSurface: kText,
    outline: kLine,
  ),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: kText,
    displayColor: kText,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: kSurface,
    foregroundColor: kText,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: kText,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: kInk,
      foregroundColor: kOnInk,
      minimumSize: const Size(0, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kInk,
    foregroundColor: kOnInk,
    elevation: 0,
    shape: CircleBorder(),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kField,
    hintStyle: const TextStyle(color: kSubtle),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: kSurface,
    surfaceTintColor: Colors.transparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: kSurface,
    surfaceTintColor: Colors.transparent,
  ),
  dividerTheme: const DividerThemeData(color: kLine, thickness: 1),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: kInk),
);
