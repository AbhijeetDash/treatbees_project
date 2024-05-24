import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:treatbees/layout/theme.dart';
import 'package:treatbees/utils/formData.dart';

class AddCafe extends StatefulWidget {
  @override
  _AddCafeState createState() => _AddCafeState();
}

class _AddCafeState extends State<AddCafe> {
  // Main Selection Object;
  Selections selections = new Selections();

  ScrollController scrollController = new ScrollController();

  // Variable to maintain;
  String _char = "", _seating = "";
  bool v1 = false, v2 = false, v3 = false, v4 = false, v5 = false;
  bool d1 = false,
      d2 = false,
      d3 = false,
      d4 = false,
      d5 = false,
      d6 = false,
      d7 = false;
  bool tnc = false;

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _fhour,
      _fminute,
      _ftime = "FROM",
      _fsession,
      _thour,
      _tminute,
      _ttime = "TO",
      _tsession;

  TextEditingController _timeController = TextEditingController();
  TextEditingController _restoName = TextEditingController();
  TextEditingController _ownerName = TextEditingController();
  TextEditingController _ownerEmail = TextEditingController();
  TextEditingController _restoCity = TextEditingController();
  TextEditingController _ownerPhone = TextEditingController();
  TextEditingController _restoPhone = TextEditingController();
  TextEditingController _adsL1 = TextEditingController();
  TextEditingController _adsL2 = TextEditingController();
  TextEditingController _adsMark = TextEditingController();

  List<bool> days = [false, false, false, false, false, false, false];
  List<Map<String, String>> daytime = [];

  // All Validation variable;
  bool restoNameValidate = false,
      ownerNameValidate = false,
      ownerEmailValidate = false,
      restoCityValidate = false,
      ownerPhoneValidate = false,
      restoPhoneValidate = false,
      adsL1Validate = false,
      adsL2Validate = false,
      adsLMarkValidate = false,
      seatingValidate = false,
      serviceValidate = false,
      pocValidate = false,
      timeValidate = false;

