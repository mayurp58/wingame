import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> itemList = [
    Item("ID1", "First product"),
    Item("ID2", "Second product"),
    Item("ID3", "Third product"),
    Item("ID4", "Fourth product"),
  ];

  Map<String, int> quantities = {};

  void takeNumber(String text, String itemId) {
    try {
      int number = int.parse(text);
      quantities[itemId] = number;
      //print(quantities);
    } on FormatException {}
  }

  Widget singleItemList(int index) {
    Item item = itemList[index];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text("${index + 1}")),
          Expanded(
            flex: 3,
            child: TextFormField(
              keyboardType: TextInputType.number,
              onSaved: (input) => (input==null || input=="" || input !=00) ? takeNumber("0", item.id) : takeNumber(input, item.id),
              validator: (input) => int.parse(input.toString()) < 10
                  ? "Amount Greater Than 10"
                  : null,
              decoration: InputDecoration(
                labelText: "Qty",
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demo")),
      body: Center(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              if (itemList.isEmpty) {
                return CircularProgressIndicator();
              } else {
                return singleItemList(index);
              }
            }),
      ),
    );
  }
}

class Item {
  final String id;
  final String name;

  Item(this.id, this.name);
}