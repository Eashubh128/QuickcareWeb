import 'package:flutter/material.dart';

class UiUtilsHelper {
  static OverlayEntry? _overlayEntry;

  static void showProgress(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void dismissProgress() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
