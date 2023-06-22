import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/navigation/bindings/navigation_binding.dart';
import '../modules/navigation/views/navigation_view.dart';
import '../modules/notes/bindings/notes_binding.dart';
import '../modules/notes/views/notes_view.dart';
import '../modules/pdf_reader/bindings/pdf_reader_binding.dart';
import '../modules/pdf_reader/views/pdf_reader_view.dart';
import '../modules/planing/bindings/planing_binding.dart';
import '../modules/planing/views/planing_view.dart';
import '../modules/reading/bindings/reading_binding.dart';
import '../modules/reading/views/reading_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/serach/bindings/serach_binding.dart';
import '../modules/serach/views/serach_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.navigation,
      page: () => const NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.READING,
      page: () => const ReadingView(),
      binding: ReadingBinding(),
    ),
    GetPage(
      name: _Paths.PLANING,
      page: () => const PlaningView(),
      binding: PlaningBinding(),
    ),
    GetPage(
      name: _Paths.NOTES,
      page: () => const NotesView(),
      binding: NotesBinding(),
    ),
    GetPage(
      name: _Paths.PDF_READER,
      page: () => const PdfReaderView(),
      binding: PdfReaderBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
  ];
}
