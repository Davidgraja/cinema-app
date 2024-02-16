import 'package:sealed_languages/sealed_languages.dart';

String getCountryByItsCode(String code ){
  String country; 

  try {
    country = NaturalLanguage.fromCodeShort(code).name;
  } catch (e) {
    country = code;
  }

  return country;
}