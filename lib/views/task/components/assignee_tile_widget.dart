import 'package:flutter/material.dart';
import 'package:tasky_mobile_app/models/user.dart';
import 'package:tasky_mobile_app/utils/ui_utils/custom_colors.dart';

class AssigneeTileWidget extends StatelessWidget {
  const AssigneeTileWidget(
      {super.key, required this.onTap, required this.selectedUser, required this.isChecked});
  final bool isChecked;
  final Data selectedUser;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: (selectedUser.picture == null
            ? const ExactAssetImage('assets/avatar.png')
            : NetworkImage(selectedUser.picture!) as ImageProvider),
      ),
      title: Text(
        selectedUser.name ?? 'Not provided',
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
