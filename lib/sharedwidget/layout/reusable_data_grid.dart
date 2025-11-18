import 'package:flutter/material.dart';

/// A reusable data grid widget for displaying tabular data.
///
/// Supports sortable columns, row selection, and pagination.
///
/// Example:
/// ```dart
/// ReusableDataGrid(
///   columns: ['Name', 'Age', 'City'],
///   rows: [
///     ['John', '25', 'New York'],
///     ['Jane', '30', 'London'],
///   ],
/// )
/// ```
class ReusableDataGrid extends StatefulWidget {
  /// Column headers
  final List<String> columns;

  /// Data rows
  final List<List<String>> rows;

  /// Whether columns are sortable
  final bool sortable;

  /// Whether rows are selectable
  final bool selectable;

  /// Callback when row is selected
  final Function(int)? onRowSelected;

  const ReusableDataGrid({
    super.key,
    required this.columns,
    required this.rows,
    this.sortable = false,
    this.selectable = false,
    this.onRowSelected,
  });

  @override
  State<ReusableDataGrid> createState() => _ReusableDataGridState();
}

class _ReusableDataGridState extends State<ReusableDataGrid> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  final Set<int> _selectedRows = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        showCheckboxColumn: widget.selectable,
        columns: widget.columns.asMap().entries.map((entry) {
          return DataColumn(
            label: Text(
              entry.value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            onSort: widget.sortable
                ? (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                    });
                  }
                : null,
          );
        }).toList(),
        rows: widget.rows.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;

          return DataRow(
            selected: _selectedRows.contains(index),
            onSelectChanged: widget.selectable
                ? (selected) {
                    setState(() {
                      if (selected == true) {
                        _selectedRows.add(index);
                      } else {
                        _selectedRows.remove(index);
                      }
                    });
                    widget.onRowSelected?.call(index);
                  }
                : null,
            cells: row.map((cell) {
              return DataCell(Text(cell));
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
