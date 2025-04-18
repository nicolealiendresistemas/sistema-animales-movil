import 'package:flutter/material.dart';
import 'package:sistema_animales/screens/adoption/adoption_form_screen.dart';
import 'package:sistema_animales/screens/animal/animal_form_screen.dart';
import 'package:sistema_animales/screens/animal/animal_list_screen.dart';
import 'package:sistema_animales/screens/geolocation/geolocation_screen.dart';
import 'package:sistema_animales/screens/report/report_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import 'package:sistema_animales/screens/adoption/adoption_list_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String animals = '/animals';
  static const String animalForm = '/animal-form';
  static const String geolocation = '/geolocation';
  static const String adoptionList = '/adoption-list';
  static const String adoptionForm = '/adoption-form';
  static const String report = '/report';

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => SplashScreen(),
    login: (_) => LoginScreen(),
    register: (_) => RegisterScreen(),
    animals: (_) => AnimalListScreen(),
    animalForm: (_) => const AnimalFormScreen(),
    geolocation: (_) => const GeolocationScreen(),
    adoptionList: (_) => const AdoptionListScreen(),
    adoptionForm: (_) => const AdoptionFormScreen(),
    report: (_) => const ReportScreen(),

  };
}
