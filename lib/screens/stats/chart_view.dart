import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid19/data/models/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ChartView extends StatelessWidget {
  final List<Stats> stats;
  final Function(Stats) onDateSelected;

  final seriesLegend = [
    {
      "label": "Totales",
      "color": Colors.blue.shade500,
    },
    {
      "label": "Recuperados",
      "color": Colors.green.shade500,
    },
    {
      "label": "Fallecidos",
      "color": Colors.red.shade500,
    }
  ];

  ChartView({
    @required this.stats,
    @required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLegend(),
        AspectRatio(
          aspectRatio: 5 / 4,
          child: _buildChart(context),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    List<Widget> items = [];
    seriesLegend.forEach((legend) {
      items.add(Spacer(flex: 1));
      items.addAll(<Widget>[
        SvgPicture.asset(
          'assets/ic_rombus.svg',
          color: legend['color'],
          height: 12.0,
        ),
        SizedBox(width: 4),
        Text(legend['label']),
        Spacer(flex: 1),
      ]);
    });

    return Row(
      children: items,
    );
  }

  Widget _buildChart(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: charts.TimeSeriesChart(
        [
          _getSeriesFrom(
            label: seriesLegend[0]["label"],
            color: seriesLegend[0]["color"],
            data: stats
                ?.map((s) => SerieItem(s.getDateTime(), s.totalConfirmed))
                ?.toList(),
          ),
          _getSeriesFrom(
            label: seriesLegend[1]["label"],
            color: seriesLegend[1]["color"],
            data: stats
                ?.map((s) => SerieItem(s.getDateTime(), s.totalRecovered))
                ?.toList(),
          ),
          _getSeriesFrom(
            label: seriesLegend[2]["label"],
            color: seriesLegend[2]["color"],
            data: stats
                ?.map((s) => SerieItem(s.getDateTime(), s.totalDeaths))
                ?.toList(),
          ),
        ],
        animate: true,
        selectionModels: [
          charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: (model) {
              try {
                final date =
                    (model.selectedDatum.first.datum as SerieItem).date;
                final selectedStat = stats.firstWhere((s) {
                  return s.date == DateFormat("yyyy-MM-dd").format(date);
                });
                onDateSelected(selectedStat);
              } catch (error) {
                onDateSelected(stats.last);
              }
            },
          )
        ],
        behaviors: [
          charts.LinePointHighlighter(
              showHorizontalFollowLine:
                  charts.LinePointHighlighterFollowLineType.none,
              showVerticalFollowLine:
                  charts.LinePointHighlighterFollowLineType.nearest)
        ],
      ),
    );
  }

  charts.Series<SerieItem, DateTime> _getSeriesFrom({
    @required String label,
    @required Color color,
    @required List<SerieItem> data,
  }) {
    return charts.Series<SerieItem, DateTime>(
      id: label,
      colorFn: (_, __) =>
          charts.Color(r: color.red, g: color.green, b: color.blue),
      domainFn: (SerieItem sales, _) => sales.date,
      measureFn: (SerieItem sales, _) => sales.value,
      data: data ?? [],
    );
  }
}

class SerieItem {
  final int value;
  final DateTime date;

  SerieItem(this.date, this.value);
}
