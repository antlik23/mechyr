import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:uzis_app/shared/widgets/custom_checkbox.dart';
import 'package:uzis_app/shared/widgets/input_filed.dart';

//todo:
// REGISTER IS NOT COMPLETED
// register is not needed in the current version
// if the request changes, the logic needs to be completed

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRepeatController = TextEditingController();

  String? gender;
  bool isChecked = false;

  List<String> genders = ["Muž", "Žena"];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailontroller.dispose();
    passwordController.dispose();
    passwordRepeatController.dispose();
    super.dispose();
  }

  void handleOnChangedGender(String? value) {
    setState(() => gender = value);
  }

  void handleOnChangedCheckox() {
    setState(() => isChecked = !isChecked);
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
                        border: Border.all(
                            color: const Color(0xFFE4E4E7), width: 1),
                        borderRadius: AppStyles.borderRadius.xl,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x05000000),
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 24,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Registrace",
                                  style: AppStyles.text.header,
                                ),
                              ],
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                spacing: 16,
                                children: [
                                  InputField(
                                    controller: emailontroller,
                                    labelText: "E-mail",
                                    hintText: "Zadejte e-mail",
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Zadejte e-mail";
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
                                    hintText: "Zadejte heslo",
                                    obscureText: true,
                                  ),
                                  InputField(
                                    controller: passwordRepeatController,
                                    labelText: "Zopakovat heslo",
                                    hintText: "Zopakujte zadané heslo",
                                    obscureText: true,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Vyplňte povinné pole";
                                      } else if (value !=
                                          passwordController.text) {
                                        return "Hesla se musí shodovat";
                                      }
                                      return null;
                                    },
                                  ),
                                  // SelectField(
                                  //   labelText: "Pohlaví",
                                  //   hintText: "Vyberte pohlaví",
                                  //   value: gender,
                                  //   onChanged: handleOnChangedGender,
                                  //   items: genders,
                                  // ),
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
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              text:
                                                  "Souhlas s podmínkami užití a ",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: AppColors.gray700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "zpracováním osobních údajů",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.gray700,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                  //TODO tap to text
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {},
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Button(
                                    text: "Registrovat se",
                                    //TODO on pressed
                                    onPressed: () {
                                      _formKey.currentState!.validate();
                                    },
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: "Máte registrovaný účet? ",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.gray700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Přihlaste se",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.gray700,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              context.go("/login");
                                            },
                                        ),
                                      ],
                                    ),
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
