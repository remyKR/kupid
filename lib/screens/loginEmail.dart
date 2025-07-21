import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kupid/styles/common_styles.dart';
import 'package:kupid/widgets/custom_input_field_states.dart';
import 'package:kupid/widgets/custom_button.dart';

class loginEmail extends StatefulWidget {
  const loginEmail({Key? key}) : super(key: key);

  @override
  State<loginEmail> createState() => _loginEmailState();
}

class _loginEmailState extends State<loginEmail> {
  CustomInputFieldState emailState = CustomInputFieldState.placeHolder;
  CustomInputFieldState passwordState = CustomInputFieldState.placeHolder;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        setState(() {
          // focus out 시 텍스트 유무에 따라 상태 결정
          if (emailController.text.isEmpty) {
            emailState = CustomInputFieldState.placeHolder;
          } else {
            emailState = CustomInputFieldState.defaultState;
          }
        });
      }
    });
    
    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        setState(() {
          // focus out 시 텍스트 유무에 따라 상태 결정
          if (passwordController.text.isEmpty) {
            passwordState = CustomInputFieldState.placeHolder;
          } else {
            passwordState = CustomInputFieldState.defaultState;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 화면 아무 곳이나 터치하면 모든 focus 해제
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white, // Figma #ffffff
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 44), // status_bar
                    // header (backLarge 아이콘)
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        'assets/icon/40/backLarge.svg',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(height: 44),
                    // text_container
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HELLO\nSTRANGER',
                          style: CommonStyles.poppinsBold40,
                        ),
                        const SizedBox(height: 8),
                        // 서브텍스트 (Figma: 14px, #777)
                        Text(
                          '낯선 누군가와 함께\n따스한 이야기를 나누어보세요',
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF777777),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // contents_container
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // input_container
                        CustomInputFieldStates(
                          state: emailState,
                          placeholder: 'e-mail 주소를 입력하세요',
                          showIcon: false,
                          showTime: false,
                          showError: false,
                          width: 342,
                          externalFocusNode: emailFocusNode,
                          controller: emailController,
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                emailState = CustomInputFieldState.placeHolder;
                              } else {
                                emailState = CustomInputFieldState.defaultState;
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomInputFieldStates(
                          state: passwordState,
                          placeholder: '비밀번호를 입력하세요.',
                          showIcon: false,
                          showTime: false,
                          showError: false,
                          width: 342,
                          externalFocusNode: passwordFocusNode,
                          controller: passwordController,
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                passwordState = CustomInputFieldState.placeHolder;
                              } else {
                                passwordState = CustomInputFieldState.defaultState;
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 342,
                          height: 48,
                          child: CustomButton(
                            label: '이메일로 시작하기',
                            color: ButtonColorTheme.dark,
                            borderRadius: 4,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            '비밀번호를 잊으셨나요?',
                            textAlign: TextAlign.center,
                            style: CommonStyles.pretendardMedium13Underline,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 