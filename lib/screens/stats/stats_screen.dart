import 'package:covid19/data/models/stats.dart';
import 'package:covid19/data/source/data_source_repository.dart';
import 'package:covid19/screens/base/base_state.dart';
import 'package:covid19/screens/map/map_screen.dart';
import 'package:covid19/screens/stats/chart_view.dart';
import 'package:flutter/material.dart';

import 'detail_per_day.dart';
import 'stats_bloc.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends BaseState<StatsScreen, StatsBloc> {
  List<Stats> _stats;

  @override
  void setupBloc() async {
    bloc = StatsBloc(DataSourceRepository());
    bloc.listStats();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text("Casos de Covid-19",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                    ))),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              children: [
                StreamBuilder(
                  stream: bloc.statListObservable,
                  initialData: <Stats>[],
                  builder: (c, obj) => ChartView(
                    stats: obj.data as List<Stats>,
                    onDateSelected: bloc.selectDate,
                  ),
                ),
                StreamBuilder(
                  stream: bloc.selectedObservable,
                  initialData: null,
                  builder: (c, obj) =>
                      DetailPerDay(dataOfDay: obj.data as Stats),
                ),
                SizedBox(height: 48)
              ],
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
      ),
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
}
