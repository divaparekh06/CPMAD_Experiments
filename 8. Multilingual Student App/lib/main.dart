import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/student_info_screen.dart';

const String _kLanguageKey = 'selected_language_code';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  final prefs = await SharedPreferences.getInstance();
  final savedLanguage = prefs.getString(_kLanguageKey) ?? 'en';

  runApp(MultilingualStudentApp(initialLanguageCode: savedLanguage));
}

class MultilingualStudentApp extends StatefulWidget {
  final String initialLanguageCode;

  const MultilingualStudentApp({super.key, required this.initialLanguageCode});

  @override
  State<MultilingualStudentApp> createState() => _MultilingualStudentAppState();
}

class _MultilingualStudentAppState extends State<MultilingualStudentApp> {
  late String _languageCode;

  @override
  void initState() {
    super.initState();
    _languageCode = widget.initialLanguageCode;
  }

  Future<void> _changeLanguage(String newCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguageKey, newCode);
    setState(() {
      _languageCode = newCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multilingual Student Information App',
      locale: Locale(_languageCode),
      supportedLocales: const [Locale('en'), Locale('gu'), Locale('hi')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: StudentInfoScreen(
        languageCode: _languageCode,
        onLanguageChanged: _changeLanguage,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
