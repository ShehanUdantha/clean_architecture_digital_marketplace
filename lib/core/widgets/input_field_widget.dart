import 'package:flutter/material.dart';

import '../constants/colors.dart';

class InputFieldWidget extends StatefulWidget {
  final String hint;
  final Icon? prefix;
  final Icon? suffix;
  final Icon? suffixSecondary;
  final bool isTextArea;
  final TextInputType? keyBoardType;
  final TextEditingController? controller;

  const InputFieldWidget({
    super.key,
    required this.hint,
    this.prefix,
    this.suffix,
    this.suffixSecondary,
    this.isTextArea = false,
    this.keyBoardType = TextInputType.text,
    this.controller,
  });

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  bool isSuffixClicked = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.suffix != null ? isSuffixClicked : false,
      maxLines: widget.isTextArea ? 3 : 1,
      keyboardType: widget.keyBoardType,
      decoration: InputDecoration(
        prefixIcon: widget.prefix,
        prefixIconColor: AppColors.textThird,
        suffixIcon: widget.suffix != null
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isSuffixClicked = !isSuffixClicked;
                  });
                },
                icon: isSuffixClicked
                    ? widget.suffixSecondary != null
                        ? widget.suffixSecondary!
                        : widget.suffix!
                    : widget.suffix!,
              )
            : const SizedBox(),
        suffixIconColor: AppColors.textThird,
        hintText: widget.hint,
        hintStyle: const TextStyle(
          color: AppColors.textThird,
          fontWeight: FontWeight.normal,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
      ),
    );
  }
}
