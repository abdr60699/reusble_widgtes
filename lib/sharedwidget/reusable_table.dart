import 'package:flutter/material.dart';

/// Simple reusable data table. 
/// columns: list of column keys and labels.
/// rows: list of maps where keys match column keys.
class ReusableTable extends StatelessWidget {
  final List<MapEntry<String, String>> columns;
  final List<Map<String, dynamic>> rows;
  final bool showCheckboxColumn;
  final void Function(int rowIndex, int columnIndex)? onCellTap;

  const ReusableTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.showCheckboxColumn = false,
    this.onCellTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: showCheckboxColumn,
        columns: columns
            .map((c) => DataColumn(label: Text(c.value)))
            .toList(),
        rows: List.generate(rows.length, (rIdx) {
          final row = rows[rIdx];
          return DataRow(
            cells: List.generate(columns.length, (cIdx) {
              final key = columns[cIdx].key;
              final value = row[key]?.toString() ?? '';
              return DataCell(
                Text(value),
                onTap: () {
                  if (onCellTap != null) onCellTap!(rIdx, cIdx);
                },
              );
            }),
          );
        }),
      ),
    );
  }
}
