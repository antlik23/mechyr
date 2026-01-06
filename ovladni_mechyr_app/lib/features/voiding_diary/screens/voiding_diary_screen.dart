import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
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
import 'package:uzis_app/features/voiding_diary/repositories/pending_voiding_records_repository.dart';
import 'package:uzis_app/features/voiding_diary/repositories/voiding_diary_repository.dart';
import 'package:uzis_app/features/voiding_diary/widgets/start_date_diary_dialog.dart';
import 'package:uzis_app/features/voiding_diary/widgets/wake_sleep_record_dialog.dart';
import 'package:uzis_app/main.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:uzis_app/shared/widgets/button_outlined.dart';

class VoidingDiaryScreen extends StatefulWidget {
  const VoidingDiaryScreen({
    super.key,
    required this.diaryId,
  });

  final String diaryId;

  @override
  State<VoidingDiaryScreen> createState() => _VoidingDiaryScreenState();
}

class _VoidingDiaryScreenState extends State<VoidingDiaryScreen> {
  Future<VoidingDiary>? voidingDiaryFuture;
  late VoidingDiaryRepository voidingDiaryRepository;
  late Future<VoidingRecords?> voidingRecordsFuture;
  late PendingVoidingRecordsRepository pendingRecordsRepository;

  List<VoidingRecord> pendingRecords = [];

