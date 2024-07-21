import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky_mobile_app/managers/user_manager.dart';
import 'package:tasky_mobile_app/shared_widgets/custom_bottom_sheet_widget.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';
import 'package:tasky_mobile_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_mobile_app/utils/ui_utils/ui_utils.dart';

class PersonalAccountView extends StatefulWidget {
  const PersonalAccountView({super.key});

  @override
  State<PersonalAccountView> createState() => _PersonalAccountViewState();
}

class _PersonalAccountViewState extends State<PersonalAccountView> {
  final UiUtilities uiUtilities = UiUtilities();
  final UserManager _userManager = GetIt.I.get<UserManager>();
  final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();
  static final GlobalKey<FormState> _myFormKey = GlobalKey<FormState>();
  File? _imageFile;
  List<Options>? options;
  TextEditingController nameTextEditingController = TextEditingController();
  final nameFocusNode = FocusNode();
  TextEditingController emailTextEditingController = TextEditingController();
  final emailFocusNode = FocusNode();
  TextEditingController phoneTextEditingController = TextEditingController();
  final phoneFocusNode = FocusNode();
  String? profileUrl;

  getProfileFromCamera() async {
    await uiUtilities
        .getImage(imageSource: ImageSource.camera)
        .then((file) async {
      File? croppedFile = await uiUtilities.getCroppedFile(file: file!.path);

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
      File? croppedFile = await uiUtilities.getCroppedFile(file: file!.path);

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

    _localStorage.getUserInfo().then((userData) {
      nameTextEditingController.text = userData.name!;
      emailTextEditingController.text = userData.email!;
      phoneTextEditingController.text = userData.phoneNumber ?? '';
      profileUrl = userData.picture!;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Profile',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _myFormKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]
                      .withOpacity(.2),
                  radius: 60,
                  backgroundImage: (profileUrl == null
                      ? (_imageFile == null
                          ? const ExactAssetImage('assets/avatar.png')
                          : FileImage(_imageFile!))
                      : NetworkImage(profileUrl!)) as ImageProvider<Object>?,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Center(
                  child: TextButton(
                child: Text(
                  'update profile photo',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
                style: Theme.of(context).textTheme.bodyLarge,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                maxLines: 1,
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                enableInteractiveSelection: true,
                decoration: InputDecoration(
                    filled: false,
                    hintText: 'Your Full name',
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: customGreyColor)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: customGreyColor)),
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Organization Name cannot be Empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailTextEditingController,
                focusNode: emailFocusNode,
                style: Theme.of(context).textTheme.bodyLarge,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                maxLines: 1,
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                enableInteractiveSelection: true,
                decoration: InputDecoration(
                    filled: false,
                    hintText: 'Your Email address',
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: customGreyColor)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: customGreyColor)),
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Organization Name cannot be Empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: phoneTextEditingController,
                focusNode: phoneFocusNode,
                style: Theme.of(context).textTheme.bodyLarge,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                textCapitalization: TextCapitalization.none,
                maxLines: 1,
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                enableInteractiveSelection: true,
                decoration: InputDecoration(
                    filled: false,
                    hintText: 'Your Phone number',
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: customGreyColor)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: customGreyColor)),
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Organization Name cannot be Empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              TextButton(
                onPressed: () async {
                  if (_myFormKey.currentState!.validate()) {
                    BotToast.showLoading(
                        allowClick: false,
                        clickClose: false,
                        backButtonBehavior: BackButtonBehavior.ignore);
                    bool isUpdated = await _userManager.updateProfile(
                        image: _imageFile,
                        name: nameTextEditingController.text,
                        phone: phoneTextEditingController.text);
                    BotToast.closeAllLoading();
                    if (!context.mounted) return;
                    uiUtilities.alertNotification(
                        context: context, message: _userManager.message!);
                    if (isUpdated) {
                      uiUtilities.actionAlertWidget(
                          context: context, alertType: AlertType.success);
                    } else {
                      uiUtilities.actionAlertWidget(
                          context: context, alertType: AlertType.error);
                    }
                  } else {
                    uiUtilities.actionAlertWidget(
                        context: context, alertType: AlertType.error);
                    uiUtilities.alertNotification(
                        context: context, message: 'Fields cannot be Empty!');
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: customRedColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: Text(
                  'Update Profile',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
