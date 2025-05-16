import 'package:flutter/material.dart';

class CustomStyle {
  // Colors
  static const Color primaryColor = Colors.teal;
  static final Color primaryColorDark = Colors.teal.shade700;
  static const Color accentColor = Colors.amber;
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static final Color textColorPrimary = Colors.grey.shade900;
  static final Color textColorSecondary = Colors.grey.shade600;
  static final Color borderColor = Colors.grey.shade300;

  // Text Styles
  static const TextStyle headline1 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static final TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textColorPrimary,
  );

  static final TextStyle hintText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textColorSecondary,
    fontStyle: FontStyle.italic,
  );

  // Input decoration for TextFormField (used for forms & search)
  static InputDecoration inputDecoration({
    String? hintText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: hintText != null ? hintTextStyle : null,
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColorDark, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade200,
    );
  }

  // Dropdown decoration (usually use DropdownButtonFormField decoration)
  static InputDecoration dropdownDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: hintTextStyle,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColorDark, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  static TextStyle get hintTextStyle => hintText;

  // Elevated Button Style
  static final baseButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontSize: 14),
    elevation: 4,
    shadowColor: primaryColor.withOpacity(0.4),
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return accentColor.withOpacity(0.3);
      }
      if (states.contains(WidgetState.hovered)) {
        return accentColor.withOpacity(0.1);
      }
      return null;
    }),
  );

  static ButtonStyle getButtonStyleByLabel(String label) {
    Color bgColor;

    final lowerLabel = label.toLowerCase();

    if (lowerLabel.contains('hapus')) {
      bgColor = Colors.red;
    } else if (lowerLabel.contains('edit')) {
      bgColor = Colors.orange;
    } else if (lowerLabel.contains('upload')) {
      bgColor = primaryColor; // default teal
    } else if (lowerLabel.contains('pilih file')) {
      bgColor = Colors.orange; // untuk tombol file picker
    } else {
      bgColor = primaryColor;
    }

    return baseButtonStyle.copyWith(
      backgroundColor: WidgetStateProperty.all(bgColor),
    );
  }

  // // Style generator based on label
  // static ButtonStyle getButtonStyleByLabel(String label) {
  //   Color bgColor;

  //   switch (label.toLowerCase()) {
  //     case 'hapus':
  //       bgColor = Colors.red;
  //       break;
  //     case 'edit':
  //       bgColor = Colors.orange;
  //       break;
  //     case 'detail':
  //     case 'upload':
  //     case 'send':
  //     default:
  //       bgColor = primaryColor;
  //       break;
  //   }

  //   return baseButtonStyle.copyWith(
  //     backgroundColor: WidgetStateProperty.all(bgColor),
  //   );
  // }
  // static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  //   backgroundColor: primaryColor,
  //   foregroundColor: Colors.white,
  //   padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //   textStyle: const TextStyle(fontSize: 14),
  //   elevation: 4,
  //   shadowColor: primaryColor.withOpacity(0.4),
  // ).copyWith(
  //   overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
  //     if (states.contains(WidgetState.pressed))
  //       return accentColor.withOpacity(0.3);
  //     if (states.contains(WidgetState.hovered))
  //       return accentColor.withOpacity(0.1);
  //     return null;
  //   }),
  // );

  // TextButton Style
  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: accentColor,
    textStyle: const TextStyle(fontSize: 14),
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.hovered))
        return accentColor.withOpacity(0.1);
      if (states.contains(WidgetState.pressed))
        return accentColor.withOpacity(0.3);
      return null;
    }),
  );

  // Icon Button style for hover and pressed feedback
  static ButtonStyle iconButtonStyle = ButtonStyle(
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.hovered))
        return primaryColor.withOpacity(0.1);
      if (states.contains(WidgetState.pressed))
        return primaryColor.withOpacity(0.3);
      return null;
    }),
    foregroundColor: WidgetStateProperty.all(primaryColor),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
  );

  // Drawer item hover and selected style
  static TextStyle drawerItemTextStyle = TextStyle(
    fontSize: 16,
    color: textColorPrimary,
  );

  static TextStyle drawerItemSelectedTextStyle = TextStyle(
    fontSize: 16,
    color: accentColor,
    fontWeight: FontWeight.bold,
  );

  static Color drawerItemHoverColor = accentColor.withOpacity(0.1);
  static Color drawerItemSelectedColor = primaryColor.withOpacity(0.15);
}
