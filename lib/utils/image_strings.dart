import 'package:flutter/material.dart';

class ImageStrings {
  //  --  Profile Images
  static const String profileImage = "assets/profile_pic.jpg";
  static const String pfp = "assets/pfp.jpg";
  static const String networPfp = "data:image/jpeg;base64,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";
}
