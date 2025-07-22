import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kupid/styles/common_styles.dart';
import 'package:kupid/widgets/custom_input_field_states.dart';
import 'package:kupid/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/icon_view_24.dart';
import 'package:http/http.dart' as http;

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
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

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

  Future<void> _registerWithEmail() async {
    setState(() {
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
      errorMessage = null;
    });

    if (emailController.text.isEmpty) {
      setState(() => emailError = '이메일을 입력하세요.');
      return;
    }
    // 이메일 형식 검사
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      setState(() => emailError = '올바른 이메일 주소를 입력하세요.');
      return;
    }
    if (passwordController.text.isEmpty) {
      setState(() => passwordError = '비밀번호를 입력하세요.');
      return;
    }
    // 비밀번호 길이(6~10자)만 검사
    if (passwordController.text.length < 6 || passwordController.text.length > 10) {
      setState(() => passwordError = '6자 이상 10자 이하로 입력해주세요');
      return;
    }
    if (confirmPasswordController.text.isEmpty) {
      setState(() => confirmPasswordError = '비밀번호 확인을 입력하세요.');
      return;
    }
    // 비밀번호 확인도 길이만 검사
    if (confirmPasswordController.text.length < 6 || confirmPasswordController.text.length > 10) {
      setState(() => confirmPasswordError = '6자 이상 10자 이하로 입력해주세요');
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      setState(() => confirmPasswordError = '비밀번호가 일치하지 않습니다.');
      return;
    }

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() {
        errorMessage = null;
      });
      // 이메일 인증 메일 발송
      final user = credential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        if (mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('이메일 인증'),
              content: const Text('입력하신 이메일로 인증 메일이 발송되었습니다.\n이메일 인증 후 다시 로그인해 주세요.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('확인'),
                ),
              ],
            ),
          );
        }
        // 인증 전에는 로그인/다음 단계로 이동하지 않음
        return;
      }
      // 서버에 회원가입 데이터 전송
      await sendSignupDataToServer(emailController.text.trim());
      // 회원가입 성공 시 프로필 이름 입력 페이지로 이동
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/signupProfileName');
      }
      // TODO: 회원가입 성공 후 이동/알림 등 추가 가능
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('이미 회원기입이 완료된 계정입니다.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          await Future.delayed(const Duration(milliseconds: 1500));
          Navigator.pushReplacementNamed(context, '/login_email');
        }
      } else {
      setState(() {
        errorMessage = e.message;
      });
      }
    }
  }

  Future<void> sendSignupDataToServer(String email) async {
    // 실제 서버 URL로 교체 필요
    const url = 'https://your-server.com/api/signup';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: '{"email": "$email"}',
      );
      if (response.statusCode != 200) {
        throw Exception('서버 전송 실패');
      }
    } catch (e) {
      // 서버 전송 실패 시 에러 처리(필요시)
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
                crossAxisAlignment: CrossAxisAlignment.start, // align-items: flex-start
                mainAxisAlignment: MainAxisAlignment.start,   // flex-direction: column
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
                  // inputs_wrapper 레이아웃 정보 반영
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // align-items: flex-start
                    mainAxisAlignment: MainAxisAlignment.start,   // flex-direction: column
                    children: [
                      CustomInputFieldStates(
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
                      const SizedBox(height: 12),
                      CustomInputFieldStates(
                          state: passwordError != null ? CustomInputFieldState.error : passwordState,
                        placeholder: '비밀번호를 6-10자로 입력해주세요',
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
                      const SizedBox(height: 12),
                      CustomInputFieldStates(
                          state: confirmPasswordError != null ? CustomInputFieldState.error : confirmPasswordState,
                        placeholder: '비밀번호를 재입력 해 주세요',
                          showIcon: false,
                          showTime: false,
                          showError: confirmPasswordError != null,
                          errorMessage: confirmPasswordError,
                          width: 342,
                          externalFocusNode: confirmPasswordFocusNode,
                          controller: confirmPasswordController,
                        obscureText: !confirmPasswordVisible,
                        onToggleVisibility: () {
                          setState(() {
                            confirmPasswordVisible = !confirmPasswordVisible;
                          });
                        },
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
                    ],
                  ),
                  // align-self: stretch (width: double.infinity)
                  const SizedBox(height: 24),
                  if (errorMessage != null) ...[
                    SizedBox(height: 12),
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: CustomButton(
                      label: '회원가입',
                      color: ButtonColorTheme.dark,
                      borderRadius: 4,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      onPressed: _registerWithEmail,
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