// import 'package:flutter/material.dart';
// import 'package:sikermatsu/styles/style.dart';
// import '../helpers/responsive.dart';

// class CustomPaginatedTable extends StatefulWidget {
//   final String title;
//   final List<String> columns;
//   final List<Map<String, dynamic>> data;
//   final void Function(BuildContext, Map<String, dynamic>)? onDetailPressed;
//   final void Function(BuildContext, Map<String, dynamic>)? onEditPressed;
//   final void Function(BuildContext, Map<String, dynamic>)? onDeletePressed;
//   final List<String>? jenisOptions;
//   final List<String>? statusOptions;
//   final String? initialJenis;
//   final String? initialStatus;

//   const CustomPaginatedTable({
//     Key? key,
//     required this.title,
//     required this.columns,
//     required this.data,
//     this.onDetailPressed,
//     this.onEditPressed,
//     this.onDeletePressed,
//     this.jenisOptions,
//     this.statusOptions,
//     this.initialJenis,
//     this.initialStatus,
//   }) : super(key: key);

//   @override
//   State<CustomPaginatedTable> createState() => _CustomPaginatedTableState();
// }

// class _CustomPaginatedTableState extends State<CustomPaginatedTable> {
//   int _rowsPerPage = 10;
//   int _currentPage = 0;
//   String _searchKeyword = '';
//   String? _selectedJenis;
//   String? _selectedStatus;
//   late TextEditingController _searchController;

//   @override
//   void initState() {
//     super.initState();
//     _selectedJenis = widget.initialJenis;
//     _selectedStatus = widget.initialStatus;
//     _searchController = TextEditingController();
//     _searchController.addListener(() {
//       setState(() {
//         _searchKeyword = _searchController.text;
//         _currentPage = 0;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged(String value) {
//     setState(() {
//       _searchKeyword = value;
//       _currentPage = 0;
//     });
//   }

//   void _onJenisChanged(String? value) {
//     setState(() {
//       _selectedJenis = value;
//       _currentPage = 0;
//     });
//   }

//   void _onStatusChanged(String? value) {
//     setState(() {
//       _selectedStatus = value;
//       _currentPage = 0;
//     });
//   }

//   List<Map<String, dynamic>> get _filteredData {
//     return widget.data.where((row) {
//       final matchesSearch =
//           _searchKeyword.isEmpty ||
//           row.values.any(
//             (value) => value.toString().toLowerCase().contains(
//               _searchKeyword.toLowerCase(),
//             ),
//           );

//       final matchesJenis =
//           widget.jenisOptions == null ||
//           _selectedJenis == null ||
//           _selectedJenis!.isEmpty ||
//           row['Jenis'] == _selectedJenis;

//       final matchesStatus =
//           widget.statusOptions == null ||
//           _selectedStatus == null ||
//           _selectedStatus!.isEmpty ||
//           row['Status'] == _selectedStatus;

//       return matchesSearch && matchesJenis && matchesStatus;
//     }).toList();
//   }

//   List<Map<String, dynamic>> get _pagedData {
//     final start = _currentPage * _rowsPerPage;
//     final end = start + _rowsPerPage;
//     final filtered = _filteredData;
//     return filtered.sublist(
//       start,
//       end > filtered.length ? filtered.length : end,
//     );
//   }

//   Widget _buildDropdownFilter({
//     required String hint,
//     required List<String> options,
//     required String? value,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return Expanded(
//       flex: 1,
//       child: DropdownButtonFormField<String?>(
//         value: value,
//         decoration: CustomStyle.dropdownDecoration(hintText: hint),
//         items: [
//           const DropdownMenuItem(value: null, child: Text('Semua')),
//           ...options.map((e) => DropdownMenuItem(value: e, child: Text(e))),
//         ],
//         onChanged: onChanged,
//       ),
//     );
//   }

