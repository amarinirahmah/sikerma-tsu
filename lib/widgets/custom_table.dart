import 'package:flutter/material.dart';
import '../styles/style.dart';

class CustomTable {
  // Text style for column headers
  static const TextStyle columnHeaderStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.teal,
  );

  // Decoration for the container around the table
  static BoxDecoration containerDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: Colors.grey.shade300),
    color: Colors.white,
  );

  static ButtonStyle actionButtonStyle(String label) {
    switch (label.toLowerCase()) {
      case 'edit':
      case 'hapus':
      case 'detail':
        return CustomStyle.getButtonStyleByLabel(label);
      default:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
        );
    }
  }

  // DataTable properties
  static const double dataRowHeight = 56;
  static const double headingRowHeight = 56;
  static const double columnSpacing = 20;
  static const double horizontalMargin = 24;

  // Build method to wrap PaginatedDataTable with styling applied
  static Widget styledPaginatedDataTable({
    required List<DataColumn> columns,
    required DataTableSource source,
    int rowsPerPage = 10,
    ValueChanged<int?>? onRowsPerPageChanged,
    Widget? header,
  }) {
    return Container(
      decoration: containerDecoration,
      child: PaginatedDataTable(
        header: header,
        columns:
            columns
                .map(
                  (col) => DataColumn(
                    label: DefaultTextStyle(
                      style: columnHeaderStyle,
                      child: col.label,
                    ),
                    numeric: col.numeric,
                    onSort: col.onSort,
                    tooltip: col.tooltip,
                  ),
                )
                .toList(),
        source: source,
        rowsPerPage: rowsPerPage,
        // onRowsPerPageChanged: null,
        onRowsPerPageChanged: onRowsPerPageChanged,
        columnSpacing: columnSpacing,
        horizontalMargin: horizontalMargin,
        showCheckboxColumn: false,
        dataRowHeight: dataRowHeight,
        headingRowHeight: headingRowHeight,
      ),
    );
  }
}

// Contoh DataTableSource dengan zebra striping dan action button
class ExampleTableSource extends DataTableSource {
  final List<String> columns;
  final List<Map<String, dynamic>> data;
  final String? actionLabel;
  final void Function(Map<String, dynamic> rowData)? onActionPressed;

  ExampleTableSource({
    required this.columns,
    required this.data,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final row = data[index];

    final isEven = index % 2 == 0;
    final bgColor = isEven ? Colors.white : Colors.grey.shade400;

    final cells = [
      ...columns.map((col) => DataCell(Text(row[col]?.toString() ?? ''))),
    ];

    if (actionLabel != null && onActionPressed != null) {
      cells.add(
        DataCell(
          ElevatedButton(
            onPressed: () => onActionPressed!(row),
            child: Text(actionLabel!),
            style: CustomTable.actionButtonStyle(actionLabel!),
          ),
        ),
      );
    }

    return DataRow.byIndex(
      index: index,
      color: MaterialStateProperty.all(bgColor),
      cells: cells,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
