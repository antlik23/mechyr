import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uzis_app/core/constants/app_colors.dart';

class CustomPaginatedDatatable extends StatelessWidget {
  const CustomPaginatedDatatable({
    super.key,
    required this.dataSource,
    required this.columns,
    required this.controller,
    required this.onRefresh,
    this.columnSpacing = 0,
    this.horizontalMargin = 10,
    this.minWidth,
    this.dataRowHeight = 60,
  });

  final DataTableSource dataSource;
  final List<DataColumn> columns;
  final PaginatorController controller;
  final Future<void> Function() onRefresh;
  final double columnSpacing;
  final double horizontalMargin;
  final double? minWidth;
  final double dataRowHeight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        color: AppColors.darkBlueBase,
        onRefresh: onRefresh,
        child: Theme(
          data: Theme.of(context).copyWith(
            iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                iconColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return AppColors.darkBlueBase50;
                    }
                    return AppColors.darkBlueBase;
                  },
                ),
                shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                  (Set<WidgetState> states) {
                    return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: states.contains(WidgetState.disabled)
                            ? AppColors.darkBlueBase50
                            : AppColors.darkBlueBase,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          child: AsyncPaginatedDataTable2(
            dataRowHeight: dataRowHeight,
            columnSpacing: columnSpacing,
            horizontalMargin: horizontalMargin,
            minWidth: minWidth,
            dividerThickness: 0,
            wrapInCard: false,
            controller: controller,
            columns: columns,
            showFirstLastButtons: true,
            loading: const Center(child: CircularProgressIndicator()),
            errorBuilder: (error) => SizedBox.expand(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: SizedBox(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Error: ${error.toString()}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
            source: dataSource,
          ),
        ),
      ),
    );
  }
}