//   Widget _buildFilterSection() {
//     return Row(
//       children: [
//         Expanded(
//           flex: 3,
//           child: TextField(
//             controller: _searchController,
//             decoration: CustomStyle.inputDecoration(
//               prefixIcon: const Icon(Icons.search),
//               hintText: 'Cari...',
//               suffixIcon: _searchKeyword.isNotEmpty
//                   ? GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _searchController.clear();
//                           _searchKeyword = '';
//                           _currentPage = 0;
//                         });
//                       },
//                       child: const Icon(Icons.close),
//                     )
//                   : null,
//             ),
//             onChanged: _onSearchChanged,
//           ),
//         ),
//         const SizedBox(width: 16),
//         if (widget.jenisOptions != null) ...[
//           _buildDropdownFilter(
//             hint: 'Jenis Dokumen',
//             options: widget.jenisOptions!,
//             value: _selectedJenis,
//             onChanged: _onJenisChanged,
//           ),
//           const SizedBox(width: 16),
//         ],
//         if (widget.statusOptions != null)
//           _buildDropdownFilter(
//             hint: 'Status',
//             options: widget.statusOptions!,
//             value: _selectedStatus,
//             onChanged: _onStatusChanged,
//           ),
//       ],
//     );
//   }

//   Widget _buildTable() {
//     return DataTable(
//       columnSpacing: 32,
//       headingRowColor: MaterialStateColor.resolveWith(
//         (states) => Colors.blueGrey.shade50,
//       ),
//       headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
//       border: TableBorder.all(width: 1, color: Colors.grey.shade300),
//       columns: [
//         ...widget.columns.map(
//           (col) => DataColumn(label: Expanded(child: Text(col))),
//         ),
//         const DataColumn(label: Text("Aksi")),
//       ],
//       rows: _pagedData.map((row) {
//         return DataRow(
//           cells: [
//             ...widget.columns.map(
//               (col) => DataCell(
//                 Text(
//                   row[col]?.toString() ?? '',
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ),
//             DataCell(
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (widget.onDetailPressed != null)
//                     IconButton(
//                       icon: const Icon(Icons.info, color: Colors.blue),
//                       tooltip: 'Detail',
//                       onPressed: () => widget.onDetailPressed!(context, row),
//                     ),
//                   if (widget.onEditPressed != null)
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.orange),
//                       tooltip: 'Edit',
//                       onPressed: () => widget.onEditPressed!(context, row),
//                     ),
//                   if (widget.onDeletePressed != null)
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       tooltip: 'Hapus',
//                       onPressed: () => widget.onDeletePressed!(context, row),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildResponsiveTable() {
//     if (Responsive.isMobile(context) || Responsive.isTablet(context)) {
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: _buildTable(),
//       );
//     } else {
//       return Expanded(child: _buildTable());
//     }
//   }

