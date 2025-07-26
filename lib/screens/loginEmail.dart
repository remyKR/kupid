import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kupid/styles/common_styles.dart';
import 'package:kupid/widgets/custom_input_field_states.dart';
import 'package:kupid/widgets/custom_button.dart';
// import 'package:firebase_auth/firebase_auth.dart';

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
  String? errorMessage;
  String? emailError;
  String? passwordError;
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
        setState(() {
        if (emailFocusNode.hasFocus) {
          emailState = CustomInputFieldState.focused;
        } else if (emailController.text.isEmpty) {
            emailState = CustomInputFieldState.placeHolder;
          } else {
            emailState = CustomInputFieldState.defaultState;
          }
        });
    });
    
    passwordFocusNode.addListener(() {
        setState(() {
        if (passwordFocusNode.hasFocus) {
          passwordState = CustomInputFieldState.focused;
        } else if (passwordController.text.isEmpty) {
            passwordState = CustomInputFieldState.placeHolder;
          } else {
            passwordState = CustomInputFieldState.defaultState;
          }
        });
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // loginEmail align: TOP(START)
                mainAxisAlignment: MainAxisAlignment.start,   // loginEmail align: TOP
                children: [
                  const SizedBox(height: 44), // status_bar
                  // header (backLarge 아이콘)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // header align: CENTER
                    mainAxisAlignment: MainAxisAlignment.start,   // header align: LEFT
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
                  // text_container
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // text_container align: LEFT
                    mainAxisAlignment: MainAxisAlignment.start,   // text_container align: TOP
                    children: [
                      Text(
                        'HELLO\nSTRANGER',
                        style: CommonStyles.poppinsBold40,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // contents_container
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // contents_container align: LEFT
                    mainAxisAlignment: MainAxisAlignment.start,   // contents_container align: TOP
                    children: [
                      // input_container
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // input_container align: LEFT
                        mainAxisAlignment: MainAxisAlignment.start,   // input_container align: TOP
                        children: [
                          CustomInputFieldStates(
                            state: emailState,
                            placeholder: 'e-mail 주소를 입력하세요',
                            showIcon: false,
                            showTime: false,
                            showError: emailError != null,
                            errorMessage: emailError,
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
                            showError: passwordError != null,
                            errorMessage: passwordError,
                            width: 342,
                            externalFocusNode: passwordFocusNode,
                            controller: passwordController,
                            obscureText: !passwordVisible,
                            onToggleVisibility: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
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
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 342,
                        height: 48,
                        child: CustomButton(
                          label: '이메일 로그인',
                          color: ButtonColorTheme.dark,
                          borderRadius: 4,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          onPressed: () {
                            setState(() {
                              errorMessage = null;
                              emailError = null;
                              passwordError = null;
                            });
                            final email = emailController.text.trim();
                            final password = passwordController.text;
                            final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                            bool hasError = false;
                            if (email.isEmpty) {
                              emailError = '이메일을 입력하세요.';
                              emailState = CustomInputFieldState.error;
                              hasError = true;
                            } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                              emailError = '올바른 이메일 주소를 입력하세요.';
                              emailState = CustomInputFieldState.error;
                              hasError = true;
                            } else {
                              emailState = CustomInputFieldState.defaultState;
                            }
                            if (password.isEmpty) {
                              passwordError = '비밀번호를 입력하세요.';
                              passwordState = CustomInputFieldState.error;
                              hasError = true;
                            } else {
                              passwordState = CustomInputFieldState.defaultState;
                            }
                            if (hasError) {
                              setState(() {});
                              return;
                            }
                            // Firebase removed - temporarily bypass authentication
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('로그인 성공'),
                                content: Text('이메일: $email'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('확인'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // 로그인 버튼 아래 12px 아래 글로벌 에러 메시지
                      if ((errorMessage ?? '').isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFFFF0000),
                            fontFamily: 'Pretendard',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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
    );
  }
} 