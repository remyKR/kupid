import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kupid/styles/common_styles.dart';
import 'package:kupid/widgets/custom_input_field_states.dart';
import 'package:kupid/widgets/custom_button.dart';
import 'signupProfilePhoto.dart';

typedef StepCompletedCallback = void Function(Map<String, dynamic> data);

class SignupBasicInfoScreen extends StatefulWidget {
  final StepCompletedCallback? onCompleted;
  
  const SignupBasicInfoScreen({Key? key, this.onCompleted}) : super(key: key);

  @override
  State<SignupBasicInfoScreen> createState() => _SignupBasicInfoScreenState();
}

class _SignupBasicInfoScreenState extends State<SignupBasicInfoScreen> {
  // 닉네임 관련
  CustomInputFieldState nicknameState = CustomInputFieldState.placeHolder;
  final FocusNode nicknameFocusNode = FocusNode();
  final TextEditingController nicknameController = TextEditingController();
  String? nicknameErrorMessage;
  bool showNicknameError = false;

  // 생년월일 관련
  CustomInputFieldState birthdateState = CustomInputFieldState.placeHolder;
  final FocusNode birthdateFocusNode = FocusNode();
  final TextEditingController birthdateController = TextEditingController();
  String? birthdateErrorMessage;
  bool showBirthdateError = false;
  DateTime? selectedDate;

  // 휴대폰 번호 관련
  CustomInputFieldState phoneState = CustomInputFieldState.placeHolder;
  final FocusNode phoneFocusNode = FocusNode();
  final TextEditingController phoneController = TextEditingController();
  String? phoneErrorMessage;
  bool showPhoneError = false;

  // 성별 선택
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    
    // 닉네임 포커스 리스너
    nicknameFocusNode.addListener(() {
      if (!nicknameFocusNode.hasFocus) {
        validateNickname(nicknameController.text);
      }
    });

    // 생년월일 포커스 리스너
    birthdateFocusNode.addListener(() {
      if (!birthdateFocusNode.hasFocus) {
        validateBirthdate(birthdateController.text);
      }
    });

