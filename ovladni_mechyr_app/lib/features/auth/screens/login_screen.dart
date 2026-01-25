import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/auth_notifier.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/core/services/auth_service.dart';
import 'package:uzis_app/core/services/voiding_service.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/features/auth/models/user_model.dart';
import 'package:uzis_app/features/auth/repositories/user_repository.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_diary_model.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:uzis_app/shared/widgets/custom_checkbox.dart';
import 'package:uzis_app/shared/widgets/input_filed.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late UserRepository userRepository;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isChecked = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    const secureStorage = FlutterSecureStorage();
    SharedPreferences.getInstance().then((prefs) {
      userRepository = UserRepository(prefs, secureStorage);
      setSavedCredentials();
    });
  }

  void handleOnChangedCheckox() {
    setState(() => isChecked = !isChecked);
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text;
    final password = passwordController.text;
    String redirectPath = "/";

    setState(() => isLoading = true);

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      setState(() => isLoading = false);
      return CustomSnackbar.showError(
          "Zkontorlujte si vaše internetové připojení!");
    }
    try {
      final userData = await AuthService().login(email, password);
      await userRepository.saveUserData(userData);
      hanldeSavedCredentials();
      if (!userData.user.roles.contains(UserRole.patient)) {
        redirectPath = "/patient-only";
        if (!mounted) return;
        Future.wait([
          context.read<AuthNotifier>().setIsLogged(true),
          context.read<AuthNotifier>().setUserRoles(userData.user.roles),
        ]);
        CustomSnackbar.showSuccess("Přihlášení bylo úspěšné!");
        if (!mounted) return;
        context.go(redirectPath);
        return;
      }

      VoidingDiary? latestVoidingDiary =
          await VoidingService().fetchLatestVoidingDiary();
      if (!mounted) return;

      if (latestVoidingDiary == null || latestVoidingDiary.completed == true) {
        await context.read<AuthNotifier>().setUncompletedDiaryId(null);
        redirectPath = "/";
      } else {
        await context
            .read<AuthNotifier>()
            .setUncompletedDiaryId(latestVoidingDiary.id.toString());
        redirectPath = "/voiding-diary/${latestVoidingDiary.id.toString()}";
      }
      if (!mounted) return;

      Future.wait([
        context.read<AuthNotifier>().setIsLogged(true),
        context.read<AuthNotifier>().setUserRoles(userData.user.roles),
      ]);
      CustomSnackbar.showSuccess("Přihlášení bylo úspěšné!");
      context.go(redirectPath);
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> hanldeSavedCredentials() async {
    final email = emailController.text;
    final password = passwordController.text;
    if (isChecked) {
      await userRepository.saveCredentials(email, password);
    } else {
      await userRepository.deleteCredentials();
    }
  }

  Future<void> setSavedCredentials() async {
    final credentials = await userRepository.getCredentials();
    if (credentials != null) {
      setState(() {
        emailController.text = credentials.email;
        passwordController.text = credentials.password;
        isChecked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                spacing: 32,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/uzis_logo.svg",
                    width: 150,
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border:
                            Border.all(color: AppColors.darkBlueBase, width: 1),
                        borderRadius: AppStyles.borderRadius.xl,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(201, 255, 0, 0.6),
                            offset: Offset(0, 0),
                            blurRadius: 0,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 24,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "PŘIHLÁŠENÍ",
                                      style: AppStyles.text.header,
                                    ),
                                  ],
                                ),
                                // const Row(
                                //   children: [
                                //     Text(
                                //       "Zadejte vaše přihlašovací jméno a heslo",
                                //       style: TextStyle(
                                //         fontSize: 14,
                                //         color: AppColors.gray500,
                                //         fontWeight: FontWeight.w400,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                spacing: 16,
                                children: [
                                  InputField(
                                    controller: emailController,
                                    labelText: "E-mail",
                                    hintText: "Zadejte váš e-mail",
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Zadejte váš e-mail";
                                      } else if (!RegExp(
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                          .hasMatch(value)) {
                                        return "Zadejte platný e-mail";
                                      }
                                      return null;
                                    },
                                  ),
                                  InputField(
                                    controller: passwordController,
                                    labelText: "Heslo",
                                    hintText: "Zadejte vaše heslo",
                                    secondaryLabel: "Zapomenuté heslo",
                                    onSecondaryLabelTap: () =>
                                        context.push("/forgotten-password"),
                                    obscureText: true,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Zadejte vaše heslo";
                                      }
                                      return null;
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: handleOnChangedCheckox,
                                    child: Row(
                                      spacing: 8,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomCheckbox(
                                          isChecked: isChecked,
                                          onChanged: handleOnChangedCheckox,
                                        ),
                                        const Expanded(
                                          child: Text(
                                            "Zapamatovat si přihlašovací údaje",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF18181B),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Button(
                                    text: "Přihlásit se",
                                    onPressed: login,
                                    isLoading: isLoading,
                                  ),

                                  // Text.rich(
                                  //   TextSpan(
                                  //     text: "Nemáte účet? ",
                                  //     style: const TextStyle(
                                  //       fontSize: 14,
                                  //       color: AppColors.gray700,
                                  //       fontWeight: FontWeight.w500,
                                  //     ),
                                  //     children: [
                                  //       TextSpan(
                                  //         text: "Registrovat se",
                                  //         style: const TextStyle(
                                  //           fontSize: 14,
                                  //           color: AppColors.gray700,
                                  //           fontWeight: FontWeight.w500,
                                  //           decoration:
                                  //               TextDecoration.underline,
                                  //         ),
                                  //         recognizer: TapGestureRecognizer()
                                  //           ..onTap = () {
                                  //             context.go("/register");
                                  //           },
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
