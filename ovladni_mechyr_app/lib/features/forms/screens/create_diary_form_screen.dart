import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/core/services/notification_service.dart';
import 'package:uzis_app/core/services/user_service.dart';
import 'package:uzis_app/core/services/voiding_service.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/features/auth/models/user_model.dart';
import 'package:uzis_app/features/auth/repositories/user_repository.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_diary_model.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:uzis_app/shared/widgets/datetime_picker.dart';
import 'package:uzis_app/shared/widgets/select_field.dart';

class CreateDiaryFormScreen extends StatefulWidget {
  const CreateDiaryFormScreen({super.key});

  @override
  State<CreateDiaryFormScreen> createState() => _CreateDiaryFormScreenState();
}

class _CreateDiaryFormScreenState extends State<CreateDiaryFormScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController startDate = TextEditingController();

  String startDateText = "";
  String endDateText = "";

  int? duration;

  bool isLoading = false;

  @override
  void dispose() {
    startDate.dispose();
    super.dispose();
  }

  Future<UserModel?> fetchUser() async {
    const secureStorage = FlutterSecureStorage();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = await UserRepository(prefs, secureStorage).getUserData();
    final userId = userData?.user.id;

    if (userId == null) return null;
    return await UserService().fetchUser(userId);
  }

  Future<void> createVoidingDiary() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final user = await fetchUser();
      if (user != null && user.anamnesticFormIds.isEmpty) {
        return CustomSnackbar.showError(
            "Je zapotřebí mít vyplněný Anamnestický dotazník!");
      }
      final response = await VoidingService().createVoidingDiary({
        "diary_start_date":
            DateFormat("d. M. yyyy").parse(startDate.text).toIso8601String(),
        "diary_duration_days": duration,
      });
      if (!mounted) return;
      CustomSnackbar.showSuccess("Mikční deník byl vytvořen.");
      final parsedDate = DateFormat("d. M. yyyy").parse(startDate.text);
      final selectedDateAt8AM = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        8, // 8:00 AM
      );
      NotificationService().scheduleNotification(
        id: NotificationService.startDiaryId,
        selectedTime: selectedDateAt8AM,
        title: "Váš mikční deník začal!",
        body: "Začněte s vašim prvním záznamem.",
      );
      final parsedEndDate = DateFormat("d. M. yyyy")
          .parse(startDate.text)
          .add(Duration(days: duration!));
      final endDateAtNoon = DateTime(
        parsedEndDate.year,
        parsedEndDate.month,
        parsedEndDate.day,
        12, // 12:00 PM
      );
      NotificationService().scheduleNotification(
        id: NotificationService.endDiaryId,
        selectedTime: endDateAtNoon,
        title: "Váš mikční deník končí!",
        body: "Zkontrolujte si vaše záznamy a potvrdťe ukončení.",
      );
      context.go("/voiding-diary/${response.id.toString()}");
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void handleChangeStartDate(String? value) {
    if (value == null) return;

    setState(() {
      startDateText = value;

      if (endDateText.isNotEmpty && duration != null) {
        final newStartDate = DateFormat('d. M. yyyy').parse(value);
        final newEndDate = newStartDate.add(Duration(days: duration!));

        endDateText = DateFormat('d. M. yyyy').format(newEndDate);
      }
    });
  }

  void handleChangeEndDate(DurationType? value) {
    if (value == null || startDate.text.isEmpty) return;

    final days = value.toApiInt();

    setState(() {
      duration = value.toApiInt();

      final startDate = DateFormat('d. M. yyyy').parse(startDateText);
      final endDate = startDate.add(Duration(days: days));

      endDateText = DateFormat('d. M. yyyy').format(endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              spacing: 16,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 16,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.blueLighter,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x19000000),
                                spreadRadius: 2.0,
                                blurRadius: 8.0,
                                offset: Offset(2, 4),
                              )
                            ],
                            borderRadius: AppStyles.borderRadius.lg,
                          ),
                          child: Row(
                            spacing: 8,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Info.svg",
                                colorFilter: const ColorFilter.mode(
                                  AppColors.blue,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  "Pro vytvoření mikčního deníku je zapotřebí mít vyplněný Anamnestický dotazník.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            spacing: 16,
                            children: [
                              DateTimePicker(
                                controller: startDate,
                                labelText: "Kdy chcete deník začít vést",
                                hintText: "Zadejte datum",
                                helperText: "Nejdříve následující den",
                                minDateTime: DateTime.now()
                                    .add(const Duration(days: 1))
                                    .copyWith(
                                      hour: 0,
                                      minute: 0,
                                      second: 0,
                                      millisecond: 0,
                                      microsecond: 0,
                                    ),
                                initialDateTime: startDateText.isEmpty
                                    ? DateTime.now()
                                        .add(const Duration(days: 1))
                                    : DateFormat("dd. MM. yyyy")
                                        .parse(startDateText),
                                onChanged: handleChangeStartDate,
                              ),
                              SelectField<DurationType>(
                                labelText: "Jak dlouho chcete deník vést",
                                hintText: "Vyberte jednu možnost",
                                items: DurationType.values,
                                formattedString: (DurationType type) =>
                                    type.formattedString,
                                onChanged: handleChangeEndDate,
                                isEnabled: startDate.text.isNotEmpty,
                              ),
                            ],
                          ),
                        ),
                        if (startDateText.isNotEmpty && endDateText.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: AppStyles.borderRadius.xl,
                              border: Border.all(
                                width: 1,
                                color: const Color(0xFFE4E4E7),
                              ),
                            ),
                            child: Column(
                              spacing: 4,
                              children: [
                                Row(
                                  spacing: 24,
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        "Deník začněte vyplňovat dne",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: AppColors.gray900,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      startDateText.isEmpty
                                          ? "DD.MM.YYYY"
                                          : startDate.text,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.darkBlueBase,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "záznamem o druhém ranním močení (první ranní močení se v tento den nepočítá). Deník ukončete dne ${endDateText.isEmpty ? "dd.mm.yyyy" : endDateText} ráno záznamem o prvním ranním močení.",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF71717A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Button(
                  text: "Pokračovat",
                  isLoading: isLoading,
                  onPressed: createVoidingDiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
