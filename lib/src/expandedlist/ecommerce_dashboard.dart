import 'package:flutter/material.dart';

class EcommerceDashboard extends StatefulWidget {
  @override
  _EcommerceDashboardState createState() => _EcommerceDashboardState();
}

class _EcommerceDashboardState extends State<EcommerceDashboard> {
  List<String> data = List.generate(40, (i) => 'item $i');

  List<String> cards = List.generate(20, (index) => 'Card $index');

  int selectedIndex = 0;

  _onSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        constraints: BoxConstraints.expand(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 100.0,
              color: Color(0xFFD8D8D8),
              child: ListView.separated(
                  itemBuilder: (context, index) => Container(
                        height: 20.0,
                        child: Center(
                          child: Text(data[index]),
                        ),
                      ),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: data.length),
            ),
            Divider(),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => InkWell(
                        onTap: () => _onSelectedIndex(index),
                        child: AnimatedContainer(
                          height: selectedIndex == index
                              ? MediaQuery.of(context).size.height - 200
                              : 20.0,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.fastOutSlowIn,
                          child: selectedIndex == index ? Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data[index]),
                              Divider(),
                              Expanded(
                                child: GridView.count(
                                  crossAxisCount: cards.length,
                                  children: cards.map((e) => Card(child: Text(e),)).toList(),
                                ),
                              )
                            ],
                          ) : Text(data[index]),
                        ),
                      ),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: data.length),
            )
          ],
        ),
      ),
    );
  }
}
