import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 24x24 SVG 아이콘: view (assetName으로 다양한 아이콘 사용 가능)
class IconView24 extends StatelessWidget {
  final double size;
  final Color? color;
  final String? semanticLabel;
  final AlignmentGeometry alignment;
  final String assetName;

  const IconView24({
    Key? key,
    this.size = 24,
    this.color,
    this.semanticLabel,
    this.alignment = Alignment.center,
    this.assetName = 'assets/icon/24/view.svg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: SvgPicture.asset(
        assetName,
        width: size,
        height: size, // 24x24로 고정
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        semanticsLabel: semanticLabel,
      ),
    );
  }
} 