    // 휴대폰 번호 포커스 리스너
    phoneFocusNode.addListener(() {
      if (!phoneFocusNode.hasFocus) {
        validatePhone(phoneController.text);
      }
    });
  }

  @override
  void dispose() {
    nicknameFocusNode.dispose();
    nicknameController.dispose();
    birthdateFocusNode.dispose();
    birthdateController.dispose();
    phoneFocusNode.dispose();
    phoneController.dispose();
    super.dispose();
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

  void validateBirthdate(String value) {
    setState(() {
      if (value.isEmpty) {
        birthdateState = CustomInputFieldState.placeHolder;
        showBirthdateError = false;
        birthdateErrorMessage = null;
      } else if (selectedDate == null) {
        birthdateState = CustomInputFieldState.error;
        showBirthdateError = true;
        birthdateErrorMessage = '올바른 생년월일을 선택해주세요';
      } else {
        // 만 18세 이상 체크
        final now = DateTime.now();
        final age = now.year - selectedDate!.year;
        if (age < 18 || (age == 18 && now.month < selectedDate!.month) ||
            (age == 18 && now.month == selectedDate!.month && now.day < selectedDate!.day)) {
          birthdateState = CustomInputFieldState.error;
          showBirthdateError = true;
          birthdateErrorMessage = '만 18세 이상만 가입 가능합니다';
        } else {
          birthdateState = CustomInputFieldState.defaultState;
          showBirthdateError = false;
          birthdateErrorMessage = null;
        }
      }
    });
  }

  void validatePhone(String value) {
    setState(() {
      if (value.isEmpty) {
        phoneState = CustomInputFieldState.placeHolder;
        showPhoneError = false;
        phoneErrorMessage = null;
      } else if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value.replaceAll('-', ''))) {
        phoneState = CustomInputFieldState.error;
        showPhoneError = true;
        phoneErrorMessage = '올바른 휴대폰 번호를 입력해주세요';
      } else {
        phoneState = CustomInputFieldState.defaultState;
        showPhoneError = false;
        phoneErrorMessage = null;
      }
    });
  }

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthdateController.text = '${picked.year}.${picked.month.toString().padLeft(2, '0')}.${picked.day.toString().padLeft(2, '0')}';
      });
      validateBirthdate(birthdateController.text);
    }
  }

  void handleNextButton() {
    bool hasError = false;

    // 닉네임 검증
    if (nicknameController.text.isEmpty) {
      validateNickname('');
      hasError = true;
    } else if (nicknameController.text.length < 2 || nicknameController.text.length > 8) {
      hasError = true;
    }

    // 생년월일 검증
    if (birthdateController.text.isEmpty) {
      validateBirthdate('');
      hasError = true;
    } else if (selectedDate == null) {
      hasError = true;
    }

    // 휴대폰 번호 검증
    if (phoneController.text.isEmpty) {
      validatePhone('');
      hasError = true;
    } else if (!RegExp(r'^[0-9]{10,11}$').hasMatch(phoneController.text.replaceAll('-', ''))) {
      hasError = true;
    }

    // 성별 검증
    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('성별을 선택해주세요'),
          backgroundColor: Color(0xFFFF2058),
        ),
      );
      hasError = true;
    }

    if (!hasError) {
      if (widget.onCompleted != null) {
        widget.onCompleted!({
          'nickname': nicknameController.text,
          'birthdate': birthdateController.text,
          'phone': phoneController.text,
          'selectedDate': selectedDate,
          'gender': selectedGender,
        });
      } else {
        // 단독 실행 시 다음 화면으로 이동
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => SignupProfilePhotoScreen())
        );
      }
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
                children: [
                  const SizedBox(height: 44),
                  // 뒤로가기 버튼
                  Row(
                    children: [
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
                    ],
                  ),
                  const SizedBox(height: 44),
                  
                  // 제목
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Basic\nInformation',
                        style: CommonStyles.poppinsBold40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '기본 정보를 입력해주세요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 닉네임 입력
                  Text(
                    '닉네임',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomInputFieldStates(
                    state: nicknameState,
                    placeholder: '닉네임을 8자 이내로 입력해주세요',
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
                  const SizedBox(height: 24),

                  // 생년월일 입력
                  Text(
                    '생년월일',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: selectDate,
                    child: CustomInputFieldStates(
                      state: birthdateState,
                      placeholder: '생년월일을 선택해주세요',
                      showIcon: false,
                      showTime: false,
                      showError: showBirthdateError,
                      errorMessage: birthdateErrorMessage,
                      width: 342,
                      controller: birthdateController,
                      onTap: selectDate,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 성별 선택
                  Text(
                    '성별',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGender = 'male';
                            });
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: selectedGender == 'male' ? Color(0xFFFF2058) : Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: selectedGender == 'male' ? Color(0xFFFF2058) : Color(0xFFE0E0E0),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '남성',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: selectedGender == 'male' ? Colors.white : Color(0xFF666666),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGender = 'female';
                            });
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: selectedGender == 'female' ? Color(0xFFFF2058) : Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: selectedGender == 'female' ? Color(0xFFFF2058) : Color(0xFFE0E0E0),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '여성',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: selectedGender == 'female' ? Colors.white : Color(0xFF666666),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 휴대폰 번호 입력
                  Text(
                    '휴대폰 번호',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomInputFieldStates(
                    state: phoneState,
                    placeholder: '휴대폰 번호를 입력해주세요',
                    showIcon: false,
                    showTime: false,
                    showError: showPhoneError,
                    errorMessage: phoneErrorMessage,
                    width: 342,
                    externalFocusNode: phoneFocusNode,
                    controller: phoneController,
                    onChanged: (value) {
                      validatePhone(value);
                    },
                  ),
                  const SizedBox(height: 40),

                  // 진행 상태 표시
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFF2058), // 현재 단계
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEAEAEA), // 비활성
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEAEAEA), // 비활성
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
                      onPressed: handleNextButton,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}