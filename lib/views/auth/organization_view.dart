import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_app/managers/organization_manager.dart';
import 'package:tasky_app/managers/user_manager.dart';
import 'package:tasky_app/models/organization.dart';
import 'package:tasky_app/shared_widgets/custom_checkbox_widget.dart';
import 'package:tasky_app/utils/custom_colors.dart';
import 'package:tasky_app/utils/ui_utils.dart';

final OrganizationManager _organizationManager =
    GetIt.I.get<OrganizationManager>();
final UserManager _userManager = GetIt.I.get<UserManager>();

class OrganizationView extends StatefulWidget {
  @override
  _OrganizationViewState createState() => _OrganizationViewState();
}

class _OrganizationViewState extends State<OrganizationView> {
  bool _isSelected = false;
  UniqueKey _uniqueKey = UniqueKey();
   final UiUtilities uiUtilities = UiUtilities();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: FutureBuilder<Organization>(
            future: _organizationManager.getOrganization(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  snapshot.data == null) {
                return SpinKitDoubleBounce(color: customRedColor, size: 50);
              }

              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data == null) {
                return Column(
                  children: [Text('No data')],
                );
              }
              return ListView(
                shrinkWrap: true,
                children: [
                  Center(
                      child: Text(
                    snapshot.data.data.name,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  )),
                  Center(
                      child: Text(
                    'Select your department',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.grey),
                  )),
                  ListView.separated(
                    key: _uniqueKey,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(24),
                    itemBuilder: (context, index) => OrganizationCard(
                        organization: snapshot.data.data.department[index],
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
                    itemCount: snapshot.data.data.department.length,
                  ),
                  Spacer(),
                  Visibility(
                    visible: _isSelected,
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: FlatButton(
                        onPressed: _userManager.isLoading ? (){} :() async {
                          bool isSuccessful = await _userManager
                              .updateUserDepartment(department: null);
                                 if (isSuccessful) {
                  uiUtilities.actionAlertWidget(
                      context: context, alertType: 'success');
                  uiUtilities.alertNotification(
                      context: context, message: _userManager.message);
                  Future.delayed(Duration(seconds: 3), () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  });
                } else {
                  uiUtilities.actionAlertWidget(
                      context: context, alertType: 'error');
                  uiUtilities.alertNotification(
                      context: context, message: _userManager.message);
                }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: _userManager.isLoading ? SpinKitSquareCircle(color: Colors.white, size: 40) : Text(
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
              );
            }),
      ),
    );
  }
}

/// Cardview for organization
class OrganizationCard extends StatelessWidget {
  const OrganizationCard({
    Key key,
    @required this.organization,
    @required this.onTap,
    this.isSelected,
  }) : super(key: key);

  final bool isSelected;
  final String organization;
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
          padding: const EdgeInsets.all(20.0),
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
              Text(
                organization,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
