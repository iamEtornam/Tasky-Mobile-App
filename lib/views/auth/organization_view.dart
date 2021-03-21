import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky_app/managers/organization_manager.dart';
import 'package:tasky_app/shared_widgets/custom_bottom_sheet_widget.dart';
import 'package:tasky_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_app/utils/ui_utils/ui_utils.dart';
import 'package:textfield_tags/textfield_tags.dart';

final OrganizationManager _organizationManager =
    GetIt.I.get<OrganizationManager>();

class OrganizationView extends StatefulWidget {
  @override
  _OrganizationViewState createState() => _OrganizationViewState();
}

class _OrganizationViewState extends State<OrganizationView> {
  final UiUtilities uiUtilities = UiUtilities();
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameTextEditingController = TextEditingController();
  List<String> departments = [];
  final nameFocusNode = FocusNode();
  File _imageFile;
  List<Options> options;

  getProfileFromCamera() async {
    await uiUtilities
        .getImage(imageSource: ImageSource.camera)
        .then((file) async {
      File croppedFile = await uiUtilities.getCroppedFile(file: file.path);

      if (croppedFile != null) {
        setState(() {
          _imageFile = croppedFile;
        });
      }
    });
  }

  getProfileFromGallery() async {
    await uiUtilities
        .getImage(imageSource: ImageSource.gallery)
        .then((file) async {
      File croppedFile = await uiUtilities.getCroppedFile(file: file.path);

      if (croppedFile != null) {
        setState(() {
          _imageFile = croppedFile;
        });
      }
    });
  }

  @override
  void initState() {
    options = [
      Options(
          label: 'Select from Camera',
          onTap: () {
            Navigator.pop(context);
            getProfileFromCamera();
          }),
      Options(
          label: 'Select from Gallery',
          onTap: () {
            Navigator.pop(context);
            getProfileFromGallery();
          }),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: Colors
                    .primaries[Random().nextInt(Colors.primaries.length)]
                    .withOpacity(.2),
                radius: 60,
                backgroundImage: _imageFile == null
                    ? ExactAssetImage('assets/avatar.png')
                    : FileImage(_imageFile),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Center(
                child: TextButton(
              child: Text(
                'update profile photo',
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600, color: customRedColor),
              ),
              onPressed: () {
                Platform.isIOS
                    ? showCupertinoModalPopup<void>(
                        context: context,
                        builder: (context) {
                          return CustomBottomSheetWidget(
                            options: options,
                          );
                        })
                    : showModalBottomSheet<void>(
                        context: context,
                        builder: (context) {
                          return CustomBottomSheetWidget(
                            height: 205,
                            options: options,
                          );
                        });
              },
            )),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: nameTextEditingController,
              focusNode: nameFocusNode,
              style: Theme.of(context).textTheme.bodyText1,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              autofillHints: [AutofillHints.organizationName],
              maxLines: 1,
              cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                  filled: false,
                  hintText: 'Organization Name',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: customGreyColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: customGreyColor)),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.grey)),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Organization Name cannot be Empty';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFieldTags(
              textFieldStyler: TextFieldStyler(
                helperText: '',
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.grey),
                hintText: 'Organization Department',
                textFieldBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: customGreyColor)),
                textStyle: Theme.of(context).textTheme.bodyText1,
                textFieldEnabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: customGreyColor)),
                textFieldFocusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: customGreyColor)),
              ),
              //[tagsStyler] is required and shall not be null
              tagsStyler: TagsStyler(
                //These are properties you can tweek for customization of tags
                tagTextStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white),
                tagDecoration: BoxDecoration(
                  color: customRedColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                tagCancelIcon:
                    Icon(Icons.cancel, size: 18.0, color: Colors.white),
                tagPadding: const EdgeInsets.all(8.0),

                // EdgeInsets tagPadding = const EdgeInsets.all(4.0),
                // EdgeInsets tagMargin = const EdgeInsets.symmetric(horizontal: 4.0),
                // BoxDecoration tagDecoration = const BoxDecoration(color: Color.fromARGB(255, 74, 137, 92)),
                // TextStyle tagTextStyle,
                // Icon tagCancelIcon = const Icon(Icons.cancel, size: 18.0, color: Colors.green)
                // isHashTag: true,
              ),
              onTag: (tag) {
                //This give you tags entered
                print('onTag ' + tag);
                setState(() {
                  departments.add(tag);
                });
              },
              onDelete: (tag) {
                print('onDelete ' + tag);
                setState(() {
                  departments.remove(tag);
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  BotToast.showLoading(
                      allowClick: false,
                      clickClose: false,
                      backButtonBehavior: BackButtonBehavior.ignore);
                  bool isCreated =
                      await _organizationManager.createOrganization(
                          image: _imageFile,
                          name: nameTextEditingController.text,
                          department: departments);
                  BotToast.closeAllLoading();
                  if (isCreated) {
                    uiUtilities.alertNotification(
                        context: context,
                        message: _organizationManager.message);
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    });
                  } else {
                    uiUtilities.actionAlertWidget(
                        context: context, alertType: 'error');
                    uiUtilities.alertNotification(
                        context: context,
                        message: _organizationManager.message);
                  }
                } else {
                  uiUtilities.actionAlertWidget(
                      context: context, alertType: 'error');
                  uiUtilities.alertNotification(
                      context: context, message: 'Fields cannot be Empty!');
                }
              },
              child: Text(
                'Create Organization',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: customRedColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
