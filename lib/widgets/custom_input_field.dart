import 'package:flutter/material.dart';
import 'icon_view_24.dart';

class CustomInputField extends StatefulWidget {
  final String? placeholder;
  final bool enabled;
  final bool hasError;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final String? timerText; // 타이머 텍스트
  final bool showCheck; // 체크 아이콘 표시 여부

  const CustomInputField({
    Key? key,
    this.placeholder,
    this.enabled = true,
    this.hasError = false,
    this.errorText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.timerText,
    this.showCheck = false,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  Color _getLabelColor() {
    if (!widget.enabled) return const Color(0xFFAAAAAA);
    if (widget.hasError) return const Color(0xFFAAAAAA);
    if (_isFocused) return Colors.black;
    if (widget.placeholder != null) return const Color(0xFFAAAAAA);
    return const Color(0xFF666666);
  }

  Color _getBoxColor() {
    if (!widget.enabled) return const Color(0xFFEAEAEA);
    return const Color(0xFFF9F9F9);
  }

  Color _getBorderColor() {
    if (!widget.enabled) return const Color(0xFFEAEAEA);
    if (widget.hasError) return const Color(0xFFFF0000);
    if (_isFocused) return const Color(0xFF8A38F5);
    return const Color(0xFFF9F9F9);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: _getBoxColor(),
                borderRadius: BorderRadius.circular(6), // ← 6으로 수정
                border: Border.all(
                  color: _getBorderColor(),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                onChanged: widget.onChanged,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  hintText: widget.placeholder,
                  hintStyle: TextStyle(
                    color: _getLabelColor(),
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                cursorColor: const Color(0xFF8A38F5),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.timerText != null && widget.timerText!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      widget.timerText!,
                      style: const TextStyle(
                        color: Color(0xFFFF0000),
                        fontFamily: 'Pretendard',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                if (widget.showCheck)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: IconView24(
                        size: 12,
                        color: const Color(0xFF8A38F5),
                        alignment: Alignment.centerRight,
                        semanticLabel: '체크',
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        if (widget.hasError && (widget.errorText?.isNotEmpty ?? false))
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 2,
                  height: 2,
                  margin: const EdgeInsets.only(top: 6, right: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF0000),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: const TextStyle(
                      color: Color(0xFFFF0000),
                      fontFamily: 'Pretendard',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
} 