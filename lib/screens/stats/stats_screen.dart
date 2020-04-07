import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid19/data/models/stats.dart';
import 'package:covid19/data/source/data_source_repository.dart';
import 'package:covid19/screens/base/base_state.dart';
import 'package:covid19/screens/map/map_screen.dart';
import 'package:covid19/screens/stats/stats_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'stats_bloc.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends BaseState<StatsScreen, StatsBloc> {
  List<Stats> _stats;
  Stats _selectedDatum;
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

  @override
  void setupBloc() async {
    bloc = StatsBloc(DataSourceRepository());
    bloc.eventObservable.listen((event) {
      if (event is OnDataEvent) {
        setState(() {
          isLoading = false;
          _stats = event.stats;
        });
      } else if (event is OnErrorEvent) {
        setState(() {
          isLoading = false;
        });
      }
    });

    isLoading = true;
    bloc.listStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Casos de Covid-19",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title.copyWith(
                    color: Colors.white,
                  ))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: _stats == null
                ? _buildLoading()
                : Column(
                    children: [
                      _buildLegend(),
                      AspectRatio(
                        aspectRatio: 10 / 8,
                        child: _buildChart(context),
                      ),
                      StreamBuilder(
                          stream: bloc.selectedStatObservable,
                          initialData: null,
                          builder: (c, obj) {
                            return _buildDetail(obj.data as Stats);
                          }),
                      SizedBox(height: 48)
                    ],
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(),
                ),
              );
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.map)),
    );
  }

  Widget _buildLoading() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text("Loading"),
        ],
      ),
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
          getSeriesFrom(
            label: seriesLegend[0]["label"],
            color: seriesLegend[0]["color"],
            data: _stats
                ?.map((s) => SerieItem(s.getDateTime(), s.totalConfirmed))
                ?.toList(),
          ),
          getSeriesFrom(
            label: seriesLegend[1]["label"],
            color: seriesLegend[1]["color"],
            data: _stats
                ?.map((s) => SerieItem(s.getDateTime(), s.totalRecovered))
                ?.toList(),
          ),
          getSeriesFrom(
            label: seriesLegend[2]["label"],
            color: seriesLegend[2]["color"],
            data: _stats
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
                DateTime date =
                    (model.selectedDatum.first.datum as SerieItem).date;
                bloc.selectDate(date, _stats);
              } catch (error) {
                bloc.selectDate(_stats.last.getDateTime(), _stats);
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

  Widget _buildDetail(Stats stats) {
    // return Container(color: Colors.deepOrange,);

    if (stats == null) return Container();
    var dateToDisplay =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(stats.date));

    var newCases = '-';
    var totalActive = '-';
    var totalCases = '-';
    var totalRecovered = '-';
    var totalDeaths = '-';

    if (stats != null) {
      newCases = stats.newConfirmed.toString();
      totalActive = (stats.totalConfirmed - stats.totalRecovered).toString();
      totalCases = stats.totalConfirmed.toString();
      totalRecovered = stats.totalRecovered.toString();
      totalDeaths = stats.totalDeaths.toString();
    }

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
              child: AspectRatio(
                aspectRatio: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor.withAlpha(0xDF),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment(0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Casos nuevos',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.body1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 8),
                      Text(newCases,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.title.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade300,
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment(0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Casos activos',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: 8),
                      Text(totalActive,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: seriesLegend[0]['color'],
              ),
              padding: const EdgeInsets.all(8),
              alignment: Alignment(0, 0),
              child: Column(
                children: [
                  Text('Totales',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.body1.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  Text(totalCases,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.title.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w800)),
                ],
              ),
            )),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: seriesLegend[1]['color'],
                ),
                padding: const EdgeInsets.all(8),
                alignment: Alignment(0, 0),
                child: Column(
                  children: [
                    Text('Recuperados',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.body1.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    Text(totalRecovered,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: seriesLegend[2]['color'],
                ),
                padding: const EdgeInsets.all(8),
                alignment: Alignment(0, 0),
                child: Column(
                  children: [
                    Text('Fallecidos',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.body1.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    Text(totalDeaths,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  charts.Series<SerieItem, DateTime> getSeriesFrom({
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
