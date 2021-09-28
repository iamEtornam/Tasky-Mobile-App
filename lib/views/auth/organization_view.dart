import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:tasky_mobile_app/managers/organization_manager.dart';
import 'package:tasky_mobile_app/shared_widgets/custom_bottom_sheet_widget.dart';
import 'package:tasky_mobile_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_mobile_app/utils/ui_utils/ui_utils.dart';
import 'package:textfield_tags/textfield_tags.dart';

final OrganizationManager _organizationManager =
    GetIt.I.get<OrganizationManager>();

class OrganizationView extends StatefulWidget {
  const OrganizationView({Key key}) : super(key: key);

  @override
  _OrganizationViewState createState() => _OrganizationViewState();
}

class _OrganizationViewState extends State<OrganizationView> {
  final Logger _logger = Logger();
  final UiUtilities uiUtilities = UiUtilities();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameTextEditingController = TextEditingController();
  List<String> teams = [];
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
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: Colors
                    .primaries[Random().nextInt(Colors.primaries.length)]
                    .withOpacity(.2),
                radius: 60,
                backgroundImage: _imageFile == null
                    ? const ExactAssetImage('assets/avatar.png')
                    : FileImage(_imageFile),
              ),
            ),
            const SizedBox(
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
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: nameTextEditingController,
              focusNode: nameFocusNode,
              style: Theme.of(context).textTheme.bodyText1,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.organizationName],
              maxLines: 1,
              cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                  filled: false,
                  hintText: 'Organization Name',
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: customGreyColor)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: customGreyColor)),
                  border: const UnderlineInputBorder(
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
            const SizedBox(
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
                hintText: 'Organization Teams',
                textFieldBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: customGreyColor)),
                textStyle: Theme.of(context).textTheme.bodyText1,
                textFieldEnabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: customGreyColor)),
                textFieldFocusedBorder: const UnderlineInputBorder(
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
                    const Icon(Icons.cancel, size: 18.0, color: Colors.white),
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
                _logger.d('onTag ' + tag);
                setState(() {
                  teams.add(tag);
                });
              },
              onDelete: (tag) {
                _logger.d('onDelete ' + tag);
                setState(() {
                  teams.remove(tag);
                });
              },
            ),
            const SizedBox(
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
                          teams: teams);
                  BotToast.closeAllLoading();
                  if (isCreated) {
                    uiUtilities.alertNotification(
                        context: context,
                        message: _organizationManager.message);
                    Future.delayed(const Duration(seconds: 3), () {
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