  bool hasDialogBeenShown = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initVoidingDiaryRepository();
    refreshVoidingRecords();
    initPendingVoidingRecordsRepository();
  }

  Future<void> initPendingVoidingRecordsRepository() async {
    final prefs = await SharedPreferences.getInstance();
    pendingRecordsRepository = PendingVoidingRecordsRepository(prefs);

    refreshPendingRecords();
  }

  Future<void> refreshPendingRecords() async {
    final records =
        await pendingRecordsRepository.getPendingVoidingRecordsData();
    setState(() {
      pendingRecords = records;
    });
  }

  Future<void> showWakeSleepDialog(VoidingDiary voidingDiary) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => WakeSleepRecordDialog(
        voidingDiary: voidingDiary,
      ),
    );

    if (result == true) {
      refreshVoidingDiary();
    }
  }

  void showEndDialog(VoidingDiary voidingDiary) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WakeSleepRecordDialog(
        voidingDiary: voidingDiary,
        isEnd: true,
      ),
    );
  }

  void showStartDialog(DateTime startDate, DateTime endDate) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StartDateDiaryDialog(
        startDate: DateFormat("d. M. yyyy").format(startDate),
        endDate: DateFormat("d. M. yyyy").format(endDate),
      ),
    );
  }

  Future<void> initVoidingDiaryRepository() async {
    final prefs = await SharedPreferences.getInstance();
    voidingDiaryRepository = VoidingDiaryRepository(prefs);

    refreshVoidingDiary();
  }

  Future<VoidingDiary> fetchVoidingDiary() async {
    final response = await VoidingService().fetchVoidingDiary(widget.diaryId);
    await voidingDiaryRepository.saveVoidingDiaryData(response);
    return response;
  }

  Future<void> refreshVoidingDiary() async {
    setState(() {
      voidingDiaryFuture = fetchVoidingDiary();
    });
  }

  Future<VoidingRecords?> fetchVoidingRecords() async {
    return await VoidingService().fetchVoidingRecords(widget.diaryId, {
      "items_per_page": "999",
    });
  }

  Future<void> refreshVoidingRecords() async {
    setState(() {
      voidingRecordsFuture = fetchVoidingRecords();
    });
  }

  DataRow2 _createDataRow(int index, VoidingRecord record) {
    bool isFirstRow = index == 0;
    final url = record.recordType == RecordType.output
        ? "/voiding-diary/${widget.diaryId}/record-output/${record.id}"
        : "/voiding-diary/${widget.diaryId}/record-input/${record.id}";

    return DataRow2(
      decoration: BoxDecoration(
        border: Border(
          top: isFirstRow
              ? const BorderSide(
                  color: AppColors.gray100,
                  width: 1,
                )
              : BorderSide.none,
          bottom: const BorderSide(
            color: AppColors.gray100,
            width: 1,
          ),
        ),
      ),
      onTap: () {
        context.push(url).then(
          (hasChanges) {
            if (hasChanges == true) refreshVoidingRecords();
          },
        );
      },
      cells: [
        DataCell(
          Text(
            record.recordedAt != null
                ? DateFormat('d. M. yyyy HH:mm').format(record.recordedAt!)
                : "-",
            style: AppStyles.table.row,
          ),
        ),
        DataCell(
          Text(
            record.recordType != null
                ? '${record.recordType?.formattedString}'
                : "-",
            style: AppStyles.table.row,
          ),
        ),
        DataCell(
          Theme(
            data: Theme.of(context).copyWith(
              iconButtonTheme: IconButtonThemeData(
                style: ButtonStyle(
                  shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                    (Set<WidgetState> states) {
                      return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.transparent),
                      );
                    },
                  ),
                ),
              ),
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: AppStyles.borderRadius.lg,
                  border: Border.all(
                    color: const Color(0xFFE4E4E7),
                    width: 1,
                  ),
                ),
                child: PopupMenuButton(
                  color: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      color: AppColors.transparent,
                    ),
                  ),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        spacing: 16,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Pencil.svg",
                            width: 16,
                            colorFilter: const ColorFilter.mode(
                              AppColors.darkBlueBase,
                              BlendMode.srcIn,
                            ),
                          ),
                          const Text(
                            "Upravit",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        context.push(url, extra: true).then(
                          (hasChanges) {
                            if (hasChanges == true) refreshVoidingRecords();
                          },
                        );
                      },
                    ),
                    PopupMenuItem(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        spacing: 16,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Trash.svg",
                            width: 16,
                            colorFilter: const ColorFilter.mode(
                              AppColors.darkBlueBase,
                              BlendMode.srcIn,
                            ),
                          ),
                          const Text(
                            "Smazat",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => openDeleteVoidingRecordDialog(record),
                    ),
                  ],
                  icon: SvgPicture.asset(
                    "assets/icons/EllipsisVertical.svg",
                    width: 20,
                  ),
                  offset: const Offset(0, 50),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataRow2 _createPendingDataRow(int index, VoidingRecord record) {
    bool isFirstRow = index == 0;

    return DataRow2(
      decoration: BoxDecoration(
        color: AppColors.blueLighter,
        border: Border(
          top: isFirstRow
              ? const BorderSide(
                  color: AppColors.gray100,
                  width: 1,
                )
              : BorderSide.none,
          bottom: const BorderSide(
            color: AppColors.gray100,
            width: 1,
          ),
        ),
      ),
      cells: [
        DataCell(
          Text(
            record.recordedAt != null
                ? DateFormat('d. M. yyyy HH:mm').format(record.recordedAt!)
                : "-",
            style: AppStyles.table.row,
          ),
        ),
        DataCell(
          Text(
            record.recordType != null
                ? '${record.recordType?.formattedString}'
                : "-",
            style: AppStyles.table.row,
          ),
        ),
        DataCell(
          Theme(
            data: Theme.of(context).copyWith(
              iconButtonTheme: IconButtonThemeData(
                style: ButtonStyle(
                  shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                    (Set<WidgetState> states) {
                      return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.transparent),
                      );
                    },
                  ),
                ),
              ),
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: AppStyles.borderRadius.lg,
                  border: Border.all(
                    color: const Color(0xFFE4E4E7),
                    width: 1,
                  ),
                ),
                child: PopupMenuButton(
                  color: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      color: AppColors.transparent,
                    ),
                  ),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        spacing: 16,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Upload.svg",
                            width: 16,
                            colorFilter: const ColorFilter.mode(
                              AppColors.darkBlueBase,
                              BlendMode.srcIn,
                            ),
                          ),
                          const Text(
                            "Odeslat",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        setState(() => isLoading = true);
                        try {
                          await pendingRecordsRepository.sendRecordById(
                              record.id!, widget.diaryId);
                          CustomSnackbar.showSuccess(
                              "Záznam byl úspěšně uložen!");
                          refreshPendingRecords();
                          refreshVoidingRecords();
                        } catch (e) {
                          CustomSnackbar.showError(e.toString());
                        } finally {
                          setState(() => isLoading = false);
                        }
                      },
                    ),
                    PopupMenuItem(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        spacing: 16,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Trash.svg",
                            width: 16,
                            colorFilter: const ColorFilter.mode(
                              AppColors.darkBlueBase,
                              BlendMode.srcIn,
                            ),
                          ),
                          const Text(
                            "Smazat",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => openDeleteVoidingRecordDialog(record,
                          isPending: true),
                    ),
                  ],
                  icon: SvgPicture.asset(
                    "assets/icons/EllipsisVertical.svg",
                    width: 20,
                  ),
                  offset: const Offset(0, 50),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> openDeleteVoidingRecordDialog(VoidingRecord record,
      {bool isPending = false}) async {
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                      "Opravdu chcete smazat záznam?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkBlueBase,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Text(
                          record.recordType!.formattedString,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          "-",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          DateFormat('d. M. yyyy HH:mm')
                              .format(record.recordedAt!),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
                            isLoading: isLoading,
                            text: "Smazat",
                            onPressed: () async {
                              setState(() => isLoading = true);
                              try {
                                if (isPending) {
                                  await pendingRecordsRepository
                                      .removePendingRecord(record.id!);

                                  if (!context.mounted) return;
                                  CustomSnackbar.showSuccess(
                                      "Záznam byl úspěšně vymazán!");
                                  context.pop();
                                  refreshPendingRecords();
                                } else {
                                  await VoidingService().deleteVoidingRecord(
                                      widget.diaryId, record.id.toString());
                                  final context = navigatorKey.currentContext;
                                  if (context == null || !context.mounted) {
                                    return;
                                  }

                                  CustomSnackbar.showSuccess(
                                      "Záznam byl úspěšně vymazán!");
                                  context.pop();
                                  refreshVoidingRecords();
                                }
                              } catch (e) {
                                CustomSnackbar.showError(e.toString());
                              } finally {
                                setState(() => isLoading = false);
                              }
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
    );
  }

  String getPendingRecordsText(int pendingRecordsLength) {
    if (pendingRecordsLength == 1) {
      return "Máte 1 neodeslaný záznam.";
    } else if (pendingRecordsLength >= 2 && pendingRecordsLength <= 4) {
      return "Máte $pendingRecordsLength neodeslané záznamy.";
    } else {
      return "Máte $pendingRecordsLength neodeslaných záznamů.";
    }
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder(
                    future: voidingDiaryFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                "Chyba v načítání mikčního deníku: ${snapshot.error}"));
                      } else if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        VoidingDiary voidingDiary = snapshot.data!;

                        final today = DateTime.now();
                        final startDate = voidingDiary.startDate!;
                        final endDate = voidingDiary.startDate!.add(
                            Duration(days: voidingDiary.duration!.toApiInt()));

                        Future.microtask(() {
                          if (!hasDialogBeenShown) {
                            hasDialogBeenShown = true;
                            if (today.isBefore(voidingDiary.startDate!)) {
                              return showStartDialog(startDate, endDate);
                            }
                            if (today.isAtSameMomentAs(endDate) ||
                                today.isAfter(endDate)) {
                              return showEndDialog(voidingDiary);
                            }
                          }
                        });

                        return Column(
                          spacing: 16,
                          children: [
                            if (pendingRecords.isNotEmpty)
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
                                      "assets/icons/Layers3.svg",
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.blue,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        getPendingRecordsText(
                                            pendingRecords.length),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Expanded(
                              child: FutureBuilder(
                                future: voidingRecordsFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return SizedBox.expand(
                                      child: RefreshIndicator(
                                        onRefresh: refreshVoidingRecords,
                                        child: SizedBox(
                                          height: double.infinity,
                                          child: SingleChildScrollView(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                  "Error: ${snapshot.error.toString()}",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  final List<VoidingRecord> voidingRecords =
                                      snapshot.data!.voidingRecords!;

                                  return RefreshIndicator(
                                    backgroundColor: Colors.white,
                                    color: AppColors.darkBlueBase,
                                    onRefresh: refreshVoidingRecords,
                                    child: DataTable2(
                                      dataRowHeight: 60,
                                      columnSpacing: 0,
                                      horizontalMargin: 10,
                                      dividerThickness: 0,
                                      columns: [
                                        DataColumn2(
                                          label: Text(
                                            "Záznam",
                                            style: AppStyles.table.column,
                                          ),
                                          size: ColumnSize.L,
                                        ),
                                        DataColumn2(
                                          label: Text(
                                            "Typ",
                                            style: AppStyles.table.column,
                                          ),
                                          size: ColumnSize.M,
                                        ),
                                        const DataColumn2(
                                          label: SizedBox.shrink(),
                                          size: ColumnSize.S,
                                        ),
                                      ],
                                      rows: [
                                        if (pendingRecords.isNotEmpty) ...[
                                          ...List<DataRow>.generate(
                                            pendingRecords.length,
                                            (index) => _createPendingDataRow(
                                                index, pendingRecords[index]),
                                          )
                                        ],
                                        ...List<DataRow>.generate(
                                          voidingRecords.length,
                                          (index) => _createDataRow(
                                              index, voidingRecords[index]),
                                        )
                                      ],
                                      empty: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          spacing: 4,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/FolderOpen.svg",
                                              width: 24,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                AppColors.gray400,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            const Text(
                                              "Žádné záznamy",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.gray400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Column(
                              children: [
                                if (today.isAtSameMomentAs(endDate) ||
                                    today.isAfter(endDate))
                                  Button(
                                    text: "Ukončit mikční deník",
                                    onPressed: () {
                                      showEndDialog(voidingDiary);
                                    },
                                  ),
                                Button(
                                  text: "Čas probouzení/usínání",
                                  onPressed: () {
                                    if (DateTime.now()
                                        .isBefore(voidingDiary.startDate!)) {
                                      return showStartDialog(
                                          startDate, endDate);
                                    }
                                    showWakeSleepDialog(voidingDiary);
                                  },
                                ),
                                Button(
                                  text: "Močení",
                                  onPressed: () {
                                    if (DateTime.now()
                                        .isBefore(voidingDiary.startDate!)) {
                                      return showStartDialog(
                                          startDate, endDate);
                                    }
                                    context
                                        .push(
                                            "/voiding-diary/${widget.diaryId}/record-output")
                                        .then((hasChanges) {
                                      if (hasChanges == true) {
                                        refreshVoidingRecords();
                                      }
                                    });
                                  },
                                ),
                                Button(
                                  text: "Příjem",
                                  onPressed: () {
                                    if (DateTime.now()
                                        .isBefore(voidingDiary.startDate!)) {
                                      return showStartDialog(
                                          startDate, endDate);
                                    }
                                    context
                                        .push(
                                            "/voiding-diary/${widget.diaryId}/record-input")
                                        .then((hasChanges) {
                                      if (hasChanges == true) {
                                        refreshVoidingRecords();
                                      }
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
