import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/core/services/voiding_service.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_diary_model.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_record_model.dart';
import 'package:uzis_app/features/voiding_diary/repositories/voiding_diary_repository.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:uzis_app/shared/widgets/button_outlined.dart';
import 'package:uzis_app/shared/widgets/datetime_picker.dart';
import 'package:uzis_app/shared/widgets/input_filed.dart';
import 'package:uzis_app/shared/widgets/select_field.dart';

class RecordInputDetailScreen extends StatefulWidget {
  const RecordInputDetailScreen({
    super.key,
    required this.diaryId,
    required this.recordId,
  });

  final String diaryId;
  final String recordId;

  @override
  State<RecordInputDetailScreen> createState() =>
      _RecordInputDetailScreenState();
}

class _RecordInputDetailScreenState extends State<RecordInputDetailScreen> {
  late Future<VoidingRecord> voidingRecordFuture;
  late VoidingDiaryRepository voidingDiaryRepository;

  VoidingDiary? voidingDiaryData;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController amoutController = TextEditingController();

  BeverageType? beverageType;

  bool isDisabled = true;
  bool isEditing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    voidingRecordFuture = fetchVoidingRecord();
    initVoidingDiaryData();
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    amoutController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool? result = GoRouterState.of(context).extra as bool?;
    if (result != null) {
      isEditing = result;
      validateForm();
    }
  }

  void validateForm() {
    setState(() {
      isDisabled = dateController.text.isEmpty ||
          timeController.text.isEmpty ||
          beverageType == null ||
          amoutController.text.isEmpty;
    });
  }

  void startEdit() {
    setState(() {
      isEditing = true;
    });
    validateForm();
  }

  void cancelEdit() {
    setState(() {
      isEditing = false;
      voidingRecordFuture = fetchVoidingRecord();
    });
  }

  Future<void> initVoidingDiaryData() async {
    final prefs = await SharedPreferences.getInstance();
    voidingDiaryRepository = VoidingDiaryRepository(prefs);
    final data = await voidingDiaryRepository.getVoidingDiaryData();
    setState(() {
      voidingDiaryData = data;
    });
  }

  Future<void> updateVoidingRecord() async {
    setState(() => isLoading = true);
    try {
      final day = DateFormat("d. M. yyyy").parse(dateController.text);
      final time = DateFormat("HH:mm").parse(timeController.text);
      final recordDate = day.copyWith(
          hour: time.hour, minute: time.minute, second: time.second);

      await VoidingService().updateVoidingRecord(
        widget.diaryId,
        widget.recordId,
        {
          "recorded_at": recordDate.toIso8601String(),
          "beverage_type": beverageType?.toApiString(),
          "fluid_intake": int.tryParse(amoutController.text),
        },
      );
      if (!mounted) return;
      CustomSnackbar.showSuccess("Záznam byl úspěšně upraven!");
      context.pop(true);
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<VoidingRecord> fetchVoidingRecord() async {
    final record = await VoidingService()
        .fetchVoidingRecord(widget.diaryId, widget.recordId);

    dateController.text = DateFormat("d. M. yyy").format(record.recordedAt!);
    timeController.text = DateFormat("HH:mm").format(record.recordedAt!);
    amoutController.text = record.fluidIntake.toString();
    beverageType = record.beverageType;

    return record;
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
                  future: voidingRecordFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
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
                                          isEnabled: isEditing,
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
                                          isEnabled: isEditing,
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
                                          isEnabled: isEditing,
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
                                          isEnabled: isEditing,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isEditing) ...[
                                  Column(
                                    children: [
                                      Button(
                                        text: "Uložit",
                                        isDisabled: isDisabled,
                                        isLoading: isLoading,
                                        onPressed: updateVoidingRecord,
                                      ),
                                      ButtonOutlined(
                                        text: "Zrušit",
                                        isDisabled: isDisabled || isLoading,
                                        onPressed: cancelEdit,
                                      ),
                                    ],
                                  ),
                                ] else
                                  Button(
                                    text: "Upravit",
                                    isDisabled: isEditing,
                                    onPressed: startEdit,
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
