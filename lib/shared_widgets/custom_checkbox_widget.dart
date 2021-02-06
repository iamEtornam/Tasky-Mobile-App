import 'package:flutter/material.dart';

///Widget that draw a beautiful checkbox rounded. Provided with animation if wanted
class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    Key key,
    this.isChecked,
    this.checkedWidget,
    this.uncheckedWidget,
    this.checkedColor,
    this.uncheckedColor,
    this.size,
    this.animationDuration,
    @required this.onTap,
  })  : assert(onTap != null),
        super(key: key);

  ///Define wether the checkbox is marked or not
  final bool isChecked;

  ///Define the widget that is shown when Widgets is checked
  final Widget checkedWidget;

  ///Define the widget that is shown when Widgets is unchecked
  final Widget uncheckedWidget;

  ///Define the color that is shown when Widgets is checked
  final Color checkedColor;

  ///Define the color that is shown when Widgets is unchecked
  final Color uncheckedColor;

  ///Define the size of the checkbox
  final double size;

  ///Define Function that os executed when user tap on checkbox
  final Function(bool) onTap;

  ///Define the duration of the animation. If any
  final Duration animationDuration;

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isChecked;
  Duration animationDuration;
  double size;
  Widget checkedWidget;
  Widget uncheckedWidget;
  Color checkedColor;
  Color uncheckedColor;

  @override
  void initState() {
    isChecked = widget.isChecked ?? false;
    animationDuration = widget.animationDuration ?? Duration(milliseconds: 500);
    size = widget.size ?? 24.0;
    checkedColor = widget.checkedColor ?? Colors.green;
    checkedWidget =
        widget.checkedWidget ?? Icon(Icons.check, color: Colors.white);
    uncheckedWidget = widget.uncheckedWidget ?? const SizedBox.shrink();
    uncheckedColor = isChecked ? widget.uncheckedColor : Colors.grey;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomCheckBox oldWidget) {
    uncheckedColor =
        widget.uncheckedColor ?? Theme.of(context).accentColor;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isChecked = !isChecked);
        widget?.onTap(isChecked);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: AnimatedContainer(
          duration: animationDuration,
          height: size,
          width: size,
          decoration: BoxDecoration(
            border: Border.all(
              color: isChecked ? checkedColor : uncheckedColor,
            ),
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: isChecked ? checkedWidget : uncheckedWidget,
        ),
      ),
    );
  }
}
