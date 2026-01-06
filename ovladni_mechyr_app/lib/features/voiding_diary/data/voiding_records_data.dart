import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/core/services/voiding_service.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_record_model.dart';
import 'package:uzis_app/main.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:uzis_app/shared/widgets/button_outlined.dart';

class VoidingRecordsDataSource extends AsyncDataTableSource {
  VoidingRecordsDataSource({
    required this.fetchVoidingRecords,
    required this.context,
    required this.diaryId,
    required this.refreshData,
  });

  final Future<VoidingRecords> Function(String diaryId,
      [Map<String, dynamic>? params]) fetchVoidingRecords;
  final BuildContext context;
  final String diaryId;
  final Function() refreshData;

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    int pageParam = (startIndex / count).floor() + 1;

    VoidingRecords response = await fetchVoidingRecords(diaryId, {
      "page_param": pageParam.toString(),
      "items_per_page": count.toString(),
    });

    return AsyncRowsResponse(
      response.pagination?.count ?? 0,
      response.voidingRecords != null
          ? response.voidingRecords!
              .asMap()
              .entries
              .map((entry) => _createDataRow(entry.key, entry.value))
              .toList()
          : [],
    );
  }

  Future<void> deleteVoidingRecords(VoidingRecord record) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                      DateFormat('d. M. yyyy HH:mm').format(record.recordedAt!),
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
                        onPressed: () async {
                          try {
                            await VoidingService().deleteVoidingRecord(
                                diaryId, record.id.toString());
                            final context = navigatorKey.currentContext;
                            if (context == null || !context.mounted) return;
                            CustomSnackbar.showSuccess(
                                "Záznam byl úspěšně vymazán!");
                            context.pop();
                            refreshData();
                          } catch (e) {
                            CustomSnackbar.showError(e.toString());
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
  }

  DataRow2 _createDataRow(int index, VoidingRecord record) {
    bool isFirstRow = index == 0;
    final url = record.recordType == RecordType.output
        ? "/voiding-diary/$diaryId/record-output/${record.id}"
        : "/voiding-diary/$diaryId/record-input/${record.id}";

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
            if (hasChanges == true) refreshData();
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
                    color: AppColors.darkBlueBase,
                    width: 1,
                  ),
                ),
                child: PopupMenuButton(
                  color: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      // Tady nastavíš nový border
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
                            if (hasChanges == true) refreshData();
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
                      onTap: () => deleteVoidingRecords(record),
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
}
