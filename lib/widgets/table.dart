import 'package:flutter/material.dart';

class TableData extends StatefulWidget {
  final String title;
  final List<String> columns;
  final List<Map<String, dynamic>> data;
  final String actionLabel;
  final void Function(BuildContext context, Map<String, dynamic> rowData)
  onActionPressed;
  final Color Function(String actionLabel)? getActionBgColor;
  final Color Function(String actionLabel)? getActionFgColor;

  const TableData({
    super.key,
    required this.title,
    required this.columns,
    required this.data,
    required this.actionLabel,
    required this.onActionPressed,
    this.getActionBgColor,
    this.getActionFgColor,
  });

  @override
  State<TableData> createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
  int _rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final dataSource = _TableDataSource(
      columns: widget.columns,
      data: widget.data,
      actionLabel: widget.actionLabel,
      context: context,
      onActionPressed: widget.onActionPressed,
      getActionBgColor: widget.getActionBgColor,
      getActionFgColor: widget.getActionFgColor,
    );

    final columns = [
      ...widget.columns.map((col) => DataColumn(label: Text(col))),
      DataColumn(label: Text(widget.actionLabel)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth =
            constraints.maxWidth < 1000 ? constraints.maxWidth : 1000;

        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: maxWidth,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white60.withOpacity(0.1)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: PaginatedDataTable(
                header: null,
                columns: columns,
                source: dataSource,
                rowsPerPage: _rowsPerPage,
                onRowsPerPageChanged: null,
                columnSpacing: 24,
                horizontalMargin: 16,
                showCheckboxColumn: false,
                dataRowMaxHeight: 56,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TableDataSource extends DataTableSource {
  final List<String> columns;
  final List<Map<String, dynamic>> data;
  final String actionLabel;
  final BuildContext context;
  final void Function(BuildContext context, Map<String, dynamic> rowData)
  onActionPressed;
  final Color Function(String actionLabel)? getActionBgColor;
  final Color Function(String actionLabel)? getActionFgColor;

  _TableDataSource({
    required this.columns,
    required this.data,
    required this.actionLabel,
    required this.context,
    required this.onActionPressed,
    required this.getActionBgColor,
    required this.getActionFgColor,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;

    final row = data[index];

    return DataRow(
      cells: [
        ...columns.map((col) => DataCell(Text(row[col]?.toString() ?? ''))),
        DataCell(
          ElevatedButton(
            onPressed: () => onActionPressed(context, row),
            child: Text(actionLabel),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  getActionBgColor?.call(actionLabel) ?? Colors.teal,
              foregroundColor:
                  getActionFgColor?.call(actionLabel) ?? Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
