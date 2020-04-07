import 'package:covid19/data/models/stats.dart';
import 'package:covid19/screens/stats/small_data_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'big_data_box.dart';

class DetailPerDay extends StatelessWidget {
  final Stats dataOfDay;

  DetailPerDay({
    @required this.dataOfDay,
  });

  @override
  Widget build(BuildContext context) {
    if (dataOfDay == null) return _emptyView(context);

    final dateToDisplay =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(dataOfDay.date));
    final newCases = dataOfDay.newConfirmed.toString();
    final totalActive =
        (dataOfDay.totalConfirmed - dataOfDay.totalRecovered).toString();
    final totalCases = dataOfDay.totalConfirmed.toString();
    final totalRecovered = dataOfDay.totalRecovered.toString();
    final totalDeaths = dataOfDay.totalDeaths.toString();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 16),
        Text('Datos al día: $dateToDisplay',
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body2),
        SizedBox(height: 24),
        Row(
          children: <Widget>[
            Expanded(
              child: BigDataBox(
                label: 'Casos nuevos',
                value: newCases,
                bgColor: Theme.of(context).primaryColor.withAlpha(0xDF),
                strokeColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: BigDataBox(
                label: 'Casos activos',
                value: totalActive,
                bgColor: Colors.grey.shade300,
                strokeColor: Colors.grey,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: SmallDataBox(
                label: 'Totales',
                value: totalCases,
                bgColor: Colors.blue,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: SmallDataBox(
                label: 'Recuperados',
                value: totalRecovered,
                bgColor: Colors.green,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: SmallDataBox(
                label: 'Fallecidos',
                value: totalDeaths,
                bgColor: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _emptyView(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Text('No hay data',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.body1),
    );
  }
}
