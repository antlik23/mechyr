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
import 'package:uzis_app/shared/widgets/custom_checkbox.dart';
import 'package:uzis_app/shared/widgets/datetime_picker.dart';
import 'package:uzis_app/shared/widgets/input_filed.dart';

class RecordOutputCreateScreen extends StatefulWidget {
  const RecordOutputCreateScreen({
    super.key,
    this.diaryId,
  });

  final String? diaryId;

  @override
  State<RecordOutputCreateScreen> createState() =>
      _RecordOutputCreateScreenState();
}

class _RecordOutputCreateScreenState extends State<RecordOutputCreateScreen> {
  late VoidingDiaryRepository voidingDiaryRepository;
  late PendingVoidingRecordsRepository pendingRecordsRepository;
  late Future<VoidingDiary?> voidingDiaryDataFuture;
  VoidingDiary? voidingDiaryData;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController amoutController = TextEditingController();

  bool isDisabled = true;
  bool isLoading = false;
  bool isPossibleSleep = false;

  int? selectedUrgeLevel;
  int? selectedSleepOption;
  int? selectedLeakOption;
  int? selectedLeakTypeOption;

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

  void onUrgeLevelChanged(int index) {
    setState(() {
      selectedUrgeLevel = index;
    });
    validateForm();
  }

  void onSleepOptionChanged(int index) {
    setState(() {
      selectedSleepOption = index;
    });
    validateForm();
  }

  void onLeakOptionChanged(int index) {
    setState(() {
      selectedLeakOption = index;
    });
    validateForm();
  }

  void onLeakTypeOptionChanged(int index) {
    setState(() {
      selectedLeakTypeOption = index;
    });
    validateForm();
  }

  void validateForm() {
    setState(() {
      if (selectedLeakOption == 1) {
        selectedLeakTypeOption = null;
      }
      if (!isPossibleSleep) {
        selectedSleepOption = null;
      }

      final isSleepValid = isPossibleSleep ? selectedSleepOption != null : true;

      isDisabled = !isSleepValid ||
          selectedLeakOption == null ||
          amoutController.text.isEmpty ||
          selectedUrgeLevel == null ||
          (selectedLeakOption == 0 && selectedLeakTypeOption == null);
    });
  }

