import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SmallDataBox extends StatelessWidget {
  final String label;
  final String value;
  final Color bgColor;

  SmallDataBox({
    @required this.label,
    @required this.value,
    @required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: this.bgColor,
      ),
      padding: const EdgeInsets.all(8),
      alignment: Alignment(0, 0),
      child: Column(
        children: [
          Text(this.label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Text(this.value,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
