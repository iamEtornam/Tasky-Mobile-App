import 'package:flutter/material.dart';
import 'package:tasky_mobile_app/utils/ui_utils/custom_colors.dart';

class CreateInboxView extends StatelessWidget {
  const CreateInboxView({Key? key}) : super(key: key);

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
                  .bodyText1!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
        title: Text(
          'New Message',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'What is the title?',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            style: Theme.of(context).textTheme.bodyText1,
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
                    .bodyText1!
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
        ],
      ),
    );
  }
}
