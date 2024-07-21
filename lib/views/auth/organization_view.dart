import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky_mobile_app/managers/organization_manager.dart';
import 'package:tasky_mobile_app/shared_widgets/custom_bottom_sheet_widget.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';
import 'package:tasky_mobile_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_mobile_app/utils/ui_utils/ui_utils.dart';
import 'package:textfield_tags/textfield_tags.dart';

class OrganizationView extends StatefulWidget {
  const OrganizationView({super.key});

  @override
  State<OrganizationView> createState() => _OrganizationViewState();
}

class _OrganizationViewState extends State<OrganizationView> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();
  final OrganizationManager _organizationManager =
      GetIt.I.get<OrganizationManager>();
  final UiUtilities uiUtilities = UiUtilities();
  static final GlobalKey<FormState> _myFormKey = GlobalKey<FormState>();
  TextEditingController nameTextEditingController = TextEditingController();
  final _tagsController = TextfieldTagsController();

  final nameFocusNode = FocusNode();
  File? _imageFile;
  List<Options>? options;

  getProfileFromCamera() async {
    await uiUtilities
        .getImage(imageSource: ImageSource.camera)
        .then((file) async {
      if (file == null) {
        return;
      }
      final croppedFile = await uiUtilities.getCroppedFile(file: file.path);

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
      if (file == null) {
        return;
      }
      final croppedFile = await uiUtilities.getCroppedFile(file: file.path);

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
  void dispose() {
    _myFormKey.currentState?.dispose();
    nameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () async {
                BotToast.showLoading(
                    allowClick: false,
                    clickClose: false,
                    backButtonBehavior: BackButtonBehavior.ignore);
                firebaseAuth.signOut().then((_) async {
                  await _localStorage.clearStorage();
                  BotToast.closeAllLoading();
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/loginView', (route) => false);
                });
              },
              child: Text(
                'Logout',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.red),
              ))
        ],
      ),
      body: SafeArea(
          child: Form(
        key: _myFormKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(.2),
                radius: 60,
                backgroundImage: (_imageFile == null
                    ? const ExactAssetImage(
                        'assets/company.png',
                      )
                    : FileImage(_imageFile!)) as ImageProvider<Object>?,
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Center(
                child: TextButton(
              child: Text(
                'update company logo',
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
              autofillHints: const [AutofillHints.organizationName],
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
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
            TextFieldTags(
              textfieldTagsController: _tagsController,
              inputfieldBuilder:
                  (context, tec, fn, error, onChanged, onSubmitted) {
                return ((context, sc, tags, onTagDelete) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: tec,
                      focusNode: fn,
                      decoration: InputDecoration(
                        isDense: true,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: customGreyColor)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: customGreyColor)),
                        hintText:
                            _tagsController.hasTags ? '' : "Organization Teams",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.grey),
                        errorText: error,
                        prefixIcon: tags.isNotEmpty
                            ? SingleChildScrollView(
                                controller: sc,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: tags.map((String tag) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: customRedColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    margin: const EdgeInsets.only(right: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tag,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: Colors.white),
                                        ),
                                        const SizedBox(width: 4.0),
                                        InkWell(
                                          child: const Icon(
                                            Icons.cancel,
                                            size: 14.0,
                                            color: Colors.white,
                                          ),
                                          onTap: () {
                                            onTagDelete(tag);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }).toList()),
                              )
                            : null,
                      ),
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                    ),
                  );
                });
              },
              textSeparators: const [' ', ','],
              letterCase: LetterCase.small,
              validator: (String tag) {
                final tags = _tagsController.getTags ?? [];
                if (tags.contains(tag)) {
                  return 'you already entered that';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () async {
                if (_myFormKey.currentState!.validate()) {
                  BotToast.showLoading(
                      allowClick: false,
                      clickClose: false,
                      backButtonBehavior: BackButtonBehavior.ignore);
                  bool isCreated =
                      await _organizationManager.createOrganization(
                          image: _imageFile!,
                          name: nameTextEditingController.text,
                          teams: _tagsController.getTags);
                  BotToast.closeAllLoading();
                  if (!context.mounted) return;

                  if (isCreated) {
                    uiUtilities.alertNotification(
                        context: context,
                        message: _organizationManager.message!);
                    Future.delayed(const Duration(seconds: 3), () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    });
                  } else {
                    uiUtilities.actionAlertWidget(
                        context: context, alertType: AlertType.error);
                    uiUtilities.alertNotification(
                        context: context,
                        message: _organizationManager.message!);
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
                'Create Organization',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      )),
    );
  }
}
