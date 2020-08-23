import 'dart:async';

import 'package:bluestacks_assignment/model/tournaments.dart';
import 'package:bluestacks_assignment/model/user.dart';
import 'package:bluestacks_assignment/ui/home/home_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HomeBloc _bloc;
  User _user;
  List<Tournament> tournaments = [];
  bool _hasReachedMax = false;
  final _scrollThreshold = 1000;
  String _cursor;

  ScrollController _scrollController = new ScrollController();

  _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollThreshold && !_hasReachedMax) {
      _bloc.add(GetTournaments(cursor: _cursor));
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        _bloc = HomeBloc();
        return _bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: Icon(Icons.menu, color: Colors.grey,),
          title: Text(_user!=null?_user.userName:"",
              style: TextStyle(
                color: Colors.black,
              )),
        ),
        body: BlocListener<HomeBloc, HomeState>(
          listener: (BuildContext context, HomeState state) {
            if (state is TournamentsFetchedState) {
              setState(() {
                tournaments = tournaments + state.tournaments;
                _hasReachedMax = state.hasReachedMax;
                _cursor = state.cursor;
              });
            }
            if (state is ProfileFetchedState) {
              setState(() {
                _user = state.user;
              });
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (BuildContext context, HomeState state) {
              if (state is HomeInitial) {
                _bloc.add(GetProfile());
                Timer(Duration(seconds: 1, milliseconds: 500), () {
                  _bloc.add(GetTournaments(cursor: _cursor));
                });
              }
              return Container(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _hasReachedMax
                        ? tournaments.length + 1
                        : tournaments.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            getProfileView(),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Recommended for you',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ],
                        );
                      } else if (index == tournaments.length + 1) {
                        return BottomLoader();
                      }
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        margin: const EdgeInsets.only(
                            top: 8, bottom: 8, left: 16, right: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              height: 100,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        topRight: Radius.circular(24),
                                      ),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            tournaments[index - 1].coverUrl,
                                        height: 100,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right:48),
                                          child: Text(
                                            tournaments[index - 1].name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:8.0),
                                          child: Text(
                                            tournaments[index - 1].gameName,
                                            maxLines: 1,

                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_right)
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget getProfileView() {
    return Container(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
                    height: 80,
                    width: 80,
                    alignment: Alignment.topCenter,
                    placeholder: (context, string) {
                      return Container(
                        color: Colors.red,
                      );
                    },
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _user != null ? _user.fullName : "",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 24),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _user != null ? _user.rating.toString() : "",
                                style:
                                    TextStyle(fontSize: 20, color: Colors.blue),
                              ),
                              Text(" "),
                              Text(
                                'Elo rating',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: getStatsWidget(
                      _user != null
                          ? _user.tournamentsStats.played.toString()
                          : "",
                      'Tournaments\nplayed',
                      LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[Colors.red, Colors.orange],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1.0, right: 1),
                      child: getStatsWidget(
                        _user != null
                            ? _user.tournamentsStats.won.toString()
                            : "",
                        'Tournaments\nwon',
                        LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: <Color>[Colors.blue, Colors.lightBlueAccent],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: getStatsWidget(
                      _user != null
                          ? _user.tournamentsStats
                                  .getWinningPercentage()
                                  .toString() +
                              "%"
                          : "",
                      'Winning\npercentage',
                      LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[Colors.deepOrange, Colors.orange],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getStatsWidget(
      String stats, String statsCategory, LinearGradient gradient) {
    return Container(
      height: 100,
      decoration: BoxDecoration(gradient: gradient),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            stats,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            statsCategory,
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
