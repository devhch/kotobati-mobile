import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/core/models/mirai_tab_icon.dart';
import 'package:kotobati/app/data/persistence/hive_data_store.dart';
import 'package:kotobati/app/modules/home/views/home_view.dart';
import 'package:kotobati/app/modules/notes/views/notes_view.dart';
import 'package:kotobati/app/modules/planing/views/planing_view.dart';
import 'package:kotobati/app/modules/reading/views/reading_view.dart';

class NavigationController extends GetxController {
  /// Drawer Key
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  /// tabIconsList
  List<MiraiTabIcon> tabIconsList = MiraiTabIcon.tabIconsList;

  /// Page View Controller
  late PageController pageController;

  /// current page view.
  final ValueNotifier<int> currentPage = ValueNotifier<int>(0);

  /// tab body
  Widget tabBody = Container(color: Colors.transparent);

  /// To Handle previous back when drawer is closed
  int previousIndex = 0;

  /// bottomPadding for no internet connexion
  double bottomPadding = -400.0;

  /// bool isScrolling, listen when the user is scrolling
  ValueNotifier<bool> isScrolling = ValueNotifier<bool>(false);

  /// This code just to make navigation bottom bar icon
  /// start animating from bottom.
  ValueNotifier<bool> isFabBarAdding = ValueNotifier<bool>(false);

  /// Pages
  final List<Widget> pages = <Widget>[
    const HomeView(),
    const ReadingView(),
    const PlaningView(),
    const NotesView(),
  ];

  bool isBooksListNotEmpty = false;

  @override
  void onInit() {
    super.onInit();
    isBooksListNotEmpty = HiveDataStore().getBooks().isNotEmpty;
    pageController = PageController(initialPage: isBooksListNotEmpty ? 1 : 0);
    debugPrint("NavigationController onInit");
  }

  @override
  void onReady() {
    super.onReady();

    setIndex(index: isBooksListNotEmpty ? 1 : 0, jump: true);
    // setIndex(index: 0);

    debugPrint("NavigationController onReady");
  }

  @override
  void onClose() {
    debugPrint("NavigationController onClose");
  }

  void setIndex({
    AnimationController? controller,
    bool jump = false,
    required int index,
  }) {
    if (controller == null) {
      _changeBody(index, jump: jump);
    } else {
      controller.reverse().then<dynamic>((_) {
        _changeBody(index);
      });
    }

    /// Update...
    update();
  }

  void setCurrentPage(int index) {
    currentPage.value = index;
  }

  void _setSelectedTab(int index, List<MiraiTabIcon> tabIcons) {
    tabIconsList = List<MiraiTabIcon>.from(tabIcons);
    for (MiraiTabIcon tab in tabIcons) {
      tab.isSelected = false;
    }
    tabIcons[index].isSelected = true;
  }

  void _changeBody(int index, {bool jump = false}) {
    _setSelectedTab(index, MiraiTabIcon.tabIconsList);
    currentPage.value = index;
    if (!jump) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutQuint,
      );
    } else {
      pageController.jumpToPage(index);
    }
  }

// void _changeBody(int index) {
//   _setSelectedTab(index, MiraiTabIcon.tabIconsList);
//   previousIndex = index;
//   if (index == 1) {
//     tabBody = const ReadingView();
//   } else if (index == 2) {
//     tabBody = const PlaningView();
//   } else if (index == 3) {
//     tabBody = const NotesView();
//   } else {
//     tabBody = const HomeView();
//   }
// }
}
