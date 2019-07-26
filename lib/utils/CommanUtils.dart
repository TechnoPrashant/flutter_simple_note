import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CommanUtils {
  BuildContext mContext;

  CommanUtils(BuildContext mContext) {
    this.mContext = mContext;
  }

  showToast(String message) {
    Toast.show(message, mContext,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}
