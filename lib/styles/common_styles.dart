import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonStyles {
  // 색상 정의
  static const Color primaryBlack = Colors.black;
  static const Color primaryWhite = Colors.white;
  static const Color textGray = Color(0xFF777777);
  static const Color textDarkGray = Color(0xFF888888);
  static const Color textLightGray = Color(0xFF999999);
  static const Color backgroundPurple = Color(0xFFF0E0FF);
  static const Color dividerColor = Color(0xFFE0CEF0);
  static const Color inputBackground = Color(0xFFF6F6F6);
  static const Color buttonBlack = Color(0xFF000000);

  // Poppins 폰트 스타일
  static TextStyle poppinsBold40 = GoogleFonts.poppins(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: primaryBlack,
    height: 1.1, // 44px / 40px
  );

  static TextStyle poppinsBold32 = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: primaryBlack,
    height: 1.1,
  );

  static TextStyle poppinsBold24 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: primaryBlack,
    height: 1.1,
  );

  static TextStyle poppinsBold20 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: primaryBlack,
    height: 1.1,
  );

  static TextStyle poppinsBold16 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: primaryBlack,
    height: 1.1,
  );

  static TextStyle poppinsBold13 = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: primaryBlack,
    height: 1.1,
  );

  // Pretendard 폰트 스타일
  static TextStyle pretendardRegular14 = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textGray,
    height: 1.6, // 22.4px / 14px
  );

  static TextStyle pretendardMedium13 = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: textDarkGray,
    height: 20.8 / 13, // Figma inspect: line-height: 20.8px
  );

  static TextStyle pretendardBold13 = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: primaryWhite,
    height: 1.2, // 15.6px / 13px
  );

  static TextStyle pretendardMedium15 = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Color(0xFF666666),
    height: 1.6,
  );

  static TextStyle pretendardSemiBold13 = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Color(0xFF333333),
    height: 1.2,
  );

  // 특수 스타일
  static TextStyle pretendardMedium13Underline = const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: textDarkGray,
    height: 1.6, // Figma: lineHeightPx 20.8 / fontSize 13 = 1.6
    decoration: TextDecoration.underline,
    decorationStyle: TextDecorationStyle.solid,
    decorationColor: textDarkGray, // underline 색상을 폰트 색상과 동일하게 설정
  );

  // 레이아웃 상수
  static const double screenWidth = 390;
  static const double screenHeight = 844;
  static const double statusBarHeight = 44;
  static const double defaultPadding = 24;
  static const double inputHeight = 44;
  static const double buttonHeight = 48;
  static const double inputCornerRadius = 6;
  static const double buttonCornerRadius = 4;

  // 간격 상수
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;

  // 입력필드 스타일
  static InputDecoration inputDecoration({
    required String hintText,
    bool showError = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textLightGray,
        height: 1.3, // 18.2px / 14px
      ),
      filled: true,
      fillColor: inputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputCornerRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputCornerRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputCornerRadius),
        borderSide: BorderSide.none,
      ),
      errorBorder: showError ? OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputCornerRadius),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ) : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }

  // 버튼 스타일
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: buttonBlack,
    foregroundColor: primaryWhite,
    minimumSize: const Size(342, buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonCornerRadius),
    ),
    elevation: 0,
  );

  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryWhite,
    foregroundColor: buttonBlack,
    minimumSize: const Size(342, buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonCornerRadius),
      side: const BorderSide(color: buttonBlack, width: 1),
    ),
    elevation: 0,
  );
} 