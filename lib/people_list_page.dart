import 'dart:developer';

import 'package:employees_catalogue/data/component.dart';
import 'package:employees_catalogue/data/person.dart';
import 'package:employees_catalogue/person_details_page.dart';
import 'package:employees_catalogue/widget_keys.dart';
import 'package:flutter/material.dart';
import 'package:employees_catalogue/data/extensions.dart';

class PeopleListPage extends StatefulWidget {
  final String title;

  const PeopleListPage({Key key, this.title}) : super(key: key);

  @override
  _PeopleListPageState createState() => _PeopleListPageState();
}

class _PeopleListPageState extends State<PeopleListPage> {
  List<Person> people;
  TextEditingController _searchController;
  bool _isSearching = false;
  Responsibility responsibilityFilter;
  String previousQuery = '';

  @override
  void initState() {
    _searchController = TextEditingController();
    people = Component.instance.api.searchPeople();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: LeadingWidget(
            isSearching: _isSearching,
            onClick: () {
              if (_isSearching) {
                _isSearching = false;
                _searchController.clear();
              } else {
                _isSearching = true;
              }
              setState(() {});
              // TODO search
            },
          ),
          title: _isSearching
              ? TextField(
                  key: WidgetKey.search,
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Search employee...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white30),
                  ),
                  onChanged: (text) => setState(() {}),
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                )
              : Text(widget.title),
          actions: [
            responsibilityFilter != null
                ? InkWell(
                    key: WidgetKey.clearFilter,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('CLEAR'),
                    )),
                    onTap: () {
                      responsibilityFilter = null;
                      setState(() {});
                      // TODO
                    },
                  )
                : PopupMenuButton<Responsibility>(
                    key: WidgetKey.filter,
                    icon: Icon(Icons.filter_list),
                    onSelected: (Responsibility responsibility) {
                      // TODO
                      responsibilityFilter = responsibility;
                      setState(() {});
                    },
                    itemBuilder: (BuildContext context) {
                      return List.generate(Responsibility.values.length,
                          (index) {
                        return PopupMenuItem<Responsibility>(
                            value: Responsibility.values[index],
                            child: Text(
                                '${Responsibility.values[index].toNameString()}'));
                      });
                    },
                  )
          ],
        ),
        body: ListView.builder(
          key: WidgetKey.listOfPeople,
          itemBuilder: (context, index) {
            final filterNull = responsibilityFilter == null;
            final showDataFiltered =
                responsibilityFilter == people[index].responsibility;
            final searchEmployeeByName = people[index]
                .fullName
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

            return (filterNull && searchEmployeeByName)
                ? PersonItemWidget(
                    id: people[index].id,
                    fullName: people[index].fullName,
                    responsibility: people[index].responsibility.toNameString())
                : (showDataFiltered && searchEmployeeByName)
                    ? PersonItemWidget(
                        id: people[index].id,
                        fullName: people[index].fullName,
                        responsibility:
                            people[index].responsibility.toNameString())
                    : Container();
          },
          itemCount: people.length,
        ));
  }
}

class LeadingWidget extends StatelessWidget {
  final bool isSearching;
  final Function() onClick;

  const LeadingWidget({Key key, this.isSearching = false, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isSearching ? const Icon(Icons.clear) : const Icon(Icons.search),
      onPressed: () {
        onClick();
      },
    );
  }
}

class PersonItemWidget extends StatelessWidget {
  final int id;
  final String fullName;
  final String responsibility;

  const PersonItemWidget(
      {this.id, this.fullName, this.responsibility = '', Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PersonDetailsPage(personId: id)),
                /// 7. If the item ID is not given on the `PersonDetailsPage`, close the page immediately.
                // MaterialPageRoute(builder: (context) => PersonDetailsPage(personId: 0,)),
              ),
            child: Column(
              children: [
                Text(fullName),
                Text(responsibility),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
