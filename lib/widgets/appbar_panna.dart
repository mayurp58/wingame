import 'package:wingame/globalvar.dart' as globals;
import 'package:wingame/pages/wallet.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
class AppbarPanna extends StatefulWidget {
  final String title;
  AppbarPanna({Key? key, required this.title}) : super(key: key);

  @override
  State<AppbarPanna> createState() => _AppbarPannaState();
}

class _AppbarPannaState extends State<AppbarPanna> with AutomaticKeepAliveClientMixin<AppbarPanna>{

  var appBarHeight = kToolbarHeight;  //this value comes from constants.dart and equals to 56.0

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child :  AppBar(
        centerTitle: true,
        title: Text(widget.title.toString()),
        backgroundColor: HexColor("#FEDB87"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  HexColor("#FEDB87"),
                  HexColor("#BD7923"),
                  HexColor("#FEDB87"),]),
          ),
        ),
        bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.deepOrange,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text('1'),
              ),
              Tab(
                child: Text('2'),
              ),
              Tab(
                child: Text('3'),
              ),
              Tab(
                child: Text('4'),
              ),
              Tab(
                child: Text('5'),
              ),
              Tab(
                child: Text('6'),
              )
              ,
              Tab(
                child: Text('7'),
              )
              ,
              Tab(
                child: Text('8'),
              )
              ,
              Tab(
                child: Text('9'),
              )
              ,
              Tab(
                child: Text('0'),
              )
            ]),
        actions: <Widget>[
          ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(HexColor("#FEDB87"))
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Wallet()),
              );
            },
            icon: Icon( // <-- Icon
              Icons.wallet,
              size: 24.0,

            ),
            label: Text(globals.balance.toString()),


            // <-- Text
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

