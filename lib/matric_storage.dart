import 'package:shared_preferences/shared_preferences.dart';

class MatricStorage {
  static String matric = '';

  Future<void> loadMatric() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    matric = prefs.getString('matric') ?? '';
  }

  getMatric() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    matric = prefs.getString('matric')!;
    return matric;
  }

  //MEthod to save matric to SharedPreferences
  Future<void> saveMatric(String newMatric) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('matric', newMatric);
    matric = newMatric;
  }
}
