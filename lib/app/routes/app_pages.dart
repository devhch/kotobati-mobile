import 'package:get/get.dart';

import '../modules/book_details/bindings/book_details_binding.dart';
import '../modules/book_details/views/book_details_view.dart';
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
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const String initial = Routes.splash;

  static final List<GetPage<void>> routes = <GetPage<void>>[
    GetPage<void>(
      name: _Paths.navigation,
      page: () => const NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage<void>(
      name: _Paths.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage<void>(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage<void>(
      name: _Paths.reading,
      page: () => const ReadingView(),
      binding: ReadingBinding(),
    ),
    GetPage<void>(
      name: _Paths.planing,
      page: () => const PlaningView(),
      binding: PlaningBinding(),
    ),
    GetPage<void>(
      name: _Paths.notes,
      page: () => const NotesView(),
      binding: NotesBinding(),
    ),
    GetPage<void>(
      name: _Paths.pdfReader,
      page: () => const PdfReaderView(),
      binding: PdfReaderBinding(),
    ),
    GetPage<void>(
      name: _Paths.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage<void>(
      name: _Paths.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage<void>(
      name: _Paths.bookDetails,
      page: () => const BookDetailsView(),
      binding: BookDetailsBinding(),
    ),
  ];
}
