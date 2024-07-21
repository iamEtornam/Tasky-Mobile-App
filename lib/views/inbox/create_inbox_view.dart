import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_mobile_app/managers/inbox_manager.dart';
import 'package:tasky_mobile_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_mobile_app/utils/ui_utils/ui_utils.dart';

class CreateInboxView extends StatefulWidget {
  const CreateInboxView({super.key});

  @override
  State<CreateInboxView> createState() => _CreateInboxViewState();
}

class _CreateInboxViewState extends State<CreateInboxView> {
  final UiUtilities uiUtilities = UiUtilities();
  final InboxManager _inboxManager = GetIt.I.get<InboxManager>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleTextEditController = TextEditingController();
  final messageTextEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customRedColor,
        leadingWidth: 80,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Text(
              'Cancel',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
        title: Text(
          'New Message',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'What is the title?',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: titleTextEditController,
              style: Theme.of(context).textTheme.bodyLarge,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              maxLines: 1,
              cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                  filled: false,
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
                  return 'Field cannot be Empty';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'What is the message?',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: messageTextEditController,
              style: Theme.of(context).textTheme.bodyLarge,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 5,
              cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                  filled: false,
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
                  return 'Field cannot be Empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.black),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  BotToast.showLoading(
                      allowClick: false,
                      clickClose: false,
                      backButtonBehavior: BackButtonBehavior.ignore);

                  bool isSaved = await _inboxManager.submitInbox(
                    title: titleTextEditController.text,
                    message: messageTextEditController.text,
                  );
                  BotToast.closeAllLoading();
                  if (!context.mounted) return;

                  if (isSaved) {
                    uiUtilities.actionAlertWidget(
                        context: context, alertType: AlertType.success);
                    uiUtilities.alertNotification(
                        context: context, message: _inboxManager.message!);

                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.of(context).pop(true);
                    });
                  } else {
                    uiUtilities.actionAlertWidget(
                        context: context, alertType: AlertType.error);
                    uiUtilities.alertNotification(
                        context: context, message: _inboxManager.message!);
                  }
                } else {
                  uiUtilities.actionAlertWidget(
                      context: context, alertType: AlertType.error);
                  uiUtilities.alertNotification(
                      context: context, message: 'Fields cannot be empty');
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Sent message',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
