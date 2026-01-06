import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/core/services/notification_service.dart';
import 'package:uzis_app/core/services/voiding_service.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_diary_model.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_record_model.dart';
import 'package:uzis_app/features/voiding_diary/repositories/pending_voiding_records_repository.dart';
import 'package:uzis_app/features/voiding_diary/repositories/voiding_diary_repository.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:uzis_app/shared/widgets/datetime_picker.dart';
import 'package:uzis_app/shared/widgets/input_filed.dart';
import 'package:uzis_app/shared/widgets/select_field.dart';

class RecordInputCreateScreen extends StatefulWidget {
  const RecordInputCreateScreen({
    super.key,
    this.diaryId,
  });

  final String? diaryId;

  @override
  State<RecordInputCreateScreen> createState() =>
      _RecordInputCreateScreenState();
}

class _RecordInputCreateScreenState extends State<RecordInputCreateScreen> {
  late VoidingDiaryRepository voidingDiaryRepository;
  late PendingVoidingRecordsRepository pendingRecordsRepository;
  late Future<VoidingDiary?> voidingDiaryDataFuture;
  VoidingDiary? voidingDiaryData;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController amoutController = TextEditingController();

  BeverageType? beverageType;
  bool isDisabled = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat("d. M. yyyy").format(DateTime.now());
    timeController.text = DateFormat("HH:mm").format(DateTime.now());
    voidingDiaryDataFuture = initVoidingDiaryData();
    initPendingVoidingRecordsRepository();
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    amoutController.dispose();
    super.dispose();
  }

  void validateForm() {
    setState(() {
      isDisabled = dateController.text.isEmpty ||
          timeController.text.isEmpty ||
          beverageType == null ||
          amoutController.text.isEmpty;
    });
  }

  Future<VoidingDiary?> initVoidingDiaryData() async {
    final prefs = await SharedPreferences.getInstance();
    voidingDiaryRepository = VoidingDiaryRepository(prefs);
    return await voidingDiaryRepository.getVoidingDiaryData();
  }

  Future<void> initPendingVoidingRecordsRepository() async {
    final prefs = await SharedPreferences.getInstance();
    pendingRecordsRepository = PendingVoidingRecordsRepository(prefs);
  }

  Future<void> createVoidingRecord() async {
    setState(() => isLoading = true);

    final day = DateFormat("d. M. yyyy").parse(dateController.text);
    final time = DateFormat("HH:mm").parse(timeController.text);
    final recordDate =
        day.copyWith(hour: time.hour, minute: time.minute, second: time.second);

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      try {
        final generatedId =
            DateTime.now().millisecondsSinceEpoch + Random().nextInt(1000);
        await pendingRecordsRepository.addPendingRecord(
          VoidingRecord(
            id: generatedId,
            recordedAt: recordDate,
            recordType: RecordType.input,
            beverageType: beverageType,
            fluidIntake: int.tryParse(amoutController.text),
          ),
        );
        if (!mounted) return;
        CustomSnackbar.showSuccess("Záznam byl úspěšně uložen jako čekající!");
        context.pop(true);
      } catch (e) {
        CustomSnackbar.showError(e.toString());
      } finally {
        setState(() => isLoading = true);
      }
    } else {
      try {
        await VoidingService().createVoidingRecord(
          widget.diaryId!,
          {
            "recorded_at": recordDate.toIso8601String(),
            "beverage_type": beverageType?.toApiString(),
            "fluid_intake": int.tryParse(amoutController.text),
          },
        );
        await checkStartDiaryNotification();
        if (!mounted) return;
        CustomSnackbar.showSuccess("Záznam byl úspěšně uložen!");
        context.pop(true);
      } catch (e) {
        CustomSnackbar.showError(e.toString());
      } finally {
        setState(() => isLoading = true);
      }
    }
  }

  Future<void> checkStartDiaryNotification() async {
    final bool isScheduled = await NotificationService()
        .isNotificationScheduled(NotificationService.startDiaryId);
    if (!isScheduled) return;

    await NotificationService()
        .cancelNotification(NotificationService.startDiaryId);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(10, 0, 0, 0),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  spacing: 16,
                  children: [
                    IconButton(
                      onPressed: context.pop,
                      icon: SvgPicture.asset(
                        "assets/icons/ArrowLeft.svg",
                        width: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.darkBlueBase,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Text(
                      "Příjem",
                      style: AppStyles.text.title,
                    )
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: voidingDiaryDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      voidingDiaryData = snapshot.data;

                      return Stack(
                        children: [
                          Positioned(
                            bottom: 20,
                            right: 0,
                            child: Opacity(
                              opacity: 0.08,
                              child: Image.asset(
                                'assets/images/doktorka.png',
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Column(
                              spacing: 16,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      spacing: 16,
                                      children: [
                                        DateTimePicker(
                                          controller: dateController,
                                          labelText: "Datum",
                                          hintText: "Zadejte datum",
                                          initialDateTime:
                                              DateFormat("dd. MM. yyyy")
                                                  .parse(dateController.text),
                                          minDateTime:
                                              voidingDiaryData?.startDate,
                                          maxDateTime:
                                              voidingDiaryData?.startDate!.add(
                                            Duration(
                                                days: voidingDiaryData!
                                                    .duration!
                                                    .toApiInt()),
                                          ),
                                        ),
                                        DateTimePicker(
                                          controller: timeController,
                                          labelText: "Čas",
                                          hintText: "Zadejte čas",
                                          isTimePicker: true,
                                          initialTime: TimeOfDay.fromDateTime(
                                            DateFormat("HH:mm")
                                                .parse(timeController.text),
                                          ),
                                        ),
                                        SelectField<BeverageType>(
                                          labelText: "O jaký nápoj se jednalo?",
                                          hintText: "Vyberte nápoj",
                                          items: BeverageType.values,
                                          value: beverageType,
                                          formattedString:
                                              (BeverageType type) =>
                                                  type.formattedString,
                                          onChanged: (BeverageType? value) {
                                            setState(
                                                () => beverageType = value);
                                            validateForm();
                                          },
                                        ),
                                        InputField(
                                          labelText:
                                              "Jaké bylo množství tekutiny (ml)",
                                          hintText: "Zadejte množství tekutiny",
                                          controller: amoutController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(3),
                                          ],
                                          onChanged: (_) => validateForm(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Button(
                                  text: "Uložit",
                                  isDisabled: isDisabled,
                                  isLoading: isLoading,
                                  onPressed: createVoidingRecord,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
