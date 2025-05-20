import 'package:flutter/material.dart';
import 'package:sikermatsu/styles/style.dart';

class CustomPaginatedTable extends StatefulWidget {
  final String title;
  final List<String> columns;
  final List<Map<String, dynamic>> data;
  final String? actionLabel;
  final void Function(BuildContext context, Map<String, dynamic> rowData)?
  onActionPressed;

  const CustomPaginatedTable({
    super.key,
    required this.title,
    required this.columns,
    required this.data,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  State<CustomPaginatedTable> createState() => _CustomPaginatedTableState();
}

class _CustomPaginatedTableState extends State<CustomPaginatedTable> {
  int _rowsPerPage = 10;
  int _currentPage = 0;

  List<int> _availableRowsPerPage = [10, 15, 20];

  int get _pageCount => (widget.data.length / _rowsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    final start = _currentPage * _rowsPerPage;
    final end = (_currentPage + 1) * _rowsPerPage;
    final pageItems = widget.data.sublist(
      start,
      end > widget.data.length ? widget.data.length : end,
    );

    return Center(
      child: SizedBox(
        width: 1000,
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: CustomStyle.headline2),
                  const SizedBox(height: 12),

                  // Horizontal scroll hanya untuk table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing:
                          (1000 - 40) /
                          (widget.columns.length +
                              (widget.actionLabel != null ? 1 : 0)),
                      columns: [
                        ...widget.columns.map(
                          (col) => DataColumn(label: Text(col)),
                        ),
                        if (widget.actionLabel != null)
                          DataColumn(label: Text(widget.actionLabel!)),
                      ],
                      rows: List<DataRow>.generate(pageItems.length, (index) {
                        final item = pageItems[index];
                        final isEvenRow = index % 2 == 0;
                        final cells =
                            widget.columns
                                .map(
                                  (col) => DataCell(
                                    Text(item[col]?.toString() ?? ''),
                                  ),
                                )
                                .toList();

                        if (widget.actionLabel != null &&
                            widget.onActionPressed != null) {
                          cells.add(
                            DataCell(
                              ElevatedButton(
                                style: CustomStyle.getButtonStyleByLabel(
                                  widget.actionLabel!,
                                ),
                                onPressed:
                                    () =>
                                        widget.onActionPressed!(context, item),
                                child: Text(widget.actionLabel!),
                              ),
                            ),
                          );
                        }

                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color?>(
                            (states) =>
                                isEvenRow
                                    ? Colors.grey.shade200.withOpacity(0.4)
                                    : null,
                          ),
                          cells: cells,
                        );
                      }),
                    ),
                  ),

                  // Controls
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('Rows per page: '),
                            DropdownButton<int>(
                              value: _rowsPerPage,
                              items:
                                  _availableRowsPerPage
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.toString()),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _rowsPerPage = value;
                                    _currentPage = 0;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed:
                                  _currentPage > 0
                                      ? () => setState(() => _currentPage--)
                                      : null,
                            ),
                            Text('${_currentPage + 1} / $_pageCount'),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed:
                                  _currentPage < _pageCount - 1
                                      ? () => setState(() => _currentPage++)
                                      : null,
                            ),
                          ],
                        ),
                      ],
                    ),
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
