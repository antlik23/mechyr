import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/auth_notifier.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/features/auth/repositories/user_repository.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:uzis_app/shared/widgets/button_outlined.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late String patientId;

  Future<bool> cleanUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    return true;
  }

  @override
  void initState() {
    super.initState();
    getPatientId();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> getPatientId() async {
    const secureStorage = FlutterSecureStorage();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = await UserRepository(prefs, secureStorage).getUserData();
    if (userData == null) return;
    setState(() {
      patientId = userData.user.patientPublicId ?? "Neznámé ID";
    });
  }

  void toggleDrawer() {
    setState(() {
      if (_scaffoldKey.currentState?.isEndDrawerOpen == false) {
        _animationController.forward();
        _scaffoldKey.currentState?.openEndDrawer();
      } else {
        _animationController.reverse();
        _scaffoldKey.currentState?.closeEndDrawer();
      }
    });
  }

  void logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                const Text(
                  "Opravdu se chcete odhlásit?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlueBase,
                  ),
                ),
                Row(
                  spacing: 4,
                  children: [
                    Expanded(
                      child: ButtonOutlined(
                        text: "Zavřít",
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ),
                    Expanded(
                      child: Button(
                        text: "Potvrdit",
                        onPressed: () async {
                          Future.wait([
                            context.read<AuthNotifier>().setIsLogged(false),
                            context
                                .read<AuthNotifier>()
                                .setUncompletedDiaryId(null),
                          ]);
                          cleanUserData();
                          CustomSnackbar.showSuccess(
                              "Byli jste úspěšně odhlášeni!");
                          if (!context.mounted) return;
                          context.go("/login");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        toolbarHeight: 74,
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/images/uzis_logo.svg',
              height: 34,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              spacing: 8,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF3F8FA),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/CircleUser.svg",
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.darkBlueBase,
                        BlendMode.srcIn,
                      ),
                    ),
                    color: AppColors.darkBlueBase,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            insetPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 16,
                                children: [
                                  const Text(
                                    "Vaše ID",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.darkBlueBase,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    patientId,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: AppColors.gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Button(
                                    text: "Zavřít",
                                    onPressed: context.pop,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Sidemenu
                // Container(
                //   decoration: const BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Color(0xFFF3F8FA),
                //   ),
                //   child: IconButton(
                //     icon: AnimatedIcon(
                //       icon: AnimatedIcons.menu_close,
                //       progress: _animationController,
                //       color: AppColors.darkBlueBase,
                //       size: 20,
                //     ),
                //     onPressed: toggleDrawer,
                //   ),
                // ),

                // Logout Button
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF3F8FA),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/Logout.svg",
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.darkBlueBase,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: logout,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Scaffold(
        key: _scaffoldKey,
        body: widget.child,
        // endDrawer: Drawer(
        //   shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.zero,
        //   ),
        //   width: MediaQuery.of(context).size.width,
        //   child: MenuScreen(
        //     toggleDrawer: toggleDrawer,
        //   ),
        // ),
      ),
    );
  }
}
