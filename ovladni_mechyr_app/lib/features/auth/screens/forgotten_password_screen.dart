import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/core/routes/auth_routes.dart';
import 'package:uzis_app/core/services/auth_service.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:uzis_app/shared/widgets/input_filed.dart';

class ForgottenPasswordScreen extends StatefulWidget {
  const ForgottenPasswordScreen({super.key});

  @override
  State<ForgottenPasswordScreen> createState() =>
      _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> passwordForgot() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await AuthService().passwordForgot(emailController.text);
      if (!mounted) return;
      CustomSnackbar.showSuccess(
          "E-mail pro obnovení hesla byl odeslán. Zkontrolujte svou schránku.");
      context.go(AuthRoutes.Login);
    } catch (e) {
      CustomSnackbar.showError("Zkontrolujte si své údaje!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "ZAPOMENUTÉ HESLO",
                                    style: AppStyles.text.header,
                                  ),
                                ),
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
                                  ),
                                  Column(
                                    spacing: 8,
                                    children: [
                                      Button(
                                        text: "Obnovit heslo",
                                        onPressed: passwordForgot,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.go("/login");
                                        },
                                        child: const Text.rich(
                                          TextSpan(
                                            text: "Zpět na ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.gray700,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "Příhlásit se",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.gray700,
                                                  fontWeight: FontWeight.w500,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
