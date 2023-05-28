import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:personel_app/managers/connection_manager.dart';

class CircleImageAvatar extends StatefulWidget {
  final double size;
  final Color color;
  final Widget? placeholder;
  final String imagePath;

  final Widget? foreground;

  final Function? onTap;

  const CircleImageAvatar({
    Key? key,
    this.imagePath = '',
    this.size = 20,
    this.color = Colors.grey,
    this.placeholder,
    this.onTap,
    this.foreground,
  }) : super(key: key);

  @override
  CircleImageAvatarState createState() => CircleImageAvatarState();
}

class CircleImageAvatarState extends State<CircleImageAvatar> {
  final _connectionManager = ConnectionManager();
  final String host = ConnectionManager().host;

  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap == null ? null : () => widget.onTap!.call(),
      child: widget.imagePath.isEmpty || !widget.imagePath.toString().startsWith('/')
          ? _buildPlaceHolder()
          : _error
              ? _buildPlaceHolder()
              : _buildNetworkImage(),
    );
  }

  Widget _buildNetworkImage() {
    try {
      return Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            maxRadius: widget.size,
            backgroundImage: NetworkImage(
              '${host}${widget.imagePath}',
              headers: {'Host': _connectionManager.headerHost},
            ),
            onBackgroundImageError: (exception, context) {
              developer.log("Couldn't Load Profile Image -> ${host}/${widget.imagePath}\nException: $exception");
              setState(() {
                _error = true;
              });
            },
          ),
          if (widget.foreground != null) widget.foreground!,
        ],
      );
    } catch (ex) {
      developer.log('ERROR -> Image not loaded [$ex]');
      return _buildPlaceHolder();
    }
  }

  Widget _buildPlaceHolder() => Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            maxRadius: widget.size,
            backgroundImage: widget.placeholder != null ? null : AssetImage('assets/placeholder.png'),
            child: widget.placeholder,
          ),
          if (widget.foreground != null) widget.foreground!,
        ],
      );
}
