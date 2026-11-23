import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../localization/app_strings.dart';
import '../models/student.dart';

class StudentInfoScreen extends StatelessWidget {
  final String languageCode;
  final Future<void> Function(String) onLanguageChanged;

  const StudentInfoScreen({
    super.key,
    required this.languageCode,
    required this.onLanguageChanged,
  });

  String _intlLocale(String code) {
    switch (code) {
      case 'gu':
        return 'gu_IN';
      case 'hi':
        return 'hi_IN';
      default:
        return 'en_IN';
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(languageCode);
    final intlLocale = _intlLocale(languageCode);

    final student = Student(
      name: 'Diva Parekh',
      enrollmentNo: '92400133161',
      department: strings.get('ICT Department'),
      semester: 5,
      cgpa: 9.15,
      tuitionFee: 58500,
      admissionDate: DateTime(2023, 8, 14),
    );

    final formattedDate = DateFormat.yMMMMd(
      intlLocale,
    ).format(student.admissionDate);
    final formattedSemester = NumberFormat.decimalPattern(
      intlLocale,
    ).format(student.semester);
    final formattedCgpa = NumberFormat('0.00', intlLocale).format(student.cgpa);
    final formattedFee = NumberFormat.currency(
      locale: intlLocale,
      symbol: '₹',
      decimalDigits: 0,
    ).format(student.tuitionFee);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.get('appTitle')),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selection Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.get('selectLanguage'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'en', label: Text('English')),
                        ButtonSegment(value: 'gu', label: Text('ગુજરાતી')),
                        ButtonSegment(value: 'hi', label: Text('हिन्दी')),
                      ],
                      selected: {languageCode},
                      onSelectionChanged: (Set<String> newSelection) async {
                        final selected = newSelection.first;
                        await onLanguageChanged(selected);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppStrings(selected).get('refreshNotice'),
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Greeting Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.get('greeting'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(strings.get('subtitle')),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Student Details Card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        student.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${strings.get('enrollment')}: ${student.enrollmentNo}',
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.school),
                      title: Text(strings.get('department')),
                      subtitle: Text(student.department),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.format_list_numbered),
                      title: Text(strings.get('semester')),
                      trailing: Text(
                        formattedSemester,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.grade),
                      title: Text(strings.get('cgpa')),
                      trailing: Text(
                        formattedCgpa,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.payments),
                      title: Text(strings.get('tuitionFee')),
                      trailing: Text(
                        formattedFee,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(strings.get('admissionDate')),
                      trailing: Text(
                        formattedDate,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.verified_user,
                        color: Colors.yellowAccent,
                      ),
                      title: Text(strings.get('statusLabel')),
                      trailing: Chip(label: Text(strings.get('statusActive'))),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Reset Button
            if (languageCode != 'en')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => onLanguageChanged('en'),
                  child: Text(strings.get('resetButton')),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
