import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_record_model.dart';
import 'package:uzis_app/features/voiding_diary/repositories/pending_voiding_records_repository.dart';
import 'package:uzis_app/features/voiding_diary/repositories/voiding_diary_repository.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uzis_app/shared/widgets/button_outlined.dart';

class NoConnectionScreen extends StatefulWidget {
  const NoConnectionScreen({super.key});

  @override
  State<NoConnectionScreen> createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {
  late VoidingDiaryRepository voidingDiaryRepository;
  late Future<List<VoidingRecord>> pendingVoidingRecordsFuture;
  late PendingVoidingRecordsRepository pendingRecordsRepository;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    pendingVoidingRecordsFuture = initPendingVoidingRecords();
  }

  Future<List<VoidingRecord>> initPendingVoidingRecords() async {
    final prefs = await SharedPreferences.getInstance();
    pendingRecordsRepository = PendingVoidingRecordsRepository(prefs);
    return await pendingRecordsRepository.getPendingVoidingRecordsData();
  }

  Future<void> refreshTable() async {
    setState(() {
      pendingVoidingRecordsFuture =
          pendingRecordsRepository.getPendingVoidingRecordsData();
    });
  }

  Future<void> openDeleteVoidingRecordDialog(VoidingRecord record) async {
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
                          record.recordType != null
                              ? '${record.recordType?.formattedString}'
                              : "-",
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
                            text: "Smazat",
                            isLoading: isLoading,
                            onPressed: () async {
                              setState(() => isLoading = true);
                              try {
                                await pendingRecordsRepository
                                    .removePendingRecord(record.id!);

                                if (!context.mounted) return;
                                CustomSnackbar.showSuccess(
                                    "Záznam byl úspěšně vymazán!");
                                context.pop();
                                refreshTable();
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

  Future<void> checkConnection() async {
    setState(() => _isChecking = true);

    var connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = !connectivityResult.contains(ConnectivityResult.none);

    if (isConnected) {
      if (!mounted) return;
      context.go("/");
      CustomSnackbar.showSuccess("Jste znovu připojeni!");
    } else {
      CustomSnackbar.showError("Zkontrolujte vaše připojení k internetu.");
    }

    setState(() => _isChecking = false);
  }

  DataRow2 _createDataRow(int index, VoidingRecord record) {
    bool isFirstRow = index == 0;

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
          IconButton(
            onPressed: () => openDeleteVoidingRecordDialog(record),
            icon: SvgPicture.asset(
              "assets/icons/Trash.svg",
              width: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.darkBlueBase,
                BlendMode.srcIn,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                spacing: 16,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.redLighter,
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
                          "assets/icons/WifiOff.svg",
                          colorFilter: const ColorFilter.mode(
                            AppColors.red,
                            BlendMode.srcIn,
                          ),
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text:
                                  "Máte omezený přístup z důvodu špatného internetového připojení. ",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.red,
                              ),
                              children: [
                                TextSpan(
                                  text: "Co to znamená?",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.red,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.red,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              backgroundColor: Colors.white,
                                              insetPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(24.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  spacing: 16,
                                                  children: [
                                                    Flexible(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          spacing: 16,
                                                          children: [
                                                            Column(
                                                              spacing: 4,
                                                              children: [
                                                                const Text(
                                                                  "Omezený přístup",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: AppColors
                                                                        .darkBlueBase,
                                                                  ),
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  "assets/icons/WifiOff.svg",
                                                                  width: 48,
                                                                  colorFilter:
                                                                      const ColorFilter
                                                                          .mode(
                                                                    AppColors
                                                                        .gray400,
                                                                    BlendMode
                                                                        .srcIn,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  "Váš přístup je omezen z důvodu špatného internetového připojení. Můžete si zadávat záznamy o močení nebo příjmu, ale tyto informace nebudou odeslány, dokud se nebudete moci připojit k internetu.",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppColors
                                                                        .gray400,
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  "Až se připojíte k internetu, budete mít možnost potvrdit a odeslat všechny zaznamenané údaje.",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppColors
                                                                        .gray400,
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Button(
                                                      text: "Rozumím",
                                                      onPressed: context.pop,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: pendingVoidingRecordsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        }
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          return DataTable2(
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
                            rows: List<DataRow>.generate(
                              snapshot.data!.length,
                              (index) =>
                                  _createDataRow(index, snapshot.data![index]),
                            ),
                            empty: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 4,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/FolderOpen.svg",
                                    width: 24,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.gray400,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const Text(
                                    "Žádné čekající záznamy",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.gray400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Column(
                    children: [
                      ButtonOutlined(
                        isLoading: _isChecking,
                        text: "Zkusit znovu připojit",
                        onPressed: checkConnection,
                      ),
                      Button(
                        text: "Močení",
                        onPressed: () {
                          context
                              .push("/no-connection/record-output")
                              .then((hasChanges) {
                            if (hasChanges == true) refreshTable();
                          });
                        },
                      ),
                      Button(
                        text: "Příjem",
                        onPressed: () {
                          context
                              .push("/no-connection/record-input")
                              .then((hasChanges) {
                            if (hasChanges == true) refreshTable();
                          });
                        },
                      ),
                    ],
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
