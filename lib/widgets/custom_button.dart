import 'package:flutter/material.dart';

enum ButtonState { defaultState, pressed, disabled }
enum ButtonColorTheme { dark, bright }

class CustomButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final Widget? iconLeft;
  final Widget? iconRight;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? labelColor;
  final double fontSize;
  final FontWeight fontWeight;
  final ButtonColorTheme? color; // dark/bright 테마
  final String fontFamily;

  const CustomButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.enabled = true,
    this.iconLeft,
    this.iconRight,
    this.height = 48, // Figma 기준
    this.borderRadius = 4, // Figma 기준
    this.backgroundColor,
    this.labelColor,
    this.fontSize = 13, // Figma 기준
    this.fontWeight = FontWeight.w600, // SemiBold
    this.color, // 추가
    this.fontFamily = 'Pretendard', // Figma 기준
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled) {
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enabled) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _handleTapCancel() {
    if (widget.enabled) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  Color _getBackgroundColor() {
    if (!widget.enabled) return const Color(0xFFAAAAAA);
    if (_isPressed) return const Color(0xFF333333);
    // color 테마 우선 적용
    if (widget.color == ButtonColorTheme.bright) return Colors.white;
    if (widget.color == ButtonColorTheme.dark) return Colors.black;
    return widget.backgroundColor ?? Colors.black;
  }

  Color _getLabelColor() {
    if (!widget.enabled) return const Color(0xFFDDDDDD);
    if (_isPressed) return const Color(0xFFAAAAAA);
    // color 테마 우선 적용
    if (widget.color == ButtonColorTheme.bright) return Colors.black;
    if (widget.color == ButtonColorTheme.dark) return Colors.white;
    return widget.labelColor ?? Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.7,
      child: GestureDetector(
        onTapDown: widget.enabled ? _handleTapDown : null,
        onTapUp: widget.enabled ? _handleTapUp : null,
        onTapCancel: widget.enabled ? _handleTapCancel : null,
        onTap: widget.enabled ? widget.onPressed : null,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.iconLeft != null) ...[
                widget.iconLeft!,
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: widget.fontFamily, // Pretendard
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                  color: _getLabelColor(),
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.iconRight != null) ...[
                const SizedBox(width: 8),
                widget.iconRight!,
              ],
            ],
          ),
        ),
      ),
    );
  }
} 