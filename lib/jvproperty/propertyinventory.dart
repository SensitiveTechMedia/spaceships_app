import 'package:flutter/material.dart';
import 'package:spaceships/Common/Constants/color_helper.dart';
import 'package:spaceships/colorcode.dart';
import 'package:spaceships/jvproperty/addpropertyjvproperties.dart';
import 'package:spaceships/jvproperty/tabbar/inventory.dart';
import 'package:spaceships/jvproperty/tabbar/lease.dart';
import 'package:spaceships/jvproperty/tabbar/rent.dart';
import 'package:spaceships/jvproperty/tabbar/sell.dart';


class PropertyInventory extends StatefulWidget {
  const PropertyInventory({Key? key}) : super(key: key);

  @override
  State<PropertyInventory> createState() => _PropertyInventoryState();
}

class _PropertyInventoryState extends State<PropertyInventory> {
  List<String> categories = ["Sell", "Lease", "Rent", "Inventory"];
  Color customTeal = Color(0xFF8F00FF);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
    child: Container(
    decoration: BoxDecoration(
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.6),
    spreadRadius: 12,
    blurRadius: 8,
    offset: Offset(0, 3), // changes position of shadow
    ),
    ],
    ),
    child: AppBar(
    backgroundColor: ColorUtils.primaryColor(),
    iconTheme: IconThemeData(color: Colors.white),
        title: Text("Property Inventory",style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle, size: 38,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JvAddProperty()),
              );
              // Implement search functionality here
            },
          ),
        ],
      ),
    ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 25,),
      Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0), // Adjust horizontal padding as needed
      child: GestureDetector(
        onTap: () {

        },
        child: TextFormField(
          readOnly: true,
          onTap: () {

          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: GestureDetector(
              onTap: () {

              },
              child: Icon(Icons.search,  color: ColorUtils.primaryColor(),),
            ),
            suffixIcon: UnconstrainedBox(
              child: Row(
                children: [
                  Container(
                    width: 1,
                    color: ColorCodes.grey.withOpacity(0.4),
                  ),
                ],
              ),
            ),
            constraints: BoxConstraints(maxHeight: 80, maxWidth: double.infinity), // Ensure it takes full width
            contentPadding: EdgeInsets.only(top: 10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: 'Search ',
            hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: ColorUtils.primaryColor(),
            ),
          ),
        ),
      ),
    ),
    // GridView section
    Padding(
    padding: const EdgeInsets.all(10.0),
    child: GridView.builder(
    shrinkWrap: true,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // Number of tiles in each row
    mainAxisSpacing: 5.0, // Space between rows
    crossAxisSpacing: 5.0, // Space between columns
    childAspectRatio: 1.5, // Aspect ratio of each tile
    ),
    itemCount: categories.length,
    itemBuilder: (BuildContext context, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
    onTap: () {
    setState(() {
    _selectedIndex = index;
    });
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) {
    switch (index) {
    case 0:
    return selltab();
    case 1:
    return leasetab();
    case 2:
    return renttab();
    case 3:
    return inventorytab();
    default:
    return selltab();
    }
    },
    ),
    );
    },
    child: Card(
    color: isSelected? customTeal : customTeal,
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    CircleAvatar(
    backgroundColor: Colors.white, // White background
    child: Icon(
    index == 0
    ? Icons.all_inbox
        : index == 1
    ? Icons.home
        : index == 2
    ? Icons.home
        : Icons.apartment,
      color: ColorUtils.primaryColor(), // Teal colored icon
    size: 25.0,
    ),
    ),
    SizedBox(height: 8.0),
    Text(
    categories[index],
    style: TextStyle(
    color: isSelected? Colors.white : Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
    ),
    ),
    ],
    ),
    ),
    ),
    );                  }),
    ),

    Expanded(
    child: ListView.builder(
    itemCount: 2,
    itemBuilder: (BuildContext context, int index) {
    return ListTile(
    title: Text('Property Name'),
    subtitle:Text ("Address"),
    onTap: () {
    // Handle list item tap
    },
    );
    },
    ),
    ),
    ],
    ),
    );
    }
  }