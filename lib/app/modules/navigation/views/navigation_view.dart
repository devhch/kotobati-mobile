import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kotobati/app/routes/app_pages.dart';
import 'package:kotobati/app/widgets/mirai_bottom_bar_view.dart';

import '../controllers/navigation_controller.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({Key? key}) : super(key: key);

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView>
    with TickerProviderStateMixin {
  /// NavigationController
  final NavigationController _navigationController =
      Get.find<NavigationController>();

  /// AnimationController
  late AnimationController _controller;
  late Animation<double> _animationScaleOut;
  late Animation<double> _animationScaleIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animationScaleOut = CurvedAnimation(
      curve: const Interval(0.0, 0.5),
      parent: _controller,
    );

    _animationScaleIn = CurvedAnimation(
      curve: const Interval(0.5, 1.0),
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        key: _navigationController.drawerKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: GetBuilder<NavigationController>(
          init: _navigationController,
          builder: (NavigationController navigationController) {
            return Stack(
              children: <Widget>[
                Positioned.fill(child: navigationController.tabBody),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _BottomNavigationBar(
                    orientation: Orientation.portrait,
                    navigationController: navigationController,
                    controller: _controller,
                    animationScaleIn: _animationScaleIn,
                    animationScaleOut: _animationScaleOut,
                  ),
                ),
              ],
            );
          },
        ),
        // drawer: const SideMenuView(),
        //  onDrawerChanged: (bool isOpened) {
        //    if (!isOpened) {
        //      /// Navigate to the previous page
        //      _navigationController.setIndex(
        //        index: _navigationController.previousIndex,
        //      );
        //    }
        //  },
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    Key? key,
    required this.navigationController,
    required this.orientation,
    required this.controller,
    required this.animationScaleOut,
    required this.animationScaleIn,
  }) : super(key: key);

  final Orientation orientation;
  final NavigationController navigationController;

  /// AnimationController
  final AnimationController controller;
  final Animation<double> animationScaleOut;
  final Animation<double> animationScaleIn;

  @override
  Widget build(BuildContext context) {
    return MiraiBottomBarView(
      tabIconsList: navigationController.tabIconsList,
      isScrolling: navigationController.isScrolling,
      isFabBarAdding: navigationController.isFabBarAdding,
      orientation: orientation,
      controller: controller,
      animationScaleIn: animationScaleIn,
      animationScaleOut: animationScaleOut,
      changeIndex: (int index) {
        navigationController.setIndex(index: index);
      },
      addClick: () => Get.toNamed(Routes.notes),
    );
  }
}
