// * CLASS ADDED BY RAHI
import 'package:flutter/material.dart';
import 'package:rsta/Global/Models/CustomColors.dart';
import 'package:rsta/Global/Models/Student.dart';

class SearchBarDelegate extends SearchDelegate {
  SearchBarDelegate({this.items});
  List<Student> items;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Student> filterData = [];
    // Logic for filter data
    if (query.isNotEmpty) {
      filterData = items
          .where((student) =>
              (student.name.toLowerCase().contains(query) ||
                  student.name.toLowerCase().contains(query)) &&
              (student.name.toLowerCase().startsWith(query) ||
                  student.name.startsWith(query)))
          .toList();
    } else {
      filterData = items;
    }

    return ListView.builder(
      itemCount: filterData.length,
      itemBuilder: (BuildContext context, index) {
        return InkWell(
          onTap: () {
            close(context, filterData[index]);
          },
          child: Container(
              padding: EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: pinkColor(),
                        backgroundImage: filterData[index].profileImgUrl == ""
                            ? AssetImage("assets/images/avatar.jpg")
                            : NetworkImage(filterData[index].profileImgUrl),
                        minRadius: 30.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filterData[index].name,
                            style: TextStyle(
                                fontSize: 23.0,
                                color: Colors.black,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            filterData[index].batch,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            filterData[index].time,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Student> filterData = [];
    // Logic for filter data
    if (query.isNotEmpty) {
      filterData = items
          .where((student) =>
              (student.name.toLowerCase().contains(query) ||
                  student.name.contains(query)) &&
              (student.name.toLowerCase().startsWith(query) ||
                  student.name.startsWith(query)))
          .toList();
    } else {
      filterData = items;
    }
    return ListView.builder(
      itemCount: filterData.length,
      itemBuilder: (BuildContext context, index) {
        return InkWell(
          onTap: () {
            close(context, filterData[index]);
          },
          child: Container(
              padding: EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: pinkColor(),
                        backgroundImage: filterData[index].profileImgUrl == ""
                            ? AssetImage("assets/images/avatar.jpg")
                            : NetworkImage(filterData[index].profileImgUrl),
                        minRadius: 30.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filterData[index].name,
                            style: TextStyle(
                                fontSize: 23.0,
                                color: Colors.black,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            filterData[index].batch,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            filterData[index].time,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }
}