//   Widget _buildPagination() {
//     final totalPages = (_filteredData.length / _rowsPerPage).ceil();

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         DropdownButton<int>(
//           value: _rowsPerPage,
//           items: [5, 10, 15, 20]
//               .map(
//                 (e) => DropdownMenuItem(
//                   value: e,
//                   child: Text('Tampilkan $e data'),
//                 ),
//               )
//               .toList(),
//           onChanged: (val) {
//             setState(() {
//               _rowsPerPage = val!;
//               _currentPage = 0;
//             });
//           },
//         ),
//         Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.chevron_left),
//               onPressed: _currentPage > 0
//                   ? () => setState(() => _currentPage--)
//                   : null,
//             ),
//             Text('${_currentPage + 1} dari $totalPages'),
//             IconButton(
//               icon: const Icon(Icons.chevron_right),
//               onPressed: (_currentPage + 1) < totalPages
//                   ? () => setState(() => _currentPage++)
//                   : null,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 1000),
//         child: Card(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//           margin: const EdgeInsets.symmetric(vertical: 16),
//           elevation: 1,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(widget.title, style: CustomStyle.headline1),
//                 const SizedBox(height: 16),
//                 _buildFilterSection(),
//                 const SizedBox(height: 16),
//                 _buildResponsiveTable(),
//                 const SizedBox(height: 16),
//                 _buildPagination(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../helpers/responsive.dart'; // asumsikan sudah ada file ini
import '../styles/style.dart'; // asumsi style kamu sudah tersedia

class CustomPaginatedTable extends StatefulWidget {
  final String title;
  final List<String> columns;
  final List<Map<String, dynamic>> data;
  final void Function(BuildContext, Map<String, dynamic>)? onDetailPressed;
  final void Function(BuildContext, Map<String, dynamic>)? onEditPressed;
  final void Function(BuildContext, Map<String, dynamic>)? onDeletePressed;
  final List<String>? jenisOptions;
  final List<String>? statusOptions;
  final String? initialJenis;
  final String? initialStatus;

  const CustomPaginatedTable({
    Key? key,
    required this.title,
    required this.columns,
    required this.data,
    this.onDetailPressed,
    this.onEditPressed,
    this.onDeletePressed,
    this.jenisOptions,
    this.statusOptions,
    this.initialJenis,
    this.initialStatus,
  }) : super(key: key);

  @override
  State<CustomPaginatedTable> createState() => _CustomPaginatedTableState();
}

class _CustomPaginatedTableState extends State<CustomPaginatedTable> {
  int _rowsPerPage = 10;
  int _currentPage = 0;
  String _searchKeyword = '';
  String? _selectedJenis;
  String? _selectedStatus;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _selectedJenis = widget.initialJenis;
    _selectedStatus = widget.initialStatus;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDropdownDialog({
  required String title,
  required List<String> options,
  required String? selectedValue,
  required ValueChanged<String?> onSelected,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length + 1,
            itemBuilder: (context, index) {
              final value = index == 0 ? null : options[index - 1];
              final display = index == 0 ? 'Semua' : value!;
              return ListTile(
                title: Text(display),
                trailing: value == selectedValue ? const Icon(Icons.check) : null,
                onTap: () {
                  Navigator.pop(context);
                  onSelected(value);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          )
        ],
      );
    },
  );
}


  List<Map<String, dynamic>> get _filteredData {
    return widget.data.where((row) {
      final matchesSearch = _searchKeyword.isEmpty ||
          row.values.any((value) =>
              value.toString().toLowerCase().contains(_searchKeyword.toLowerCase()));
      final matchesJenis = widget.jenisOptions == null ||
          _selectedJenis == null ||
          _selectedJenis!.isEmpty ||
          row['Jenis'] == _selectedJenis;
      final matchesStatus = widget.statusOptions == null ||
          _selectedStatus == null ||
          _selectedStatus!.isEmpty ||
          row['Status'] == _selectedStatus;
      return matchesSearch && matchesJenis && matchesStatus;
    }).toList();
  }

  List<Map<String, dynamic>> get _pagedData {
    final start = _currentPage * _rowsPerPage;
    final end = start + _rowsPerPage;
    final filtered = _filteredData;
    return filtered.sublist(start, end > filtered.length ? filtered.length : end);
  }

  Widget _buildDropdownFilter({
    required String hint,
    required List<String> options,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {

    return SizedBox(
  width: 160,
  child: DropdownButtonFormField<String?>(
    isExpanded: true,  // agar label dan item penuh lebar 160 px
    value: value,
    decoration: CustomStyle.dropdownDecoration(hintText: hint),
    items: [
      const DropdownMenuItem(value: null, child: Text('Semua')),
      ...options.map((e) => DropdownMenuItem(value: e, child: Text(e))),
    ],
    onChanged: onChanged,
  ),
);

  //    return Flexible(
  //   child: DropdownButtonFormField<String?>(
  //     isExpanded: true,
  //     value: value,
  //     decoration: CustomStyle.dropdownDecoration(hintText: hint),
  //     items: [
  //       const DropdownMenuItem(value: null, child: Text('Semua')),
  //       ...options.map((e) => DropdownMenuItem(value: e, child: Text(e))),
  //     ],
  //     onChanged: onChanged,
  //   ),
  // );
    // return SizedBox(
    //   width: 100,
    //   child: DropdownButtonFormField<String?>(
    //     value: value,
    //     decoration: CustomStyle.dropdownDecoration(hintText: hint),
    //     items: [
    //       const DropdownMenuItem(value: null, child: Text('Semua'),),
    //       ...options.map((e) => DropdownMenuItem(value: e, child: Text(e))),
    //     ],
    //     onChanged: onChanged,
    //   ),
    // );
  }

 Widget _buildFilterSection() {
  final isMobile = Responsive.isMobile(context);

  return Wrap(
    spacing: 16,
    runSpacing: 8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      SizedBox(
        width: isMobile ? double.infinity : 200,
        child: TextField(
          controller: _searchController,
          decoration: CustomStyle.inputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Cari...',
            suffixIcon: _searchKeyword.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _searchKeyword = '';
                        _currentPage = 0;
                      });
                    },
                    child: const Icon(Icons.close),
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _searchKeyword = value;
              _currentPage = 0;
            });
          },
        ),
      ),
      if (widget.jenisOptions != null)
        isMobile
            ? IconButton(
                tooltip: 'Filter Jenis',
                icon: const Icon(Icons.filter_alt),
                onPressed: () {
                  _showDropdownDialog(
                    title: 'Pilih Jenis Dokumen',
                    options: widget.jenisOptions!,
                    selectedValue: _selectedJenis,
                    onSelected: (val) {
                      setState(() {
                        _selectedJenis = val;
                        _currentPage = 0;
                      });
                    },
                  );
                },
              )
            : _buildDropdownFilter(
                hint: 'Jenis Dokumen',
                options: widget.jenisOptions!,
                value: _selectedJenis,
                onChanged: (val) {
                  setState(() {
                    _selectedJenis = val;
                    _currentPage = 0;
                  });
                },
              ),
      if (widget.statusOptions != null)
        isMobile
            ? IconButton(
                tooltip: 'Filter Status',
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  _showDropdownDialog(
                    title: 'Pilih Status',
                    options: widget.statusOptions!,
                    selectedValue: _selectedStatus,
                    onSelected: (val) {
                      setState(() {
                        _selectedStatus = val;
                        _currentPage = 0;
                      });
                    },
                  );
                },
              )
            : _buildDropdownFilter(
                hint: 'Status',
                options: widget.statusOptions!,
                value: _selectedStatus,
                onChanged: (val) {
                  setState(() {
                    _selectedStatus = val;
                    _currentPage = 0;
                  });
                },
              ),
    ],
  );
}

  Widget _buildTable() {
    return DataTable(
      columnSpacing: 32,
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => Colors.blueGrey.shade50,
      ),
      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      border: TableBorder.all(width: 1, color: Colors.grey.shade300),
      columns: [
        ...widget.columns.map(
          (col) => DataColumn(
            label: Expanded(
              child: Text(col, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        const DataColumn(label: Text("Aksi")),
      ],
      rows: _pagedData.map((row) {
        return DataRow(
          cells: [
            ...widget.columns.map((col) {
              return DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 80, maxWidth: 200),
                  child: Text(
                    row[col]?.toString() ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.onDetailPressed != null)
                    IconButton(
                      icon: const Icon(Icons.info, color: Colors.blue),
                      onPressed: () => widget.onDetailPressed!(context, row),
                    ),
                  if (widget.onEditPressed != null)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => widget.onEditPressed!(context, row),
                    ),
                  if (widget.onDeletePressed != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => widget.onDeletePressed!(context, row),
                    ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPagination() {
    final totalPages = (_filteredData.length / _rowsPerPage).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<int>(
          value: _rowsPerPage,
          items: [5, 10, 15, 20]
              .map((e) => DropdownMenuItem(value: e, child: Text('Tampilkan $e')))
              .toList(),
          onChanged: (val) {
            setState(() {
              _rowsPerPage = val!;
              _currentPage = 0;
            });
          },
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _currentPage > 0
                  ? () => setState(() => _currentPage--)
                  : null,
            ),
            Text('${_currentPage + 1} dari $totalPages'),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: (_currentPage + 1) < totalPages
                  ? () => setState(() => _currentPage++)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalMargin = Responsive.isDesktop(context) ? 32.0 : 16.0;

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Card(
          shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4), 
  ),
          margin: const EdgeInsets.symmetric(vertical: 16),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: CustomStyle.headline1),
                const SizedBox(height: 16),
                _buildFilterSection(),
                const SizedBox(height: 16),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: _buildTable(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPagination(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
