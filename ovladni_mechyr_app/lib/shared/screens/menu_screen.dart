import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/auth_notifier.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:uzis_app/shared/widgets/button_outlined.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    super.key,
    required this.toggleDrawer,
  });

  final void Function() toggleDrawer;

  Future<bool> cleanUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouter.of(context).state?.fullPath;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            // POZNÁMKA: "Hlavní stránka" a "Mikční deník" jsou stejná stránka (/)
                            // Ponecháno pouze "Mikční deník" pro lepší srozumitelnost
                            // MenuItem(
                            //   title: "Hlavní stránka",
                            //   iconPath: "assets/icons/Home.svg",
                            //   isActive: path == "/",
                            //   onTap: () {
                            //     context.go("/");
                            //     toggleDrawer();
                            //   },
                            // ),
                            // MenuItem(
                            //   title: "Urologické dotazníky",
                            //   iconPath: "assets/icons/File.svg",
                            //   isActive: false,
                            //   onTap: () {},
                            // ),
                            // MenuItem(
                            //   title: "Anamnestický dotazník",
                            //   iconPath: "assets/icons/FolderPlus.svg",
                            //   isActive: false,
                            //   onTap: () {},
                            // ),
                            MenuItem(
                              title: "Mikční deník",
                              iconPath: "assets/icons/LineChart.svg",
                              isActive: path == "/",
                              onTap: () {
                                context.go("/");
                                toggleDrawer();
                              },
                            ),
                            // MenuItem - ZAKOMENTOVÁNO: "Záznamy" nejsou v mobile app implementované
                            // Ve webové verzi zobrazují přehled všech formulářů a deníků
                            // MenuItem(
                            //   title: "Záznamy",
                            //   iconPath: "assets/icons/AppWindow.svg",
                            //   isActive: false,
                            //   onTap: () {},
                            // ),
                            MenuItem(
                              title: "Výběr lékaře",
                              iconPath: "assets/icons/BriefcaseMedical.svg",
                              isActive: path == "/doctor-list",
                              // isHighlighted: true, // ZAKOMENTOVÁNO: V mobile menu jsou jen 2 položky, zvýraznění není potřeba
                              onTap: () {
                                context.go("/doctor-list");
                                toggleDrawer();
                              },
                            ),
                            // MenuItem(
                            //   title: "Technická podpora",
                            //   iconPath:
                            //       "assets/icons/MessageCircleQuestion.svg",
                            //   isActive: false,
                            //   onTap: () {},
                            // ),
                          ],
                        ),
                      ),
                      MenuItem(
                        title: "Odhlásit se",
                        iconPath: "assets/icons/Logout.svg",
                        isActive: false,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
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
                                                  context
                                                      .read<AuthNotifier>()
                                                      .setIsLogged(false),
                                                  context
                                                      .read<AuthNotifier>()
                                                      .setUncompletedDiaryId(
                                                          null),
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
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.title,
    required this.iconPath,
    required this.isActive,
    required this.onTap,
    this.isHighlighted = false,
  });

  final String title;
  final String iconPath;
  final bool isActive;
  final bool isHighlighted;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    Color bgColor = isActive
        ? const Color(0xFFEDF2FF)
        : isHighlighted
            ? const Color(0xFFFFF7ED)
            : AppColors.transparent;
    Color iconColor = isActive
        ? AppColors.darkBlueBase
        : isHighlighted
            ? const Color(0xFFD97706)
            : const Color(0xFF506083);
    Color textColor = isActive
        ? AppColors.darkBlueBase
        : isHighlighted
            ? const Color(0xFFD97706)
            : const Color(0xFF506083);
    FontWeight fontWeight =
        isActive || isHighlighted ? FontWeight.w600 : FontWeight.w500;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppStyles.borderRadius.lg,
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
        leading: SvgPicture.asset(
          iconPath,
          width: 20,
          colorFilter: ColorFilter.mode(
            iconColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