  void handleIsPossibleSleep() {
    if (voidingDiaryData == null) return;
    if (!mounted) return;
    final selectedDate = DateFormat("d. M. yyyy").parse(dateController.text);
    final selectedTime = DateFormat("HH:mm").parse(timeController.text);

    final isFirstDay =
        selectedDate.isAtSameMomentAs(voidingDiaryData!.startDate!);

    bool isSleepTime(DateTime nowTime, DateTime wakeTime, DateTime bedTime) {
      if (bedTime.isBefore(wakeTime)) {
        return nowTime.isAfter(bedTime) || nowTime.isBefore(wakeTime);
      } else {
        return nowTime.isBefore(wakeTime) || nowTime.isAfter(bedTime);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (isFirstDay) {
          // default waketime is 5:00
          final wakeTime = voidingDiaryData!.wakeupTimeDayOne ??
              DateFormat("HH:mm").parse("05:00");
          // default bedtime is 22:00
          final bedTime = voidingDiaryData!.bedTimeDayOne ??
              DateFormat("HH:mm").parse("22:00");

          setState(() {
            isPossibleSleep = isSleepTime(selectedTime, wakeTime, bedTime);
          });
        } else {
          final wakeTime = voidingDiaryData!.wakeupTimeDayTwo ??
              voidingDiaryData!.wakeupTimeDayOne ??
              DateFormat("HH:mm").parse("05:00");
          final bedTime = voidingDiaryData!.bedTimeDayTwo ??
              voidingDiaryData!.bedTimeDayOne ??
              DateFormat("HH:mm").parse("22:00");

          setState(() {
            isPossibleSleep = isSleepTime(selectedTime, wakeTime, bedTime);
          });
        }
        validateForm();
      },
    );
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
            recordType: RecordType.output,
            sleptBeforeAndAfter: selectedSleepOption == 0,
            urineLeakage: selectedLeakOption == 0,
            urgeStrength: selectedUrgeLevel,
            urineVolume: int.tryParse(amoutController.text),
          ),
        );
        if (!mounted) return;
        CustomSnackbar.showSuccess("Záznam byl úspěšně uložen jako čekající!");
        context.pop(true);
      } catch (e) {
        CustomSnackbar.showError(e.toString());
      } finally {
        setState(() => isLoading = false);
      }
    } else {
      try {
        await VoidingService().createVoidingRecord(
          widget.diaryId!,
          {
            "recorded_at": recordDate.toIso8601String(),
            "slept_before_and_after": selectedSleepOption == 0,
            "urine_leakage": selectedLeakOption == 0,
            "urine_leakage_type": selectedLeakTypeOption != null
                ? UrineLeakageTypeExtension.toApiStringFromInt(
                    selectedLeakTypeOption!)
                : null,
            "urge_strength": selectedUrgeLevel,
            "urine_volume": int.tryParse(amoutController.text),
          },
        );
        await checkStartDiaryNotification();
        if (!mounted) return;
        CustomSnackbar.showSuccess("Záznam byl úspěšně uložen!");
        context.pop(true);
      } catch (e) {
        CustomSnackbar.showError(e.toString());
      } finally {
        setState(() => isLoading = false);
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
                      "Močení",
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
                                          onChanged: (_) =>
                                              handleIsPossibleSleep(),
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
                                          onChanged: (_) =>
                                              handleIsPossibleSleep(),
                                        ),
                                        InputField(
                                          labelText: "Množství moči (ml)",
                                          hintText: "Zadejte množství moči",
                                          controller: amoutController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(3),
                                          ],
                                          onChanged: (_) => validateForm(),
                                        ),
                                        if (isPossibleSleep == true)
                                          Column(
                                            spacing: 16,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Spal/a jste před a zároveň po močení?",
                                                    style:
                                                        AppStyles.input.label,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OptionItem(
                                                      text: "Ano",
                                                      isSelected:
                                                          selectedSleepOption ==
                                                              0,
                                                      onChanged: () =>
                                                          onSleepOptionChanged(
                                                              0),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: OptionItem(
                                                      text: "Ne",
                                                      isSelected:
                                                          selectedSleepOption ==
                                                              1,
                                                      onChanged: () =>
                                                          onSleepOptionChanged(
                                                              1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        Column(
                                          spacing: 16,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Došlo k úniku moči?",
                                                  style: AppStyles.input.label,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: OptionItem(
                                                    text: "Ano",
                                                    isSelected:
                                                        selectedLeakOption == 0,
                                                    onChanged: () =>
                                                        onLeakOptionChanged(0),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: OptionItem(
                                                    text: "Ne",
                                                    isSelected:
                                                        selectedLeakOption == 1,
                                                    onChanged: () =>
                                                        onLeakOptionChanged(1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (selectedLeakOption == 0) ...[
                                          Column(
                                            spacing: 16,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "O jaký typ inkontinence se jednalo?",
                                                    style:
                                                        AppStyles.input.label,
                                                  ),
                                                ],
                                              ),
                                              OptionItem(
                                                text:
                                                    "Stresová – Únik zpravidla malého množství moči při fyzické aktivitě (kašel, kýchnutí, smích, běh, skákání apod.)",
                                                isSelected:
                                                    selectedLeakTypeOption == 0,
                                                onChanged: () =>
                                                    onLeakTypeOptionChanged(0),
                                              ),
                                              OptionItem(
                                                text:
                                                    "Urgentní – Byl únik moči spojený v nutkáním na močení? Proběhl únik ve spánku nebo z neznámých důvodů?",
                                                isSelected:
                                                    selectedLeakTypeOption == 1,
                                                onChanged: () =>
                                                    onLeakTypeOptionChanged(1),
                                              ),
                                            ],
                                          ),
                                        ],
                                        Column(
                                          spacing: 16,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Jak silné bylo nucení k močení?",
                                                  style: AppStyles.input.label,
                                                ),
                                              ],
                                            ),
                                            OptionItem(
                                              text:
                                                  "Žádné nucení – Necítil/a jsem potřebu vyprázdnit močový měchýř, ale vymočil/a jsem se z jiných důvodů.",
                                              isSelected:
                                                  selectedUrgeLevel == 0,
                                              onChanged: () =>
                                                  onUrgeLevelChanged(0),
                                            ),
                                            OptionItem(
                                              text:
                                                  "Mírné nucení – Mohl/a jsem močení oddálit tak dlouho, jak bylo nutné bez obav z pomočení.",
                                              isSelected:
                                                  selectedUrgeLevel == 1,
                                              onChanged: () =>
                                                  onUrgeLevelChanged(1),
                                            ),
                                            OptionItem(
                                              text:
                                                  "Středně silné nucení – Mohl/a jsem močení na krátkou chvíli oddálit bez obav z pomočení.",
                                              isSelected:
                                                  selectedUrgeLevel == 2,
                                              onChanged: () =>
                                                  onUrgeLevelChanged(2),
                                            ),
                                            OptionItem(
                                              text:
                                                  "Silné nucení – Močení jsem nemohl/a oddálit, musel/a jsem spěchat na toaletu, abych se nepomočil/a.",
                                              isSelected:
                                                  selectedUrgeLevel == 3,
                                              onChanged: () =>
                                                  onUrgeLevelChanged(3),
                                            ),
                                            OptionItem(
                                              text:
                                                  "Urgentní únik – pomočil/a jsem se před příchodem na toaletu.",
                                              isSelected:
                                                  selectedUrgeLevel == 4,
                                              onChanged: () =>
                                                  onUrgeLevelChanged(4),
                                            ),
                                          ],
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

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onChanged,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCheckbox(
            isChecked: isSelected,
            onChanged: onChanged,
            circle: true,
          ),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.gray700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
