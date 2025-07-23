import 'package:flutter/material.dart';
import 'icon_view_24.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomInputFieldState {
  placeHolder,
  defaultState,
  focused,
  disabled,
  error,
}

class CustomInputFieldStates extends StatefulWidget {
  final CustomInputFieldState state;
  final String? placeholder;
  final String? value;
  final String? timeText;
  final String? errorMessage;
  final bool showIcon;
  final bool showTime;
  final bool showError;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final double? width;
  final FocusNode? externalFocusNode;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  const CustomInputFieldStates({
    super.key,
    this.state = CustomInputFieldState.placeHolder,
    this.placeholder,
    this.value,
    this.timeText,
    this.errorMessage,
    this.showIcon = true,
    this.showTime = true,
    this.showError = false,
    this.onTap,
    this.onChanged,
    this.controller,
    this.width,
    this.externalFocusNode,
    this.obscureText = false,
    this.onToggleVisibility,
  });

  @override
  State<CustomInputFieldStates> createState() => _CustomInputFieldStatesState();
}

class _CustomInputFieldStatesState extends State<CustomInputFieldStates> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.value);
    _focusNode = widget.externalFocusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    
    // 외부 controller가 전달된 경우 초기값 설정
    if (widget.controller != null && widget.value != null) {
      widget.controller!.text = widget.value!;
    }
  }

  @override
  void dispose() {
    // 외부에서 전달받은 controller는 dispose하지 않음
    if (widget.controller == null) {
      _controller.dispose();
    }
    // 외부에서 전달받은 FocusNode는 dispose하지 않음
    if (widget.externalFocusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomInputFieldStates oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. box(Frame) - Figma 노드명과 변수명 1:1 매핑, 크기/색상/코너 반영
        Container(
          key: const Key('box'),
          width: 337, // Figma absoluteBoundingBox width
          height: 48, // 모든 상태에서 48로 고정
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6), // Figma fill
            borderRadius: BorderRadius.circular(6), // Figma cornerRadius
            // Figma에 스트로크 없음, error시에도 border 없음
          ),
          child: Row(
            children: [
              // 2. label(Text) - Figma 노드명, 폰트, 색상, 정렬, 여백 1:1 반영
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8), // Figma padding
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // 입력값이 없고 포커스가 없으면 placeholder
                      if (_controller.text.isEmpty && !_isFocused)
                        RichText(
                          text: _styledText(widget.placeholder ?? '안내문구를 입력해주세요', isHint: true),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      // 입력값이 있거나 포커스가 있으면 입력값
                      if (_controller.text.isNotEmpty || _isFocused)
                        RichText(
                          text: widget.obscureText
                              ? TextSpan(
                                  text: '•' * _controller.text.length,
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF999999),
                                    height: 18.2 / 14,
                                  ),
                                )
                              : _styledText(_controller.text),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      // 실제 입력은 투명 TextField로 처리
                      TextField(
                    key: ValueKey(widget.obscureText),
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.state != CustomInputFieldState.disabled,
                    style: const TextStyle(
                          color: Colors.transparent,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 18.2 / 14,
                      ),
                        cursorColor: _getTextColor(),
                        textAlign: TextAlign.left,
                        obscureText: widget.obscureText,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '',
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: widget.onChanged,
                      ),
                    ],
                  ),
                ),
              ),
              // 3. time(Frame/Text) - Figma 노드명, 크기, 폰트, 색상, 정렬, 여백 1:1 반영
              if (widget.showTime && widget.timeText != null)
                Container(
                  key: const Key('time'),
                  width: 36,
                  height: 17,
                  margin: const EdgeInsets.only(right: 8),
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: _styledText(widget.timeText!, isHint: true),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              // 4. eye on/off 또는 check 아이콘
              if (widget.onToggleVisibility != null) ...[
                GestureDetector(
                  onTap: widget.onToggleVisibility,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: IconView24(
                        size: 24,
                        color: widget.obscureText ? const Color(0xFFAAAAAA) : const Color(0xFF555555),
                        alignment: Alignment.centerRight,
                        semanticLabel: widget.obscureText ? '비밀번호 숨김' : '비밀번호 표시',
                        assetName: widget.obscureText ? 'assets/icon/24/viewOff.svg' : 'assets/icon/24/viewOn.svg',
                      ),
                    ),
                  ),
                ),
              ] else if (widget.showIcon) ...[
                Container(
                  key: const Key('icon/12/checkBold'),
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: const BoxDecoration(),
                ),
              ],
            ],
          ),
        ),
        // 5. error(Frame) - Figma 노드명, 크기, 여백, 내부 구성 1:1 반영
        if (widget.showError && widget.errorMessage != null && widget.state == CustomInputFieldState.error)
          Container(
            key: const Key('error'),
            width: 337,
            height: 14,
            margin: const EdgeInsets.only(top: 6), // Figma margin
            child: Row(
              children: [
                // 6. Ellipse 144(점) - Figma 노드명, 크기, 색상 1:1 반영
                Container(
                  key: const Key('Ellipse 144'),
                  width: 2,
                  height: 2,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF0000), // Figma color
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4), // Figma gap 4px로 수정
                // 7. errMsg(Text) - Figma 노드명, 폰트, 색상, 정렬, 크기 1:1 반영
                Expanded(
                  child: RichText(
                    key: const Key('msg'),
                    text: _styledText(
                    widget.errorMessage!,
                      baseStyle: const TextStyle(
                        color: Color(0xFFFF0000),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        height: 14.3 / 11,
                      ),
                      isHint: true,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Color _getBackgroundColor() {
    switch (widget.state) {
      case CustomInputFieldState.disabled:
        return const Color(0xFFEAEAEA);
      case CustomInputFieldState.focused:
        return const Color(0xFFF6F6F6);
      default:
        return const Color(0xFFF6F6F6);
    }
  }

  Border? _getBorder() {
    switch (widget.state) {
      case CustomInputFieldState.error:
        return Border.all(color: const Color(0xFFF04438), width: 1);
      default:
        return null;
    }
  }

  Color _getTextColor() {
    if (_isFocused) {
      return const Color(0xFF000000); // focused 상태일 때 검정색
    }
    
    switch (widget.state) {
      case CustomInputFieldState.defaultState:
        return const Color(0xFF666666);
      case CustomInputFieldState.disabled:
        return const Color(0xFFAAAAAA);
      case CustomInputFieldState.error:
        return const Color(0xFF999999);
      default:
        return const Color(0xFF999999);
    }
  }

  Color _getPlaceholderColor() {
    switch (widget.state) {
      case CustomInputFieldState.defaultState:
        return const Color(0xFF666666);
      case CustomInputFieldState.disabled:
        return const Color(0xFFAAAAAA);
      case CustomInputFieldState.error:
        return const Color(0xFF999999);
      default:
        return const Color(0xFF999999);
    }
  }

  // 입력값에 폰트 정책 적용: 영문/숫자 Poppins, 한글/특수문자 Pretendard
  TextSpan _styledText(String text, {TextStyle? baseStyle, bool isHint = false}) {
    final List<InlineSpan> spans = [];
    final RegExp regex = RegExp(r'[A-Za-z0-9]+|[^A-Za-z0-9]+');
    final matches = regex.allMatches(text);
    for (final match in matches) {
      final part = match.group(0)!;
      final isEngNum = RegExp(r'^[A-Za-z0-9]+$').hasMatch(part);
      final style = (baseStyle ?? TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isHint ? _getPlaceholderColor() : _getTextColor(),
        height: 18.2 / 14,
      ));
      spans.add(TextSpan(
        text: part,
        style: isEngNum
            ? GoogleFonts.poppins().merge(style)
            : style.copyWith(fontFamily: 'Pretendard'),
      ));
    }
    return TextSpan(children: spans);
  }
}

// Usage examples
class CustomInputFieldStatesExamples extends StatelessWidget {
  const CustomInputFieldStatesExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomInputField States'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CustomInputField States Examples',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Placeholder state
            const Text('Placeholder State:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomInputFieldStates(
              state: CustomInputFieldState.placeHolder,
              placeholder: '안내문구를 입력해주세요',
              timeText: '00:00',
              showError: true,
              errorMessage: '에러문구를 입력해주세요',
            ),
            const SizedBox(height: 20),
            
            // Default state
            const Text('Default State:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomInputFieldStates(
              state: CustomInputFieldState.defaultState,
              value: '안내문구를 입력해주세요',
              timeText: '00:00',
              showError: true,
              errorMessage: '에러문구를 입력해주세요',
            ),
            const SizedBox(height: 20),
            
            // Focused state
            const Text('Focused State:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomInputFieldStates(
              state: CustomInputFieldState.focused,
              value: '안내문구를 입력해주세요',
              timeText: '00:00',
              showError: true,
              errorMessage: '에러문구를 입력해주세요',
            ),
            const SizedBox(height: 20),
            
            // Disabled state
            const Text('Disabled State:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomInputFieldStates(
              state: CustomInputFieldState.disabled,
              value: '안내문구를 입력해주세요',
              timeText: '00:00',
              showError: true,
              errorMessage: '에러문구를 입력해주세요',
            ),
            const SizedBox(height: 20),
            
            // Error state
            const Text('Error State:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomInputFieldStates(
              state: CustomInputFieldState.error,
              value: '안내문구를 입력해주세요',
              timeText: '00:00',
              showError: true,
              errorMessage: '에러문구를 입력해주세요',
            ),
          ],
        ),
      ),
    );
  }
} 