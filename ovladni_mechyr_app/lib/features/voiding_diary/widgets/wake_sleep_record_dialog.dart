import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uzis_app/auth_notifier.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/services/notification_service.dart';
import 'package:uzis_app/core/services/voiding_service.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/features/voiding_diary/forms/wake_sleep_record_form.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_diary_model.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:uzis_app/shared/widgets/button_outlined.dart';

class WakeSleepRecordDialog extends StatefulWidget {
  const WakeSleepRecordDialog({
    super.key,
    required this.voidingDiary,
    this.isEnd = false,
  });

  final VoidingDiary voidingDiary;
  final bool isEnd;

  @override
  State<WakeSleepRecordDialog> createState() => _WakeSleepRecordDialogState();
}

class _WakeSleepRecordDialogState extends State<WakeSleepRecordDialog> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController sleepTimeDayOne = TextEditingController();
  TextEditingController wakeupTimeDayOne = TextEditingController();

  TextEditingController sleepTimeDayTwo = TextEditingController();
  TextEditingController wakeupTimeDayTwo = TextEditingController();

  bool isEnabled = true;
  bool isLoading = false;

  @override
  void initState() {
    sleepTimeDayOne.text = formatTime(widget.voidingDiary.bedTimeDayOne);
    wakeupTimeDayOne.text = formatTime(widget.voidingDiary.wakeupTimeDayOne);

    sleepTimeDayTwo.text = formatTime(widget.voidingDiary.bedTimeDayTwo);
    wakeupTimeDayTwo.text = formatTime(widget.voidingDiary.wakeupTimeDayTwo);
    super.initState();
  }

  @override
  void dispose() {
    sleepTimeDayOne.dispose();
    wakeupTimeDayOne.dispose();

    sleepTimeDayTwo.dispose();
    wakeupTimeDayTwo.dispose();
    super.dispose();
  }

  String formatTime(DateTime? dateTime) {
    return dateTime != null ? DateFormat("HH:mm").format(dateTime) : "";
  }

  String? formatTimeToString(String timeText) {
    if (timeText.isEmpty) return null;
    // Backend očekává čas ve formátu "HH:mm" nebo "HH:mm:ss"
    // TimeField vrací "HH:mm", přidáme sekundy pro konzistenci s webem
    return timeText.contains(':') && timeText.split(':').length == 2
        ? '$timeText:00'
        : timeText;
  }

  Future<void> updateVoidingDiary() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      isEnabled = false;
    });

    try {
      await VoidingService().updateVoidingDiary(
        widget.voidingDiary.id,
        {
          "completed": widget.isEnd,
          "bedtime_day_one": formatTimeToString(sleepTimeDayOne.text),
          "wake_up_time_day_one": formatTimeToString(wakeupTimeDayOne.text),
          "bedtime_day_two": formatTimeToString(sleepTimeDayTwo.text),
          "wake_up_time_day_two": formatTimeToString(wakeupTimeDayTwo.text),
        },
      );

      final success = widget.isEnd
          ? "Mikční deník byl úspěšně dokončen!"
          : "Změny byly úspěšně uloženy!";
      CustomSnackbar.showSuccess(success);

      if (!mounted) return;
      if (widget.isEnd) {
        await context.read<AuthNotifier>().setUncompletedDiaryId(null);
        await checkEndDiaryNotification();
        if (!mounted) return;

        // Refresh doctor assignment data before showing dialog
        await context.read<AuthNotifier>().refreshDoctorAssignment();
        if (!mounted) return;

        // Store navigation callback and state before popping
        final navigator = Navigator.of(context);
        final goRouter = GoRouter.of(context);
        final hasAssignedDoctor =
            context.read<AuthNotifier>().hasAssignedDoctor;
        final doctorName = context.read<AuthNotifier>().assignedDoctorName;

        context.pop();

        // Show appropriate completion dialog based on doctor assignment
        if (!mounted) return;

        if (hasAssignedDoctor) {
          _showAlreadyAssignedDialog(
            navigator: navigator,
            goRouter: goRouter,
            doctorName: doctorName,
          );
        } else {
          _showCompletionDialog(
            onSelectDoctor: () {
              navigator.pop(); // Close completion dialog
              goRouter.go("/doctor-list");
            },
            onClose: () {
              navigator.pop(); // Close completion dialog
              goRouter.go("/");
            },
          );
        }
      } else {
        context.pop(true);
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      setState(() {
        isLoading = false;
        isEnabled = true;
      });
    }
  }

  Future<void> checkEndDiaryNotification() async {
    final bool isScheduled = await NotificationService()
        .isNotificationScheduled(NotificationService.endDiaryId);
    if (!isScheduled) return;

    await NotificationService()
        .cancelNotification(NotificationService.endDiaryId);
  }

  void _showCompletionDialog({
    required VoidCallback onSelectDoctor,
    required VoidCallback onClose,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
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
                  "Gratulujeme! Deník byl úspěšně dokončen",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlueBase,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Výborně! Dokončili jste vyplňování mikčního deníku. Vaše záznamy byly uloženy a jsou připraveny k vyhodnocení.\n\nNyní můžete pokračovat výběrem lékaře, který bude vaše záznamy vyhodnocovat a poskytne vám odbornou péči.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Column(
                  spacing: 8,
                  children: [
                    Button(
                      text: "Vybrat lékaře",
                      onPressed: onSelectDoctor,
                    ),
                    ButtonOutlined(
                      text: "Zavřít",
                      onPressed: onClose,
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

  void _showAlreadyAssignedDialog({
    required NavigatorState navigator,
    required GoRouter goRouter,
    required String? doctorName,
  }) {
    showDialog(
      context: navigator.context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: AppColors.green,
                ),
                const Text(
                  "Mikční deník dokončen",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlueBase,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Váš přiřazený lékař: ${doctorName ?? 'Neznámý lékař'}\n\nLékař Vás bude kontaktovat s vyhodnocením deníku.",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Button(
                  text: "Rozumím",
                  onPressed: () {
                    navigator.pop(); // Close the dialog
                    goRouter.go('/'); // Navigate to home
                  },
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
    final days = widget.voidingDiary.duration?.toApiInt();
    final buttonText = widget.isEnd ? "Ukončit mikční deník" : "Uložit";

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
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 16,
                  children: [
                    if (widget.isEnd == true)
                      const Column(
                        spacing: 4,
                        children: [
                          Text(
                            "Váš mikční deník je u konce",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBlueBase,
                            ),
                          ),
                          Text(
                            "Zkontrolujte si prosím, zda jste zadali veškeré záznamy týkající se mikce a příjmu tekutin a také časy vstávání a usínání. Potvrďte prosím správnost a úplnost vyplněných údajů, po odsouhlasení již nebude možné se k mikčnímu deníku vrátit.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Mikční deník končí první ranní mikcí, žádné další po probuzení nezadávejte.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkBlueBase50,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    else
                      const Text(
                        "Čas probouzení/usínání",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBlueBase,
                        ),
                      ),
                    WakeSleepForm(
                      formKey: _formKey,
                      sleepTimeDayOne: sleepTimeDayOne,
                      wakeupTimeDayOne: wakeupTimeDayOne,
                      sleepTimeDayTwo: sleepTimeDayTwo,
                      wakeupTimeDayTwo: wakeupTimeDayTwo,
                      isEnabled: isEnabled,
                      isLoading: isLoading,
                      days: days!,
                      voidingDiary: widget.voidingDiary,
                      isEnd: widget.isEnd,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                if (widget.isEnd)
                  ButtonOutlined(
                      text: "Přidat/Upravit záznamy", onPressed: context.pop),
                Button(
                  text: buttonText,
                  onPressed: updateVoidingDiary,
                  isLoading: isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