  // TimeTravel functions
  Future<Null> _selectFTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _fhour = selectedTime.hour.toString();
        _fminute = selectedTime.minute.toString();
        _fsession = selectedTime.period.toString().split('.')[1];
        if (_fhour == '0') {
          _fhour = '12';
        }
        if (_fminute == '0') {
          _fminute = '00';
        }
        _ftime = _fhour + ' : ' + _fminute + ' ' + _fsession;
        _timeController.text = _ftime;
      });
  }

  Future<Null> _selectTTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _thour = selectedTime.hour.toString();
        _tminute = selectedTime.minute.toString();
        _tsession = selectedTime.period.toString().split('.')[1];
        if (_thour == '0') {
          _thour = '12';
        }
        if (_tminute == '0') {
          _tminute = '00';
        }
        _ttime = _thour + ' : ' + _tminute + ' ' + _tsession;
        _timeController.text = _ttime;
      });
  }

  //Main build method;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: Colors.yellow[900],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.fastfood, color: Colors.white),
            SizedBox(width: 10),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Treat', style: MyFonts().smallHeadingBold),
                TextSpan(text: 'Bees', style: MyFonts().smallHeadingLight),
              ]),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80'))),
        child: Container(
          width: width,
          height: height,
          color: Colors.black.withOpacity(0.7),
          child: Stack(
            children: [
              Container(
                width: width,
                height: height,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Add a Restaurant",
                        style: MyFonts().smallHeadingBold,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Basic info",
                        style: MyFonts().smallHeadingLight,
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      // BLOCK ONE BASIC DETAILS
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: width * 0.6,
                          decoration: BoxDecoration(
                              color: MyColors().alice,
                              border: Border.all(
                                  color: Colors.yellow[900], width: 5)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Text("RESTAURANT NAME"),
                                ),

                                //

                                SizedBox(
                                  width: width * 0.25,
                                  height: 60,
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        restoNameValidate = false;
                                      });
                                    },
                                    controller: _restoName,
                                    decoration: InputDecoration(
                                        errorText: restoNameValidate
                                            ? "This can't be empty"
                                            : null,
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        border: OutlineInputBorder(),
                                        hintText: "Enter restaurant name..",
                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700])),
                                  ),
                                ),

                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Text("OWNER'S NAME"),
                                ),

                                //

                                SizedBox(
                                  width: width * 0.25,
                                  height: 60,
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        ownerNameValidate = false;
                                      });
                                    },
                                    controller: _ownerName,
                                    decoration: InputDecoration(
                                        errorText: ownerNameValidate
                                            ? "This can't be empty"
                                            : null,
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        border: OutlineInputBorder(),
                                        hintText: "Enter owner's name..",
                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700])),
                                  ),
                                ),
                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Text("OWNER'S EMAIL"),
                                ),

                                //

                                SizedBox(
                                  width: width * 0.25,
                                  height: 60,
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    onTap: () {
                                      setState(() {
                                        ownerEmailValidate = false;
                                      });
                                    },
                                    controller: _ownerEmail,
                                    decoration: InputDecoration(
                                        errorText: ownerEmailValidate
                                            ? "This can't be empty"
                                            : null,
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        border: OutlineInputBorder(),
                                        hintText: "Enter owner's email..",
                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700])),
                                  ),
                                ),

                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 8.0),
                                  child: Text("CITY"),
                                ),

                                //

                                SizedBox(
                                  width: width * 0.25,
                                  height: 60,
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        restoCityValidate = false;
                                      });
                                    },
                                    controller: _restoCity,
                                    decoration: InputDecoration(
                                        errorText: restoCityValidate
                                            ? "This can't be empty"
                                            : null,
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        border: OutlineInputBorder(),
                                        hintText: "Enter city name..",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700])),
                                  ),
                                ),

                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 8.0),
                                  child: Text(
                                      "ARE YOU THE OWNER OR MANAGER OF THIS PLACE"),
                                ),

                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, right: 8.0),
                                  child: Container(
                                    width: width * 0.6,
                                    decoration: BoxDecoration(
                                        border: pocValidate
                                            ? Border.all(color: Colors.red)
                                            : null),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: ListTile(
                                            leading: Radio(
                                              value: "OWNER",
                                              activeColor: Colors.orange,
                                              groupValue: _char,
                                              onChanged: (a) {
                                                setState(() {
                                                  pocValidate = false;
                                                  _char = a;
                                                });
                                              },
                                            ),
                                            title: Text("I am the owner."),
                                          ),
                                        ),
                                        Container(
                                          child: ListTile(
                                            leading: Radio(
                                              value: "NOTOWNER",
                                              activeColor: Colors.orange,
                                              groupValue: _char,
                                              onChanged: (a) {
                                                setState(() {
                                                  pocValidate = false;
                                                  _char = a;
                                                });
                                              },
                                            ),
                                            title: Text("I am the manager."),
                                          ),
                                        ),
                                        Container(
                                          child: ListTile(
                                            leading: Radio(
                                              value: "NOTOWNERNOTMANAGER",
                                              activeColor: Colors.orange,
                                              groupValue: _char,
                                              onChanged: (a) {
                                                setState(() {
                                                  pocValidate = false;
                                                  _char = a;
                                                });
                                              },
                                            ),
                                            title: Text(
                                                "I am not the owner/manager."),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 8.0),
                                  child: Text("PHONE NUMBER"),
                                ),

                                //

                                SizedBox(
                                  width: width * 0.25,
                                  height: 60,
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        ownerPhoneValidate = false;
                                      });
                                    },
                                    controller: _ownerPhone,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        errorText: ownerPhoneValidate
                                            ? "Check this field again.."
                                            : null,
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        border: OutlineInputBorder(),
                                        hintText: "Enter Owner's phone no.",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700])),
                                  ),
                                ),

                                //

                                SizedBox(
                                  height: 8.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Location",
                        style: MyFonts().smallHeadingLight,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: width * 0.6,
                          decoration: BoxDecoration(
                              color: MyColors().alice,
                              border: Border.all(
                                  color: Colors.yellow[900], width: 5)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Text("ADDRESS LINE 1"),
                                ),

                                //

                                SizedBox(
                                  width: width * 0.25,
                                  height: 60,
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        adsL1Validate = false;
                                      });
                                    },
                                    controller: _adsL1,
                                    decoration: InputDecoration(
                                        errorText: adsL1Validate
                                            ? "This can't be empty"
                                            : null,
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        border: OutlineInputBorder(),
                                        hintText:
                                            "Enter shop address details..",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700])),
                                  ),
                                ),

                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 8.0),
                                  child: Text("ADDRESS LINE 2"),
                                ),

                                //

                                SizedBox(
                                  width: width * 0.25,
                                  height: 60,
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        adsL2Validate = false;
                                      });
                                    },
                                    controller: _adsL2,
                                    decoration: InputDecoration(
                                        errorText: adsL2Validate
                                            ? "This can't be empty"
                                            : null,
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        border: OutlineInputBorder(),
                                        hintText: "Enter place or locality..",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700])),
                                  ),
                                ),

                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 8.0),
                                  child: Text("LANDMARK"),
                                ),

                                //

                                SizedBox(
                                  width: width * 0.25,
                                  height: 60,
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        adsLMarkValidate = false;
                                      });
                                    },
                                    controller: _adsMark,
                                    decoration: InputDecoration(
                                        errorText: adsLMarkValidate
                                            ? "This can't be empty"
                                            : null,
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        border: OutlineInputBorder(),
                                        hintText:
                                            "Enter other relevant details..",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700])),
                                  ),
                                ),

                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 8.0),
                                  child: Text("PHONE NUMBER"),
                                ),

                                //

                                SizedBox(
                                  width: width * 0.25,
                                  height: 60,
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        restoPhoneValidate = false;
                                      });
                                    },
                                    controller: _restoPhone,
                                    decoration: InputDecoration(
                                        errorText: restoPhoneValidate
                                            ? "This can't be empty"
                                            : null,
                                        errorStyle:
                                            TextStyle(color: Colors.red),
                                        border: OutlineInputBorder(),
                                        hintText:
                                            "Enter restaurant's phone number..",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700])),
                                  ),
                                ),

                                //

                                SizedBox(
                                  height: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Characterstics",
                        style: MyFonts().smallHeadingLight,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: width * 0.6,
                          decoration: BoxDecoration(
                              color: MyColors().alice,
                              border: Border.all(
                                  color: serviceValidate
                                      ? Colors.red
                                      : Colors.yellow[900],
                                  width: 5)),
                          child: Padding(
                            padding: EdgeInsets.only(top: 15.0, left: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 8.0),
                                  child: Text("SERVICES"),
                                ),

                                //

                                Container(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: v1,
                                            onChanged: (vnew) {
                                              setState(() {
                                                v1 = vnew;
                                                serviceValidate = false;
                                              });
                                            },
                                          ),
                                          Text("Breakfast")
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Row(
                                        children: [
                                          Checkbox(
                                            activeColor: Colors.orange,
                                            value: v2,
                                            onChanged: (vnew) {
                                              setState(() {
                                                v2 = vnew;
                                                serviceValidate = false;
                                              });
                                            },
                                          ),
                                          Text("Lunch")
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Row(
                                        children: [
                                          Checkbox(
                                            activeColor: Colors.orange,
                                            value: v3,
                                            onChanged: (vnew) {
                                              setState(() {
                                                v3 = vnew;
                                                serviceValidate = false;
                                              });
                                            },
                                          ),
                                          Text("Dinner")
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Row(
                                        children: [
                                          Checkbox(
                                            activeColor: Colors.orange,
                                            value: v4,
                                            onChanged: (vnew) {
                                              setState(() {
                                                v4 = vnew;
                                                serviceValidate = false;
                                              });
                                            },
                                          ),
                                          Text("Café")
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Row(
                                        children: [
                                          Checkbox(
                                            activeColor: Colors.orange,
                                            value: v5,
                                            onChanged: (vnew) {
                                              setState(() {
                                                v5 = vnew;
                                                serviceValidate = false;
                                              });
                                            },
                                          ),
                                          Text("Snacks")
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 8.0),
                                  child: Text("SEATING"),
                                ),

                                //

                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, right: 8.0),
                                  child: Container(
                                    width: width * 0.6,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: width * 0.25,
                                          child: ListTile(
                                            leading: Radio(
                                              activeColor: Colors.orange,
                                              value: "SEATING",
                                              groupValue: _seating,
                                              onChanged: (a) {
                                                setState(() {
                                                  _seating = a;
                                                });
                                              },
                                            ),
                                            title: Text("Seating available"),
                                          ),
                                        ),
                                        Container(
                                          width: width * 0.25,
                                          child: ListTile(
                                            leading: Radio(
                                              activeColor: Colors.orange,
                                              value: "NOSEATING",
                                              groupValue: _seating,
                                              onChanged: (a) {
                                                setState(() {
                                                  _seating = a;
                                                });
                                              },
                                            ),
                                            title: Text("No seating available"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      serviceValidate
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                color: Colors.red,
                                width: width * 0.6,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Check this section please",
                                  style: TextStyle(
                                      color: Colors.white,
                                      backgroundColor: Colors.red),
                                ),
                              ),
                            )
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                      //

                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Timing",
                        style: MyFonts().smallHeadingLight,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: width * 0.6,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: timeValidate
                                      ? Colors.red
                                      : Colors.yellow[900],
                                  width: 5)),
                          child: Padding(
                            padding: EdgeInsets.only(top: 15.0, left: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 8.0),
                                  child: Text("WORKING DAYS"),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                  activeColor: Colors.orange,
                                                  value: d1,
                                                  onChanged: (vnew) {
                                                    setState(() {
                                                      d1 = vnew;
                                                      days[0] = vnew;
                                                      timeValidate = false;
                                                    });
                                                  }),
                                              Text("Monday")
                                            ],
                                          ),
                                          SizedBox(width: 10),
                                          Row(
                                            children: [
                                              Checkbox(
                                                activeColor: Colors.orange,
                                                value: d2,
                                                onChanged: (vnew) {
                                                  setState(() {
                                                    d2 = vnew;
                                                    timeValidate = false;
                                                    days[1] = vnew;
                                                  });
                                                },
                                              ),
                                              Text("Tuesday")
                                            ],
                                          ),
                                          SizedBox(width: 10),
                                          Row(
                                            children: [
                                              Checkbox(
                                                activeColor: Colors.orange,
                                                value: d3,
                                                onChanged: (vnew) {
                                                  setState(() {
                                                    d3 = vnew;
                                                    timeValidate = false;
                                                    days[2] = vnew;
                                                  });
                                                },
                                              ),
                                              Text("Wednessday")
                                            ],
                                          ),
                                          SizedBox(width: 10),
                                          Row(
                                            children: [
                                              Checkbox(
                                                activeColor: Colors.orange,
                                                value: d4,
                                                onChanged: (vnew) {
                                                  setState(() {
                                                    d4 = vnew;
                                                    timeValidate = false;
                                                    days[3] = vnew;
                                                  });
                                                },
                                              ),
                                              Text("Thrusday")
                                            ],
                                          ),
                                          SizedBox(width: 10),
                                          Row(
                                            children: [
                                              Checkbox(
                                                activeColor: Colors.orange,
                                                value: d5,
                                                onChanged: (vnew) {
                                                  setState(() {
                                                    d5 = vnew;
                                                    timeValidate = false;
                                                    days[4] = vnew;
                                                  });
                                                },
                                              ),
                                              Text("Friday")
                                            ],
                                          ),
                                          SizedBox(width: 10),
                                          Row(
                                            children: [
                                              Checkbox(
                                                activeColor: Colors.orange,
                                                value: d6,
                                                onChanged: (vnew) {
                                                  setState(() {
                                                    d6 = vnew;
                                                    timeValidate = false;
                                                    days[5] = vnew;
                                                  });
                                                },
                                              ),
                                              Text("Saturday")
                                            ],
                                          ),
                                          SizedBox(width: 10),
                                          Row(
                                            children: [
                                              Checkbox(
                                                activeColor: Colors.orange,
                                                value: d7,
                                                onChanged: (vnew) {
                                                  setState(() {
                                                    d7 = vnew;
                                                    timeValidate = false;
                                                    days[6] = vnew;
                                                  });
                                                },
                                              ),
                                              Text("Sunday")
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    FlatButton(
                                      color: Colors.orange,
                                      child: Text(_ftime),
                                      onPressed: () {
                                        _selectFTime(context)
                                            .then((value) => {});
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                      child: Text(
                                        "-",
                                        style: TextStyle(fontSize: 30),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    FlatButton(
                                      color: Colors.orange,
                                      child: Text(_ttime),
                                      onPressed: () {
                                        _selectTTime(context)
                                            .then((value) => {});
                                      },
                                    ),
                                    SizedBox(width: 50),
                                    FlatButton(
                                      color: Colors.orange,
                                      child: Text("ADD+"),
                                      onPressed: () {
                                        String day = "";
                                        for (int i = 0; i < 7; i++) {
                                          bool element = days[i];
                                          setState(() {
                                            if (element) {
                                              switch (i) {
                                                case 0:
                                                  day = "Monday";
                                                  break;
                                                case 1:
                                                  day = "Tuesday";
                                                  break;
                                                case 2:
                                                  day = "Wednesday";
                                                  break;
                                                case 3:
                                                  day = "Thrusday";
                                                  break;
                                                case 4:
                                                  day = "Friday";
                                                  break;
                                                case 5:
                                                  day = "Saturday";
                                                  break;
                                                case 6:
                                                  day = "Sunday";
                                                  break;
                                              }
                                              if (_ftime == "FROM" ||
                                                  _ttime == "TO") {
                                                setState(() {
                                                  timeValidate = true;
                                                });
                                              }
                                              daytime.add({
                                                "Day": day,
                                                "From": _ftime,
                                                "To": _ttime
                                              });
                                            }
                                            selections.daytime = daytime;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: (daytime.length * 50.0) + 20,
                                  child: ListView.builder(
                                    itemCount: daytime.length,
                                    itemBuilder: (context, i) {
                                      return Container(
                                        height: 50,
                                        child: ListTile(
                                          title: Text(daytime[i]['Day']),
                                          subtitle: Text(
                                              '${daytime[i]['From']} - ${daytime[i]['To']}'),
                                          trailing: IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              setState(() {
                                                daytime.removeAt(i);
                                                selections.daytime = daytime;
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      serviceValidate
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                color: Colors.red,
                                width: width * 0.6,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Check this section please",
                                  style: TextStyle(
                                      color: Colors.white,
                                      backgroundColor: Colors.red),
                                ),
                              ),
                            )
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: width * 0.6,
                          decoration: BoxDecoration(
                              color: MyColors().alice,
                              border: Border.all(
                                  color: Colors.yellow[900], width: 5)),
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: tnc,
                                    onChanged: (vnew) {
                                      setState(() {
                                        tnc = vnew;
                                      });
                                    },
                                  ),
                                  Text("I Accept all terms & conditions"),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FlatButton(
                                color: Colors.orange,
                                child: Text("Create Café"),
                                onPressed: () {
                                  bool done = validateAndSetAllData();
                                  if (done) {
                                    selections.createCafe().then((value) {
                                      if (value) {
                                        // Clear all the text variables;
                                        unSetAllData();
                                        // show message.. then redirect to home..
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                elevation: 10.0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                insetAnimationCurve:
                                                    Curves.bounceIn,
                                                insetAnimationDuration:
                                                    Duration(seconds: 1),
                                                child: Container(
                                                  width: width * 0.25,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Icon(
                                                        Icons.done_rounded,
                                                        size: 50,
                                                        color: Colors.green,
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Congratulations",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Our team will contact you soon\nuntil then have fun.",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      FlatButton(
                                                        child: Text("OKAY"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                        unSetAllData();
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                elevation: 10.0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                insetAnimationCurve:
                                                    Curves.bounceIn,
                                                insetAnimationDuration:
                                                    Duration(seconds: 1),
                                                child: Container(
                                                  width: width * 0.25,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Icon(
                                                        Icons.error,
                                                        size: 50,
                                                        color: Colors.red,
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Sorry",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Some error occoured",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      FlatButton(
                                                        child: Text("OKAY"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      }
                                    });
                                  } else {
                                    scrollController.animateTo(0.0,
                                        duration: Duration(milliseconds: 1500),
                                        curve: Curves.easeIn);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSetAllData() {
    //Basic Details Done
    if (_restoName.text.isEmpty) {
      setState(() {
        restoNameValidate = true;
      });
    } else {
      selections.restaurantName = _restoName.text;
    }

    if (_ownerName.text.isEmpty) {
      setState(() {
        ownerNameValidate = true;
      });
    } else {
      selections.ownerName = _ownerName.text;
    }

    if (_ownerEmail.text.isEmpty ||
        (!_ownerEmail.text.contains('@gmail.com') &&
            !_ownerEmail.text.contains('@yahoo.com') &&
            !_ownerEmail.text.contains('@redifmail.com'))) {
      setState(() {
        ownerEmailValidate = true;
      });
      print(_ownerEmail.text);
    } else {
      selections.ownerEmail = _ownerEmail.text;
    }

    if (_restoCity.text.isEmpty) {
      setState(() {
        restoCityValidate = true;
      });
    } else {
      selections.city = _restoCity.text;
    }

    if (_char.isEmpty) {
      setState(() {
        pocValidate = true;
      });
    } else {
      selections.ownewOrNot = _char;
    }

    if (_ownerPhone.text.isEmpty || _ownerPhone.text.length < 10) {
      setState(() {
        ownerPhoneValidate = true;
      });
    } else {
      selections.ownerPhone = _ownerPhone.text;
    }

    // Location Details Done
    if (_adsL1.text.isEmpty) {
      setState(() {
        adsL1Validate = true;
      });
    } else {
      selections.adsL1 = _adsL1.text;
    }

    if (_adsL2.text.isEmpty) {
      setState(() {
        adsL2Validate = true;
      });
    } else {
      selections.adsL2 = _adsL2.text;
    }

    if (_adsMark.text.isEmpty) {
      setState(() {
        adsLMarkValidate = true;
      });
    } else {
      selections.adsLMark = _adsMark.text;
    }

    if (_restoPhone.text.isEmpty || _restoPhone.text.length < 10) {
      setState(() {
        restoPhoneValidate = true;
      });
    } else {
      selections.restoPhone = _restoPhone.text;
    }

    // Services Details Complex
    if (v1) {
      selections.serviceType.add("Breakfast");
    }
    if (v2) {
      selections.serviceType.add("Lunch");
    }
    if (v3) {
      selections.serviceType.add("Dinner");
    }
    if (v4) {
      selections.serviceType.add("Cafe");
    }
    if (v5) {
      selections.serviceType.add("Snacks");
    }
    selections.serviceType = selections.serviceType.toSet().toList();
    if ((!v1 && !v2 && !v3 && !v4 && !v5) || _seating.length == 0) {
      setState(() {
        serviceValidate = true;
      });
    } else {
      selections.seating = _seating;
    }

    //TimeTravle check
    if (daytime.length == 0) {
      setState(() {
        timeValidate = true;
      });
    }

    // If all the validations are good then return true
    if (!restoNameValidate &&
        !ownerNameValidate &&
        !ownerEmailValidate &&
        !restoCityValidate &&
        !pocValidate &&
        !ownerPhoneValidate &&
        !adsL1Validate &&
        !adsL2Validate &&
        !adsLMarkValidate &&
        !restoPhoneValidate &&
        !serviceValidate &&
        !seatingValidate &&
        !timeValidate) {
      return true;
    }
    return false;
  }

  void unSetAllData() {
    setState(() {
      _char = "";
      daytime = [];
      _seating = "";
      _adsL1.text = "";
      _adsL2.text = "";
      _adsMark.text = "";
      _restoName.text = "";
      _restoCity.text = "";
      _restoPhone.text = "";
      _ownerName.text = "";
      _ownerEmail.text = "";
      _ownerPhone.text = "";
      _ftime = "FROM";
      _ttime = "TO";
      days = [false, false, false, false, false, false, false];
      v1 = false;
      v2 = false;
      v3 = false;
      v4 = false;
      v5 = false;
      d1 = false;
      d2 = false;
      d3 = false;
      d4 = false;
      d5 = false;
      d6 = false;
      d7 = false;
    });
  }
}
