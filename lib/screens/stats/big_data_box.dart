import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BigDataBox extends StatelessWidget {
  final String label;
  final String value;
  final Color bgColor;
  final Color strokeColor;
  Color textColor;

  BigDataBox(
      {@required this.label,
      @required this.value,
      @required this.bgColor,
      @required this.strokeColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: this.bgColor,
          border: Border.all(
            color: this.strokeColor,
            width: 2,
          ),
        ),
        padding: EdgeInsets.all(8),
        alignment: Alignment(0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(this.label,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(fontWeight: FontWeight.w600, color: textColor)),
            SizedBox(height: 8),
            Text(this.value,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: FontWeight.w800, color: textColor)),
          ],
        ),
      ),
    );
  }
}
