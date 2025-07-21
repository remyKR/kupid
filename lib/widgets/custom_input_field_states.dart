import 'package:flutter/material.dart';

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
                  child: TextField(
                    key: const Key('label'),
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.state != CustomInputFieldState.disabled,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14, // Figma fontSize
                      fontWeight: FontWeight.w400, // Figma fontWeight
                      color: Color(0xFF999999), // Figma color
                      height: 18.2 / 14, // Figma lineHeight
                    ),
                    textAlign: TextAlign.left, // Figma textAlignHorizontal
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _isFocused ? null : (widget.placeholder ?? '안내문구를 입력해주세요'),
                      hintStyle: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF999999),
                        height: 18.2 / 14,
                      ),
                    ),
                    onChanged: widget.onChanged,
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
                  child: Text(
                    widget.timeText!,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13, // Figma fontSize
                      fontWeight: FontWeight.w500, // Figma fontWeight
                      color: Color(0xFFFF0000), // Figma color
                      height: 16.9 / 13, // Figma lineHeight
                    ),
                    textAlign: TextAlign.left, // Figma textAlignHorizontal
                  ),
                ),
              // 4. icon/12/checkBold(Instance) - Figma 노드명, 크기, 색상, 여백 1:1 반영
              if (widget.showIcon)
                Container(
                  key: const Key('icon/12/checkBold'),
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 16),
                  // 실제 SVG 아이콘 적용 필요시 별도 처리, 예시로 Container만 둠
                  decoration: const BoxDecoration(),
                ),
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
                  child: Text(
                    widget.errorMessage!,
                    key: const Key('msg'), // Figma 노드명과 1:1 매핑
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 11, // Figma fontSize
                      fontWeight: FontWeight.w400, // Figma fontWeight
                      color: Color(0xFFFF0000), // Figma color
                      height: 14.3 / 11, // Figma lineHeight
                    ),
                    textAlign: TextAlign.left, // Figma textAlignHorizontal
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