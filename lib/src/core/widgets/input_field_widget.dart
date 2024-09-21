import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/blocs/theme/theme_bloc.dart';
import '../constants/colors.dart';

class InputFieldWidget extends StatefulWidget {
  final String hint;
  final Icon? prefix;
  final Icon? suffix;
  final Icon? suffixSecondary;
  final bool isTextArea;
  final int areaSize;
  final TextInputType? keyBoardType;
  final TextEditingController? controller;
  final bool? isReadOnly;

  const InputFieldWidget({
    super.key,
    required this.hint,
    this.prefix,
    this.suffix,
    this.suffixSecondary,
    this.isTextArea = false,
    this.areaSize = 3,
    this.keyBoardType = TextInputType.text,
    this.controller,
    this.isReadOnly,
  });

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  bool isSuffixClicked = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().isDarkMode(context);

    return TextField(
      controller: widget.controller,
      obscureText: widget.suffix != null ? isSuffixClicked : false,
      maxLines: widget.isTextArea ? widget.areaSize : 1,
      keyboardType: widget.keyBoardType,
      readOnly: widget.isReadOnly ?? false,
      style: TextStyle(
        color: isDarkMode ? AppColors.textFifth : AppColors.textPrimary,
        fontWeight: FontWeight.normal,
      ),
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
