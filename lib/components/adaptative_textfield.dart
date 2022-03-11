import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApadtativeTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onSubmited;
  final String? label;

  ApadtativeTextField(
      {this.controller,
      this.keyboardType = TextInputType.text,
      this.onSubmited,
      this.label});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: CupertinoTextField(
              controller: controller,
              keyboardType: keyboardType,
              onSubmitted: (_) => onSubmited,
              placeholder: label,
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
            ),
          )
        : TextField(
            controller: controller,
            keyboardType: keyboardType,
            onSubmitted: (_) => onSubmited,
            decoration: InputDecoration(
              labelText: label,
            ),
          );
  }
}
