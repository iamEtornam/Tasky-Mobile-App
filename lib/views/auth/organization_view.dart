import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasky_app/shared_widgets/custom_checkbox_widget.dart';
import 'package:tasky_app/utils/custom_colors.dart';

class OrganizationView extends StatefulWidget {
  @override
  _OrganizationViewState createState() => _OrganizationViewState();
}

class _OrganizationViewState extends State<OrganizationView> {
  bool _isSelected = false;
  UniqueKey _uniqueKey = UniqueKey();
  final List<Map<String, dynamic>> data = [
    {'id': 1, 'organization': 'Aura Innovations', 'department': 5},
    {'id': 2, 'organization': 'Woo', 'department': 2},
    {'id': 3, 'organization': 'Wonti', 'department': 6},
    {'id': 4, 'organization': 'Quorac', 'department': 3},
    {'id': 5, 'organization': 'Tupic inc.', 'department': 1},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            ListView.separated(
              key: _uniqueKey,
              shrinkWrap: true,
              padding: EdgeInsets.all(24),
              itemBuilder: (context, index) => OrganizationCard(
                  organization: data[index]['organization'],
                  department: data[index]['department'],
                  isSelected: _isSelected,
                  onTap: () {
                    setState(() {
                      if (_isSelected) {
                        _isSelected = false;
                      } else {
                        _isSelected = true;
                      }
                    });
                  }),
              separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
              itemCount: data.length,
            ),
            Spacer(),
            Visibility(
              visible: _isSelected,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: FlatButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          'Continue',
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  color: customRedColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Cardview for organization
class OrganizationCard extends StatelessWidget {
  const OrganizationCard({
    Key key,
    @required this.organization,
    @required this.department,
    @required this.onTap,
    this.isSelected,
  }) : super(key: key);

  final bool isSelected;
  final String organization;
  final int department;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              width: .2,
              color: customGreyColor,
            )),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CustomCheckBox(
                isChecked: isSelected,
                onTap: (value) {
                  onTap();
                },
                uncheckedColor: customGreyColor,
                checkedColor: Colors.green,
                size: 27,
                checkedWidget: Icon(
                  Icons.check,
                  size: 20,
                  color: Colors.green,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    organization,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    Intl.plural(department,
                        args: [department],
                        many: '$department departments',
                        one: '$department department',
                        locale: 'en',
                        other: '$department departments'),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: Colors.grey),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
