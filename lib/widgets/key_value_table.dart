import 'package:flutter/material.dart';
import 'package:repose/bloc/models.dart';

class KeyValueTable extends StatefulWidget {
  List<KeyValueModel> params;

  KeyValueTable({@required this.params});

  @override
  _KeyValueTableState createState() => _KeyValueTableState(params: this.params);
}

class _KeyValueTableState extends State<KeyValueTable> {
  List<KeyValueModel> params;

  _KeyValueTableState({@required this.params});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Key')),
        DataColumn(label: Text('Value')),
        DataColumn(label: Text('Description')),
      ],
      rows: params.map((p) => DataRow(
        cells: [
          DataCell(Text(p.key), showEditIcon: true),
          DataCell(Text(p.value), showEditIcon: true),
          DataCell(Text(p.description), showEditIcon: true),
        ]
      )).toList(),
    );
  }
}
