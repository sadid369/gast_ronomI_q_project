// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // If you use SVG icons

// class CustomTextFormField extends StatefulWidget {
//   final TextEditingController controller;
//   final String? labelText;
//   final String? hintText;
//   final IconData? suffixIcon;
//   final Widget? prefix;
//   final String? suffixIconSvgAsset;
//   final bool obscureText;
//   final VoidCallback? onSuffixIconTap;
//   final TextInputType keyboardType;
//   final int? maxLength;
//   final TextAlign textAlign;
//   final TextAlignVertical? textAlignVertical;
//   final FocusNode? focusNode;
//   final TextStyle? style;
//   final TextStyle? labelStyle;
//   final TextStyle? hintStyle;
//   final EdgeInsetsGeometry? contentPadding;
//   final Color fillColor;
//   final bool filled;
//   final BorderRadius? borderRadius;
//   final Color enabledBorderColor;
//   final Color focusedBorderColor;
//   final double enabledBorderWidth;
//   final double focusedBorderWidth;
//   final bool showCounter;
//   final ValueChanged<String>? onChanged;

//   const CustomTextFormField({
//     Key? key,
//     required this.controller,
//     this.onChanged,
//     this.prefix,
//     this.labelText,
//     this.hintText,
//     this.suffixIcon,
//     this.suffixIconSvgAsset,
//     this.obscureText = false,
//     this.onSuffixIconTap,
//     this.keyboardType = TextInputType.text,
//     this.maxLength,
//     this.textAlign = TextAlign.start,
//     this.textAlignVertical,
//     this.focusNode,
//     this.style,
//     this.labelStyle,
//     this.hintStyle,
//     this.contentPadding,
//     this.fillColor = Colors.white,
//     this.filled = true,
//     this.borderRadius,
//     this.enabledBorderColor = Colors.grey,
//     this.focusedBorderColor = Colors.blue,
//     this.enabledBorderWidth = 1.5,
//     this.focusedBorderWidth = 1.8,
//     this.showCounter = true,
//   }) : super(key: key);

//   @override
//   State<CustomTextFormField> createState() => _CustomTextFormFieldState();
// }

// class _CustomTextFormFieldState extends State<CustomTextFormField> {
//   late bool _obscureText;

//   @override
//   void initState() {
//     super.initState();
//     _obscureText = widget.obscureText;
//   }

//   void _toggleObscureText() {
//     // If there's a custom tap handler, call it
//     if (widget.onSuffixIconTap != null) {
//       widget.onSuffixIconTap!();
//     }
//     // Otherwise, toggle the obscure text state if this field is for passwords
//     else if (widget.obscureText) {
//       setState(() {
//         _obscureText = !_obscureText;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final borderRadius = widget.borderRadius ?? BorderRadius.circular(12);

//     Widget? suffixIconWidget;
//     if (widget.suffixIconSvgAsset != null) {
//       suffixIconWidget = GestureDetector(
//         onTap: _toggleObscureText,
//         child: Container(
//           width: 20,
//           height: 20,
//           padding: const EdgeInsets.all(4),
//           child: SvgPicture.asset(
//             widget.suffixIconSvgAsset!,
//             color: Colors.black.withOpacity(0.5),
//             fit: BoxFit.contain,
//             width: 16,
//             height: 16,
//           ),
//         ),
//       );
//     } else if (widget.suffixIcon != null) {
//       suffixIconWidget = GestureDetector(
//         onTap: _toggleObscureText,
//         child: Icon(
//           // Change the icon based on obscure state if this is a password field
//           widget.obscureText
//               ? (_obscureText ? Icons.visibility_off : Icons.visibility)
//               : widget.suffixIcon,
//           color: Colors.black.withOpacity(0.5),
//           size: 17,
//         ),
//       );
//     }

