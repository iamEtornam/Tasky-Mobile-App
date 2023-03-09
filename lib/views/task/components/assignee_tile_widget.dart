import 'package:flutter/material.dart';
import 'package:tasky_mobile_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_mobile_app/models/user.dart';


class AssigneeTileWidget extends StatelessWidget {
  const AssigneeTileWidget(
      {Key? key, required this.onTap, required this.selectedUser, required this.isChecked})
      : super(key: key);
  final bool isChecked;
  final Data selectedUser;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(selectedUser.picture!),
      ),
      title: Text(
        selectedUser.name!,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: GestureDetector(
        onTap: () {
          onTap(selectedUser);
        },
        child: Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
              side: BorderSide(color: isChecked ? Colors.transparent : customGreyColor)),
          child: CircleAvatar(
            radius: 12,
            backgroundColor: isChecked ? Colors.green : Colors.transparent,
            child: Icon(
              Icons.check,
              color: isChecked ? Colors.white : customGreyColor,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
