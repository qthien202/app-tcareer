import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Widget searchBarWidget(
    {void Function(String)? onChanged,
    required TextEditingController controller,
    void Function(String)? onSubmitted,
    void Function()? onTap,
    bool autofocus = true,
    bool readOnly = false}) {
  return SizedBox(
    height: 40,
    child: TextField(
      readOnly: readOnly,
      onTap: onTap,
      textInputAction: TextInputAction.search,
      autofocus: autofocus,
      controller: controller,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          hintText: "Tìm kiếm",
          prefixIcon: const PhosphorIcon(PhosphorIconsRegular.magnifyingGlass),
          fillColor: Colors.grey.shade100,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none)),
    ),
  );
}