//     return TextFormField(
//       onChanged: widget.onChanged,
//       controller: widget.controller,
//       obscureText: _obscureText,
//       keyboardType: widget.keyboardType,
//       maxLength: widget.maxLength,
//       textAlign: widget.textAlign,
//       textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.center,
//       focusNode: widget.focusNode,
//       style: widget.style,
//       decoration: InputDecoration(
//         labelText: widget.labelText,
//         floatingLabelBehavior: widget.labelText != null
//             ? FloatingLabelBehavior.always
//             : FloatingLabelBehavior.never,
//         labelStyle: widget.labelStyle,
//         hintText: widget.hintText,
//         hintStyle: widget.hintStyle,
//         suffixIcon: suffixIconWidget,
//         prefixIconConstraints: widget.prefix != null
//             ? const BoxConstraints(minWidth: 40, minHeight: 40)
//             : null,
//         prefixIcon: widget.prefix != null
//             ? Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: widget.prefix,
//               )
//             : null,
//         filled: widget.filled,
//         fillColor: widget.fillColor,
//         contentPadding: widget.contentPadding ??
//             const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
//         counterText: widget.showCounter ? null : '',
//         border: OutlineInputBorder(
//           borderRadius: borderRadius,
//           borderSide: BorderSide(
//             color: widget.enabledBorderColor,
//             width: widget.enabledBorderWidth,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: borderRadius,
//           borderSide: BorderSide(
//             color: widget.enabledBorderColor,
//             width: widget.enabledBorderWidth,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: borderRadius,
//           borderSide: BorderSide(
//             color: widget.focusedBorderColor,
//             width: widget.focusedBorderWidth,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // If you use SVG icons

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final IconData? suffixIcon;
  final Widget? prefix;
  final String? suffixIconSvgAsset;
  final bool obscureText;
  final VoidCallback? onSuffixIconTap;
  final TextInputType keyboardType;
  final int? maxLength;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final FocusNode? focusNode;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color fillColor;
  final bool filled;
  final BorderRadius? borderRadius;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final double enabledBorderWidth;
  final double focusedBorderWidth;
  final bool showCounter;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.prefix,
    this.labelText,
    this.hintText,
    this.suffixIcon,
    this.suffixIconSvgAsset,
    this.obscureText = false,
    this.onSuffixIconTap,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.focusNode,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.contentPadding,
    this.fillColor = Colors.white,
    this.filled = true,
    this.borderRadius,
    this.enabledBorderColor = Colors.grey,
    this.focusedBorderColor = Colors.blue,
    this.enabledBorderWidth = 1.5,
    this.focusedBorderWidth = 1.8,
    this.showCounter = true,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  void _toggleObscureText() {
    if (widget.onSuffixIconTap != null) {
      widget.onSuffixIconTap!();
    }
    // Removed internal toggle, now fully controlled outside
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(12);

    Widget? suffixIconWidget;
    if (widget.suffixIconSvgAsset != null) {
      suffixIconWidget = GestureDetector(
        onTap: _toggleObscureText,
        child: Container(
          width: 20,
          height: 20,
          padding: const EdgeInsets.all(4),
          child: SvgPicture.asset(
            widget.suffixIconSvgAsset!,
            color: Colors.black.withOpacity(0.5),
            fit: BoxFit.contain,
            width: 16,
            height: 16,
          ),
        ),
      );
    } else if (widget.suffixIcon != null) {
      suffixIconWidget = GestureDetector(
        onTap: _toggleObscureText,
        child: Icon(
          widget.obscureText
              ? (widget.obscureText
                  ? Icons.visibility_off
                  : Icons.visibility) // always use widget.obscureText here
              : widget.suffixIcon,
          color: Colors.black.withOpacity(0.5),
          size: 17,
        ),
      );
    }

    return TextFormField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.center,
      focusNode: widget.focusNode,
      style: widget.style,
      decoration: InputDecoration(
        labelText: widget.labelText,
        floatingLabelBehavior: widget.labelText != null
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.never,
        labelStyle: widget.labelStyle,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        suffixIcon: suffixIconWidget,
        prefixIconConstraints: widget.prefix != null
            ? const BoxConstraints(minWidth: 40, minHeight: 40)
            : null,
        prefixIcon: widget.prefix != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: widget.prefix,
              )
            : null,
        filled: widget.filled,
        fillColor: widget.fillColor,
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        counterText: widget.showCounter ? null : '',
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: widget.enabledBorderColor,
            width: widget.enabledBorderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: widget.enabledBorderColor,
            width: widget.enabledBorderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: widget.focusedBorderColor,
            width: widget.focusedBorderWidth,
          ),
        ),
      ),
    );
  }
}
