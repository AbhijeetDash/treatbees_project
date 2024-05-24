import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:treatbees_business/utils/functions.dart';
import 'package:treatbees_business/utils/theme.dart';
import 'package:treatbees_business/utils/widget.dart';

class MenuManager extends StatefulWidget {
  final bool isMenuAvailable;
  final String code;
  const MenuManager(
      {Key key, @required this.isMenuAvailable, @required this.code})
      : super(key: key);
  @override
  _MenuManagerState createState() => _MenuManagerState();
}

class _MenuManagerState extends State<MenuManager> {
  int _tabIndex = 0;
  List<Widget> tab = [];

  @override
  void initState() {
    if (widget.isMenuAvailable == false) {
      _tabIndex = 1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tab = [
      AvailableEdits(
        code: widget.code,
      ),
      MenuCreate(
        code: widget.code,
      )
    ];
    return Scaffold(
      key: GlobalKey(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MyColors().alice,
        elevation: 0.0,
        title: TitleWidget(),
      ),
      body: tab[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        elevation: 0.0,
        backgroundColor: Colors.orange,
        onTap: (insect) {
          setState(() {
            _tabIndex = insect;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.edit), label: "Edit Available"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_chart), label: "Create Menu")
        ],
      ),
    );
  }
}

class MenuCreate extends StatefulWidget {
  final String code;
  const MenuCreate({
    Key key,
    this.code,
  }) : super(key: key);

  @override
  _MenuCreateState createState() => _MenuCreateState();
}

class _MenuCreateState extends State<MenuCreate> {
  FirebaseFirestore cloudInstance;

  TextEditingController _category;
  TextEditingController _dish;
  TextEditingController _price;

  /// Category Updating
  void addCategory(String name) {
    if (name != null || name != "") {
      cloudInstance
          .collection(widget.code)
          .doc('MENU')
          .collection('Categories')
          .doc(name)
          .set({"itemCount": 0});
      setState(() {});
    }
  }

