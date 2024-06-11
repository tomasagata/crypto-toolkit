import 'package:flutter/material.dart';

class FixedSizeGridView extends StatelessWidget {
  final int rows;
  final int columns;
  final Widget Function(BuildContext context, int index) itemBuilder;

  const FixedSizeGridView({
    super.key,
    required this.rows,
    required this.columns,
    required this.itemBuilder
  });

  List<Widget> buildRows(BuildContext context) {
    var rowList = <Widget>[];
    for (int i=0; i<rows; i++) {
      var rowItems = <Widget>[];
      for (int j=0; j<columns; j++) {
        rowItems.add(itemBuilder(context, j+(i*columns)));
      }

      rowList.add(Expanded(child: Row(children: rowItems)));
    }

    return rowList;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: buildRows(context),
    );
  }

}