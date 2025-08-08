import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  final int? maxLine;
  final String? hintText;
  final bool? isReadOnly;
  final bool? isSecurity;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? title;
  final bool? isRequired;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;

  const TextInputWidget(
      {super.key,
      this.onSubmitted,
      this.maxLine,
      this.hintText,
      this.isReadOnly,
      this.isSecurity,
      this.suffixIcon,
      this.controller,
      this.title,
      this.isRequired,
      this.keyboardType,
      this.validator,
      this.onTap,
      this.prefixIcon,
      this.onChanged,
      this.autovalidateMode,
      this.focusNode});

  @override
  TextInputWidgetState createState() => TextInputWidgetState();
}

class TextInputWidgetState extends State<TextInputWidget> {
  var isShowPassword = false;
  void handleShowPass() {
    setState(() {
      isShowPassword = !isShowPassword;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: widget.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
              WidgetSpan(
                child: Visibility(
                  visible: widget.isRequired ?? false,
                  child: const Text(
                    ' *',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          TextFormField(
            focusNode: widget.focusNode,
            onChanged: widget.onChanged,
            // enabled: true,
            onFieldSubmitted: widget.onSubmitted,
            style: TextStyle(color: Colors.black),
            obscureText: widget.isSecurity != null ? !isShowPassword : false,
            keyboardType: widget.keyboardType,
            autovalidateMode:
                widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
            maxLines: widget.maxLine ?? 1,
            readOnly: widget.isReadOnly ?? false,
            controller: widget.controller,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 14),
              prefixIcon: widget.prefixIcon,
              hintText: widget.hintText,
              suffixIcon: Visibility(
                visible: widget.isSecurity == true,
                replacement: widget.suffixIcon ?? const Text(''),
                child: IconButton(
                    onPressed: () => handleShowPass(),
                    icon: isShowPassword
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            size: 20,
                            color: Colors.grey,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            size: 20,
                            color: Colors.grey,
                          )),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade200)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade200)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 12.0),
              labelStyle:
                  const TextStyle(fontSize: 14.0, color: Color(0xFF2C2C2C)),
            ),
            validator: widget.validator,
            onTap: widget.onTap,
          ),
        ],
      ),
    );
  }
}
