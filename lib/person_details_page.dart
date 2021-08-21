import 'package:employees_catalogue/data/component.dart';
import 'package:employees_catalogue/data/person.dart';
import 'package:flutter/material.dart';
import 'package:employees_catalogue/data/extensions.dart';

class PersonDetailsPage extends StatefulWidget {
  final int personId;

  const PersonDetailsPage({Key key, @required this.personId}) : super(key: key);

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  Person person;

  @override
  void initState() {
    if (widget.personId != null) {
      person = Component.instance.api.getPerson(widget.personId);
    }

    /// 7. If the item ID is not given on the `PersonDetailsPage`, close the page immediately.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (person?.id == null) {
        Navigator.pop(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (person?.id == null)
        ? Container()
        : Scaffold(
            appBar:
                AppBar(title: Text('Person details'), leading: CloseButton()),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(person.id.toString()),
                Text(person.fullName),
                Text(person.responsibility.toNameString()),
                Text(person.room),
                Text(person.phone),
                Text(person.email),
              ],
            ),
          );
    // TODO
  }
}
