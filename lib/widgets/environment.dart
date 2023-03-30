import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utilities.dart';

Widget envDashboard2(dynamic stream, BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        final data = snapshot.requireData;
        int gridSize = showTablet(context) ? 20 : 10;

        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //childAspectRatio: 1 / 1,
              crossAxisCount: gridSize,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: data.size,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              double reading = data.docs[index]['reading'];
              var meetsTarget = data.docs[index]['meets_target'];
              return envTile(reading, meetsTarget, context);
            });
      });
}

Future envPopup(double reading, int meetsTarget, BuildContext context) async {
  String targetText = meetsTarget == 1 ? "Adequate" : "Too Dim";
  TextStyle targetStyle = meetsTarget == 1
      ? TextStyle(color: Theme.of(context).colorScheme.primary)
      : TextStyle(color: Theme.of(context).colorScheme.error);
  Color bgColor = meetsTarget == 1
      ? Theme.of(context).colorScheme.primary.withAlpha(10)
      : Theme.of(context).colorScheme.error.withAlpha(10);
  Color goodTile = Theme.of(context).colorScheme.primaryContainer;
  Color badTile = Theme.of(context).colorScheme.errorContainer;
  Color bG = Color.alphaBlend(bgColor, Theme.of(context).dialogBackgroundColor);

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Stack(
            alignment: Alignment.center,
            //mainAxisSize: MainAxisSize.min,
            clipBehavior: Clip.none,
            children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: bG, borderRadius: BorderRadius.circular(20)),
                  width: double.infinity,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        targetText,
                        style: targetStyle,
                        textScaleFactor: 2,
                      ),
                      Text(
                        "7 lux or above is proper for reading",
                        style: targetStyle,
                        textScaleFactor: 1,
                      ),
                    ],
                  )),
              Positioned(
                top: -50,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  alignment: Alignment.center,
                  //margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: meetsTarget == 1 ? goodTile : badTile,
                      borderRadius: BorderRadius.circular(20)),
                  width: 200.0,
                  height: 100.0,
                  child: Text(
                    "$reading lux",
                    style: TextStyle(
                      color: Colors.white.withAlpha(220),
                    ),
                    textScaleFactor: 2,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

Widget envTile(double reading, int meetsTarget, BuildContext context) {
  Color goodTile = Theme.of(context).colorScheme.primaryContainer;
  Color badTile = Theme.of(context).colorScheme.errorContainer;

  return InkWell(
    onTap: () {
      envPopup(reading, meetsTarget, context);
    },
    child: Container(
      padding: const EdgeInsets.all(2),
      alignment: Alignment.center,
      //margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: meetsTarget == 1 ? goodTile : badTile,
          borderRadius: BorderRadius.circular(4)),
      width: 20.0,
      height: 20.0,
      child: Text(
        "",
        //reading.toString(),
        style: TextStyle(color: Colors.white.withAlpha(150)),
      ),
    ),
  );
}

Widget envListing(double reading, int meetsTarget, BuildContext context) {
  if (meetsTarget == 1) {
    return Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reading.toString(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  "ideal",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            )));
  } else {
    return Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.errorContainer.withAlpha(50),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reading.toString(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "too dim",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ),
        ));
  }
}
