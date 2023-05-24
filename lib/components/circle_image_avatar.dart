import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CircleImageAvatar extends StatefulWidget {
  final double size;
  final Color color;
  final String placeholder;
  final String imagePath;

  final Widget? foreground;

  final Function? onTap;

  const CircleImageAvatar({
    Key? key,
    this.imagePath = '',
    this.size = 20,
    this.color = Colors.grey,
    this.placeholder = ' ',
    this.onTap,
    this.foreground,
  }) : super(key: key);

  @override
  CircleImageAvatarState createState() => CircleImageAvatarState();
}

class CircleImageAvatarState extends State<CircleImageAvatar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap == null ? null : () => widget.onTap!.call(),
      child: widget.imagePath.isEmpty || !widget.imagePath.toString().startsWith('/')
          ? CircleAvatar(
              maxRadius: widget.size,
              backgroundImage: AssetImage('assets/placeholder.png'),
            )
          : CircleAvatar(
              maxRadius: widget.size,
              backgroundColor: widget.color,
              backgroundImage: AssetImage('assets/placeholder.png'),
              onBackgroundImageError: (exception, context) {
                if (kDebugMode) {
                  print("Couldn't Load Profile Image of [${widget.placeholder}] "
                      "-> ${widget.imagePath}" ////"-> ${'http://${ConnectionManager.serverHost.replaceFirst('localhost', '10.0.2.2')}' + widget.imagePath}"
                      "\nException: $exception");
                }
              },
            ),
    );
  }
}