  void deleteCategory(String name) {
    if (name != null || name != "") {
      cloudInstance
          .collection(widget.code)
          .doc('MENU')
          .collection('Categories')
          .doc(name)
          .delete();
      cloudInstance
          .collection(widget.code)
          .doc('MENU')
          .collection('Items')
          .where("Category", isEqualTo: name)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          cloudInstance
              .collection(widget.code)
              .doc('MENU')
              .collection('Items')
              .doc(element.id)
              .delete();
        });
      });
    }

    /// Also delete all the items from this category
  }

  /// Item Updating
  void addItem(String itemName, int price, String category) {
    if (itemName != null || itemName != "") {
      cloudInstance
          .collection(widget.code)
          .doc('MENU')
          .collection('Categories')
          .doc(category)
          .get()
          .then((value) {
        int newCount = value.data()['itemCount'] + 1;
        cloudInstance
            .collection(widget.code)
            .doc('MENU')
            .collection('Categories')
            .doc(category)
            .set({"itemCount": newCount});
      });
      cloudInstance
          .collection(widget.code)
          .doc('MENU')
          .collection('Items')
          .doc(itemName)
          .set(
        {"Category": category, "Price": price, "Availability": "available"},
      );
      setState(() {});
    }
  }

  void updateItem(
      String itemName, int price, String category, String available) {
    if (itemName != null && price != null) {
      cloudInstance
          .collection(widget.code)
          .doc('MENU')
          .collection('Items')
          .doc(itemName)
          .set({
        "Category": category,
        "Price": price,
        "Availability": available
      });
    }
  }

  void deleteItem(String itemName, String category) {
    if (itemName != null && category != null) {
      cloudInstance
          .collection(widget.code)
          .doc('MENU')
          .collection('Categories')
          .doc(category)
          .get()
          .then((value) {
        int newCount = value.data()['itemCount'] - 1;
        cloudInstance
            .collection(widget.code)
            .doc('MENU')
            .collection('Categories')
            .doc(category)
            .set({"itemCount": newCount});
      });
      cloudInstance
          .collection(widget.code)
          .doc('MENU')
          .collection('Items')
          .doc(itemName)
          .delete();
      setState(() {});
    }
  }

  /// SnackBars
  void showAddCategorySnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(minutes: 5),
        backgroundColor: Colors.white,
        content: Theme(
          data: ThemeData(brightness: Brightness.light),
          child: Container(
            height: MediaQuery.of(context).size.height - 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Add Category",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Scaffold.of(context).hideCurrentSnackBar();
                        })
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Name of category",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the category name.',
                  ),
                  controller: _category,
                ),
                FlatButton(
                  onPressed: () {
                    addCategory(_category.text);
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                  child: Text("Add"),
                  color: Colors.orange,
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showAddItemSnackBar(String cateName) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(minutes: 5),
        backgroundColor: Colors.white,
        content: Theme(
          data: ThemeData(brightness: Brightness.light),
          child: Container(
            height: MediaQuery.of(context).size.height - 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      cateName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Scaffold.of(context).hideCurrentSnackBar();
                        })
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Name of Dish",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the Item name.',
                  ),
                  controller: _dish,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Price",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Item Price',
                  ),
                  keyboardType: TextInputType.number,
                  controller: _price,
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  onPressed: () {
                    addItem(_dish.text, int.parse(_price.text), cateName);
                    setState(() {
                      _dish.text = "";
                      _price.text = "";
                    });
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                  child: Text("Add Item"),
                  color: Colors.orange,
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showUpdateItemPriceSnackBar(String itemName, String cateName) {
    _dish.text = itemName;
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(minutes: 5),
        backgroundColor: Colors.white,
        content: Theme(
          data: ThemeData(brightness: Brightness.light),
          child: Container(
            height: MediaQuery.of(context).size.height - 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      cateName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Scaffold.of(context).hideCurrentSnackBar();
                        })
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Name of Dish",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the Item name.',
                  ),
                  controller: _dish,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Price",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter new item price.',
                  ),
                  keyboardType: TextInputType.number,
                  controller: _price,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    FlatButton(
                      onPressed: () {
                        updateItem(_dish.text, int.parse(_price.text), cateName,
                            "available");
                        setState(() {
                          _dish.text = "";
                          _price.text = "";
                        });
                        Scaffold.of(context).hideCurrentSnackBar();
                      },
                      child: Text("Update Item"),
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    FlatButton(
                      onPressed: () {
                        deleteItem(_dish.text, cateName);
                        setState(() {
                          _dish.text = "";
                          _price.text = "";
                        });
                        Scaffold.of(context).hideCurrentSnackBar();
                      },
                      child: Text("Delete Item"),
                      color: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _category = TextEditingController();
    _dish = TextEditingController();
    _price = TextEditingController();
    cloudInstance = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: MyColors().alice,
      height: size.height,
      child: Column(
        children: [
          /// List of Category
          Container(
            height: size.height - 200,
            child: StreamBuilder(
              stream: cloudInstance
                  .collection(widget.code)
                  .doc('MENU')
                  .collection('Categories')
                  .snapshots(),
              builder: (context, categories) {
                QuerySnapshot snapCateDocs = categories.data;
                List<String> categoryName = [];
                List<int> itemHeight = [];

                if (snapCateDocs != null) {
                  snapCateDocs.docs.forEach((element) {
                    categoryName.add(element.id);
                    itemHeight.add(element.data()['itemCount']);
                  });
                }

                /// List of category
                return ListView.builder(
                    itemCount: categoryName.length,
                    itemBuilder: (context, cateIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, bottom: 15.0, right: 5.0),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  MyColors().shadowDark,
                                  MyColors().alice,
                                ]),
                            boxShadow: [
                              BoxShadow(
                                  color: MyColors().shadowDark,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 15,
                                  spreadRadius: 1),
                              BoxShadow(
                                  color: MyColors().shadowLight,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 15,
                                  spreadRadius: 1)
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 10.0,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: size.width- 200,
                                          child: Text(
                                            categoryName[cateIndex],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        RawMaterialButton(
                                          shape: StadiumBorder(),
                                          onPressed: () {
                                            showAddItemSnackBar(
                                                categoryName[cateIndex]);
                                          },
                                          fillColor: Colors.orange,
                                          child: Text("Add Item"),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        CircleAvatar(
                                            backgroundColor:
                                                Colors.orangeAccent,
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  deleteCategory(
                                                      categoryName[cateIndex]);
                                                })),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.black.withOpacity(0.7),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: StreamBuilder(
                                    stream: cloudInstance
                                        .collection(widget.code)
                                        .doc('MENU')
                                        .collection('Items')
                                        .snapshots(),
                                    builder: (context, items) {
                                      QuerySnapshot snapItemData = items.data;
                                      List<Map<String, dynamic>> menuItems = [];

                                      if (snapItemData != null) {
                                        snapItemData.docs.forEach((element) {
                                          if (categoryName[cateIndex] ==
                                              element.data()['Category']) {
                                            menuItems.add({
                                              "DishName": element.id,
                                              "Price": element.data()['Price']
                                            });
                                          }
                                        });
                                      }

                                      double dynaHeight =
                                          itemHeight[cateIndex] * 56.0;

                                      List<Widget> cateColumn = [];

                                      menuItems.forEach((element) {
                                        cateColumn.add(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 5.0,
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  SizedBox(width: 10.0),
                                                  SizedBox(
                                                    width: size.width - 150,
                                                    child: Text(
                                                      element['DishName'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    element['Price'].toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  CircleAvatar(
                                                    radius: 20.0,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.edit,
                                                        size: 20.0,
                                                        color: Colors.black,
                                                      ),
                                                      onPressed: () {
                                                        /// Show Update Price Pop - up
                                                        showUpdateItemPriceSnackBar(
                                                            element['DishName'],
                                                            categoryName[
                                                                cateIndex]);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ));
                                      });

                                      /// Main List of Items
                                      return Container(
                                        height: dynaHeight,
                                        // child: ListView.builder(
                                        //   itemCount: menuItems.length,
                                        //   itemBuilder: (context, itemIndex) {
                                        //     return
                                        //   },
                                        // ),

                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: cateColumn,
                                        ),
                                      );
                                    }),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text("Add items to this category"),
                              ),
                              SizedBox(
                                height: 20.0,
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),

          /// Button To Add A Category
          Container(
            height: 50,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 10.0),
            child: RawMaterialButton(
              shape: StadiumBorder(),
              onPressed: () {
                showAddCategorySnackBar();
              },
              fillColor: Colors.orange,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Add Category +"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Edit Available
// Fetch the available menu
class AvailableEdits extends StatefulWidget {
  AvailableEdits({
    Key key,
    @required this.code,
  }) : super(key: key);

  final String code;

  @override
  _AvailableEditsState createState() => _AvailableEditsState();
}

class _AvailableEditsState extends State<AvailableEdits> {
  FirebaseFirestore cloudInstance;

  @override
  void initState() {
    cloudInstance = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: MyColors().alice,
      height: size.height,
      child: Column(
        children: [
          /// List of Category
          Container(
            height: size.height - 150,
            child: StreamBuilder(
              stream: cloudInstance
                  .collection(widget.code)
                  .doc('MENU')
                  .collection('Categories')
                  .snapshots(),
              builder: (context, categories) {
                QuerySnapshot snapCateDocs = categories.data;
                List<String> categoryName = [];
                List<int> itemHeight = [];

                if (snapCateDocs != null) {
                  snapCateDocs.docs.forEach((element) {
                    categoryName.add(element.id);
                    itemHeight.add(element.data()['itemCount']);
                  });
                }

                /// List of category
                return ListView.builder(
                    itemCount: categoryName.length,
                    itemBuilder: (context, cateIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, bottom: 15.0, right: 5.0),
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  MyColors().shadowDark,
                                  MyColors().alice,
                                ]),
                            boxShadow: [
                              BoxShadow(
                                  color: MyColors().shadowDark,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 15,
                                  spreadRadius: 1),
                              BoxShadow(
                                  color: MyColors().shadowLight,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 15,
                                  spreadRadius: 1)
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 13.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 10.0,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      categoryName[cateIndex],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.black.withOpacity(0.7),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: StreamBuilder(
                                    stream: cloudInstance
                                        .collection(widget.code)
                                        .doc('MENU')
                                        .collection('Items')
                                        .snapshots(),
                                    builder: (context, items) {
                                      QuerySnapshot snapItemData = items.data;
                                      List<Map<String, dynamic>> menuItems = [];

                                      if (snapItemData != null) {
                                        snapItemData.docs.forEach((element) {
                                          if (categoryName[cateIndex] ==
                                              element.data()['Category']) {
                                            menuItems.add({
                                              "DishName": element.id,
                                              "Price": element.data()['Price'],
                                              "Availability":
                                                  element.data()['Availability']
                                            });
                                          }
                                        });
                                      }

                                      double dynaHeight =
                                          itemHeight[cateIndex] * 45.0;

                                      List<Widget> cateColumn = [];

                                      menuItems.forEach((element) {
                                        cateColumn.add(
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 5.0,
                                                        backgroundColor:
                                                        Colors.grey,
                                                      ),
                                                      SizedBox(width: 10.0),
                                                      Text(
                                                        element
                                                        ['DishName'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                  AvailableSwitch(
                                                    code: widget.code,
                                                    isAvailable: element
                                                    ['Availability'] ==
                                                        'available',
                                                    itemName:
                                                    element
                                                    ['DishName'],
                                                    cateName:
                                                    categoryName[cateIndex],
                                                    price: element
                                                    ['Price'],
                                                  )
                                                ],
                                              ),
                                            )
                                        );
                                      });


                                      /// Main List of Items
                                      return Container(
                                        height: dynaHeight,
                                        // child: ListView.builder(
                                        //   itemCount: menuItems.length,
                                        //   itemBuilder: (context, itemIndex) {
                                        //     return
                                        //   },
                                        // ),

                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: cateColumn,
                                        ),
                                      );

                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AvailableSwitch extends StatefulWidget {
  final bool isAvailable;
  final String code;
  final String itemName;
  final String cateName;
  final int price;

  const AvailableSwitch(
      {Key key,
      this.isAvailable,
      this.code,
      this.itemName,
      this.cateName,
      this.price})
      : super(key: key);

  @override
  _AvailableSwitchState createState() => _AvailableSwitchState();
}

class _AvailableSwitchState extends State<AvailableSwitch> {
  FirebaseFirestore cloudInstance;

  @override
  void initState() {
    cloudInstance = FirebaseFirestore.instance;
    super.initState();
  }

  void updateItem(
      String itemName, int price, String category, String available) {
    cloudInstance
        .collection(widget.code)
        .doc('MENU')
        .collection('Items')
        .doc(itemName)
        .set({"Category": category, "Price": price, "Availability": available});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      child: Switch(
          value: widget.isAvailable,
          onChanged: (val) {
            updateItem(widget.itemName, widget.price, widget.cateName,
                val ? "available" : "unavailable");
          }),
    );
  }
}
