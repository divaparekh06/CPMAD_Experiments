class AppStrings {
  final String languageCode;

  AppStrings(this.languageCode);

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Student Information',
      'selectLanguage': 'Select Language',
      'greeting': 'Welcome back, Diva!',
      'subtitle': 'Here is your academic profile and fee summary.',
      'enrollment': 'Enrollment No.',
      'department': 'Department',
      'ictDept': 'Information & Communication Technology',
      'semester': 'Semester',
      'cgpa': 'Current CGPA',
      'tuitionFee': 'Semester Tuition Fee',
      'admissionDate': 'Admission Date',
      'statusLabel': 'Academic Status',
      'statusActive': 'Enrolled & Active',
      'refreshNotice': 'Language preference saved locally.',
      'resetButton': 'Reset to English',
    },
    'gu': {
      'appTitle': 'વિદ્યાર્થી માહિતી',
      'selectLanguage': 'ભાષા પસંદ કરો',
      'greeting': 'દિવા, તમારું સ્વાગત છે!',
      'subtitle': 'અહીં તમારી શૈક્ષણિક પ્રોફાઇલ અને ફીની વિગત છે.',
      'enrollment': 'નોંધણી નંબર',
      'department': 'વિભાગ',
      'ictDept': 'માહિતી અને સંચાર ટેકનોલોજી',
      'semester': 'સેમેસ્ટર',
      'cgpa': 'વર્તમાન CGPA',
      'tuitionFee': 'સેમેસ્ટર ટ્યુશન ફી',
      'admissionDate': 'પ્રવેશ તારીખ',
      'statusLabel': 'શૈક્ષણિક સ્થિતિ',
      'statusActive': 'નોંધાયેલ અને સક્રિય',
      'refreshNotice': 'ભાષાની પસંદગી સ્થાનિક રીતે સાચવવામાં આવી છે.',
      'resetButton': 'અંગ્રેજી પર રીસેટ કરો',
    },
    'hi': {
      'appTitle': 'छात्र जानकारी',
      'selectLanguage': 'भाषा चुनें',
      'greeting': 'दीवा, आपका स्वागत है!',
      'subtitle': 'यहाँ आपकी शैक्षणिक प्रोफ़ाइल और शुल्क विवरण है।',
      'enrollment': 'नामांकन संख्या',
      'department': 'विभाग',
      'ictDept': 'सूचना और संचार प्रौद्योगिकी',
      'semester': 'सेमेस्टर',
      'cgpa': 'वर्तमान CGPA',
      'tuitionFee': 'सेमेस्टर ट्यूशन शुल्क',
      'admissionDate': 'प्रवेश तिथि',
      'statusLabel': 'शैक्षणिक स्थिति',
      'statusActive': 'नामांकित और सक्रिय',
      'refreshNotice': 'भाषा प्राथमिकता स्थानीय रूप से सहेजी गई है।',
      'resetButton': 'अंग्रेज़ी पर रीसेट करें',
    },
  };

  String get(String key) {
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }
}
