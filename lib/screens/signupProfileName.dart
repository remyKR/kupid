import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kupid/styles/common_styles.dart';
import 'package:kupid/widgets/custom_input_field_states.dart';
import 'package:kupid/widgets/custom_button.dart';

class SignupProfileNameScreen extends StatefulWidget {
  const SignupProfileNameScreen({Key? key}) : super(key: key);

  @override
  State<SignupProfileNameScreen> createState() => _SignupProfileNameScreenState();
}

class _SignupProfileNameScreenState extends State<SignupProfileNameScreen> {
  CustomInputFieldState nicknameState = CustomInputFieldState.placeHolder;
  final FocusNode nicknameFocusNode = FocusNode();
  final TextEditingController nicknameController = TextEditingController();
  String? nicknameErrorMessage;
  bool showNicknameError = false;

  @override
  void initState() {
    super.initState();
    nicknameFocusNode.addListener(() {
      if (!nicknameFocusNode.hasFocus) {
        validateNickname(nicknameController.text);
      }
    });
  }

  void validateNickname(String value) {
    setState(() {
      if (value.isEmpty) {
        nicknameState = CustomInputFieldState.placeHolder;
        showNicknameError = false;
        nicknameErrorMessage = null;
      } else if (value.length < 2 || value.length > 8) {
        nicknameState = CustomInputFieldState.error;
        showNicknameError = true;
        nicknameErrorMessage = '2글자 이상 8글자 이하로 입력해주세요';
      } else {
        nicknameState = CustomInputFieldState.defaultState;
        showNicknameError = false;
        nicknameErrorMessage = null;
      }
    });
  }

  @override
  void dispose() {
    nicknameFocusNode.dispose();
    nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 44),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: SvgPicture.asset(
                          'assets/icon/40/backLarge.svg',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 44),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Create\nNickname',
                        style: CommonStyles.poppinsBold40,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // 닉네임 입력
                  CustomInputFieldStates(
                    state: nicknameState,
                    placeholder: '닉네임을 8자 이내로 입력해주세요.',
                    showIcon: false,
                    showTime: false,
                    showError: showNicknameError,
                    errorMessage: nicknameErrorMessage,
                    width: 342,
                    externalFocusNode: nicknameFocusNode,
                    controller: nicknameController,
                    onChanged: (value) {
                      validateNickname(value);
                    },
                  ),
                  const SizedBox(height: 40),
                  // dot indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFF2058), // dot_on
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEAEAEA), // dot_off
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEAEAEA), // dot_off
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEAEAEA), // dot_off
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // 다음 버튼
                  SizedBox(
                    width: 342,
                    height: 48,
                    child: CustomButton(
                      label: '다음',
                      color: ButtonColorTheme.dark,
                      borderRadius: 4,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      onPressed: () {
                        if (nicknameController.text.isEmpty) {
                          setState(() {
                            nicknameState = CustomInputFieldState.error;
                            showNicknameError = true;
                            nicknameErrorMessage = '2글자 이상 8글자 이하로 입력해주세요';
                          });
                        } else if (nicknameController.text.length < 2 || nicknameController.text.length > 8) {
                          // 이미 에러 상태이므로 추가 작업 없음
                        } else {
                          // 다음 단계로 진행
                          print('닉네임 입력 완료: ${nicknameController.text}');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 