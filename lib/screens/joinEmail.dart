import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kupid/styles/common_styles.dart';
import 'package:kupid/widgets/custom_input_field_states.dart';
import 'package:kupid/widgets/custom_button.dart';

class JoinEmailScreen extends StatefulWidget {
  const JoinEmailScreen({Key? key}) : super(key: key);

  @override
  State<JoinEmailScreen> createState() => _JoinEmailScreenState();
}

class _JoinEmailScreenState extends State<JoinEmailScreen> {
  CustomInputFieldState emailState = CustomInputFieldState.placeHolder;
  CustomInputFieldState passwordState = CustomInputFieldState.placeHolder;
  CustomInputFieldState confirmPasswordState = CustomInputFieldState.placeHolder;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? errorMessage;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        setState(() {
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
          if (passwordController.text.isEmpty) {
            passwordState = CustomInputFieldState.placeHolder;
          } else {
            passwordState = CustomInputFieldState.defaultState;
          }
        });
      }
    });
    confirmPasswordFocusNode.addListener(() {
      if (!confirmPasswordFocusNode.hasFocus) {
        setState(() {
          if (confirmPasswordController.text.isEmpty) {
            confirmPasswordState = CustomInputFieldState.placeHolder;
          } else {
            confirmPasswordState = CustomInputFieldState.defaultState;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // 1. buildInputWithError 메서드 추가
  Widget buildInputWithError({
    required Widget input,
    String? error,
  }) {
    if (error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          input,
          const SizedBox(height: 8),
          Text(error, style: const TextStyle(color: Colors.red, fontSize: 13)),
          const SizedBox(height: 4), // 8+4=12
        ],
      );
    } else {
      return Column(
        children: [
          input,
          const SizedBox(height: 12),
        ],
      );
    }
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
                        'HELLO\nSTRANGER',
                        style: CommonStyles.poppinsBold40,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // inputs_wrapper(3개 입력 필드 전체) gap을 20px로 적용
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildInputWithError(
                            input: CustomInputFieldStates(
                              state: emailError != null ? CustomInputFieldState.error : emailState,
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
                            error: emailError,
                          ),
                          const SizedBox(height: 20), // inputs_wrapper gap 20px
                          buildInputWithError(
                            input: CustomInputFieldStates(
                              state: passwordError != null ? CustomInputFieldState.error : passwordState,
                              placeholder: '비밀번호를 입력하세요.',
                              showIcon: false,
                              showTime: false,
                              showError: passwordError != null,
                              errorMessage: passwordError,
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
                            error: passwordError,
                          ),
                          const SizedBox(height: 20), // inputs_wrapper gap 20px
                          buildInputWithError(
                            input: CustomInputFieldStates(
                              state: confirmPasswordError != null ? CustomInputFieldState.error : confirmPasswordState,
                              placeholder: '비밀번호를 다시 입력하세요',
                              showIcon: false,
                              showTime: false,
                              showError: confirmPasswordError != null,
                              errorMessage: confirmPasswordError,
                              width: 342,
                              externalFocusNode: confirmPasswordFocusNode,
                              controller: confirmPasswordController,
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    confirmPasswordState = CustomInputFieldState.placeHolder;
                                  } else {
                                    confirmPasswordState = CustomInputFieldState.defaultState;
                                  }
                                });
                              },
                            ),
                            error: confirmPasswordError,
                          ),
                        ],
                      ),
                      if (emailError != null || passwordError != null || confirmPasswordError != null) ...[
                        const SizedBox(height: 12), // Figma gap
                      ],
                      SizedBox(
                        width: 342,
                        height: 48,
                        child: CustomButton(
                          label: '이메일로 회원가입',
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
                              confirmPasswordError = null;
                            });
                            final email = emailController.text.trim();
                            final password = passwordController.text;
                            final confirmPassword = confirmPasswordController.text;
                            final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                            bool hasError = false;
                            if (email.isEmpty) {
                              emailError = '이메일을 입력하세요.';
                              hasError = true;
                            } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                              emailError = '올바른 이메일 주소를 입력하세요.';
                              hasError = true;
                            }
                            if (password.isEmpty) {
                              passwordError = '비밀번호를 입력하세요.';
                              hasError = true;
                            } else if (password.length < 8) {
                              passwordError = '비밀번호는 8자 이상이어야 합니다.';
                              hasError = true;
                            }
                            if (confirmPassword.isEmpty) {
                              confirmPasswordError = '비밀번호 확인을 입력하세요.';
                              hasError = true;
                            } else if (password != confirmPassword) {
                              confirmPasswordError = '비밀번호가 일치하지 않습니다.';
                              hasError = true;
                            }
                            if (hasError) {
                              setState(() {});
                              return;
                            }
                            // 실제 회원가입 로직은 추후 추가
                            // 임시: 성공 메시지
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('회원가입 성공'),
                                content: Text('이메일: $email'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // 팝업 닫기
                                      Navigator.pushNamed(context, '/signupProfileName');
                                    },
                                    child: const Text('확인'),
                                  ),
                                ],
                              ),
                            );
                          },
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