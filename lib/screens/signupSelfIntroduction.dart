import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kupid/styles/common_styles.dart';
import 'package:kupid/widgets/custom_input_field_states.dart';
import 'package:kupid/widgets/custom_button.dart';

typedef StepCompletedCallback = void Function(Map<String, dynamic> data);

class SignupSelfIntroductionScreen extends StatefulWidget {
  final StepCompletedCallback? onCompleted;
  
  const SignupSelfIntroductionScreen({Key? key, this.onCompleted}) : super(key: key);

  @override
  State<SignupSelfIntroductionScreen> createState() => _SignupSelfIntroductionScreenState();
}

class _SignupSelfIntroductionScreenState extends State<SignupSelfIntroductionScreen> {
  // 키 입력
  final TextEditingController heightController = TextEditingController();
  
  // 체형 선택
  String? selectedBodyType;
  final List<String> bodyTypes = ['슬림', '보통', '통통', '근육질', '기타'];
  
  // 국적 (자동 설정)
  String nationality = '대한민국';
  
  // MBTI 선택
  String? selectedMbti;
  final List<String> mbtiTypes = [
    'INTJ', 'INTP', 'ENTJ', 'ENTP',
    'INFJ', 'INFP', 'ENFJ', 'ENFP',
    'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ',
    'ISTP', 'ISFP', 'ESTP', 'ESFP'
  ];
  
  // 사용언어 선택 (최대 3개)
  List<String> selectedLanguages = [];
  final List<String> languages = [
    '한국어', '영어', '중국어', '일본어', '스페인어', 
    '프랑스어', '독일어', '러시아어', '태국어', '베트남어'
  ];
  
  // 인사말 입력
  final TextEditingController greetingController = TextEditingController();
  
  // 음성 인사말
  bool hasVoiceGreeting = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    
    // 휴대폰 번호 기반 국적 자동 설정 (임시)
    nationality = '대한민국';
  }

  @override
  void dispose() {
    heightController.dispose();
    greetingController.dispose();
    super.dispose();
  }

  void toggleLanguage(String language) {
    setState(() {
      if (selectedLanguages.contains(language)) {
        selectedLanguages.remove(language);
      } else {
        if (selectedLanguages.length < 3) {
          selectedLanguages.add(language);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('최대 3개 언어까지 선택 가능합니다'),
              backgroundColor: Color(0xFFFF2058),
            ),
          );
        }
      }
    });
  }

  void handleVoiceRecording() {
    setState(() {
      if (isRecording) {
        // 녹음 중지
        isRecording = false;
        hasVoiceGreeting = true;
        print('음성 녹음 완료');
      } else {
        // 녹음 시작
        isRecording = true;
        print('음성 녹음 시작');
      }
    });
  }

  void handleComplete() {
    // 필수 필드 검증
    if (heightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('키를 입력해주세요'),
          backgroundColor: Color(0xFFFF2058),
        ),
      );
      return;
    }
    
    if (selectedBodyType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('체형을 선택해주세요'),
          backgroundColor: Color(0xFFFF2058),
        ),
      );
      return;
    }
    
    if (selectedLanguages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('최소 1개 언어를 선택해주세요'),
          backgroundColor: Color(0xFFFF2058),
        ),
      );
      return;
    }
    
    if (greetingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('인사말을 입력해주세요'),
          backgroundColor: Color(0xFFFF2058),
        ),
      );
      return;
    }
    
    if (greetingController.text.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('인사말은 100자 이내로 입력해주세요'),
          backgroundColor: Color(0xFFFF2058),
        ),
      );
      return;
    }

    // 회원가입 완료
    if (widget.onCompleted != null) {
      widget.onCompleted!({
        'height': heightController.text,
        'bodyType': selectedBodyType,
        'nationality': nationality,
        'mbti': selectedMbti,
        'languages': selectedLanguages,
        'greeting': greetingController.text,
        'voiceGreeting': hasVoiceGreeting,
      });
    } else {
      // 단독 실행 시 메인 화면으로 이동
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('회원가입이 완료되었습니다!'),
          backgroundColor: Color(0xFF28A745),
        ),
      );
      // Navigator.pushReplacementNamed(context, '/main');
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
                        'About\nYourself',
                        style: CommonStyles.poppinsBold40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '자기소개를 작성해주세요',
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

                  // 키 입력
                  _buildSectionTitle('키'),
                  const SizedBox(height: 8),
                  CustomInputFieldStates(
                    state: CustomInputFieldState.placeHolder,
                    placeholder: '키를 입력해주세요 (예: 170)',
                    showIcon: false,
                    showTime: false,
                    controller: heightController,
                  ),
                  const SizedBox(height: 24),

                  // 체형 선택
                  _buildSectionTitle('체형'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: bodyTypes.map((type) {
                      final isSelected = selectedBodyType == type;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedBodyType = type;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFFFF2058) : Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? Color(0xFFFF2058) : Color(0xFFE0E0E0),
                            ),
                          ),
                          child: Text(
                            type,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Color(0xFF666666),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // 국적 (자동 설정)
                  _buildSectionTitle('국적'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Text(
                          nationality,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '자동 설정됨',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // MBTI 선택
                  _buildSectionTitle('MBTI (선택)'),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: mbtiTypes.length,
                    itemBuilder: (context, index) {
                      final type = mbtiTypes[index];
                      final isSelected = selectedMbti == type;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMbti = isSelected ? null : type;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFFFF2058) : Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected ? Color(0xFFFF2058) : Color(0xFFE0E0E0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              type,
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Color(0xFF666666),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // 사용언어 선택
                  _buildSectionTitle('사용언어 (최대 3개)'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: languages.map((language) {
                      final isSelected = selectedLanguages.contains(language);
                      return GestureDetector(
                        onTap: () => toggleLanguage(language),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFFFF2058) : Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? Color(0xFFFF2058) : Color(0xFFE0E0E0),
                            ),
                          ),
                          child: Text(
                            language,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Color(0xFF666666),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // 인사말 입력
                  _buildSectionTitle('인사말 (100자 이내)'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextField(
                      controller: greetingController,
                      maxLines: 4,
                      maxLength: 100,
                      decoration: InputDecoration(
                        hintText: '자신을 소개하는 인사말을 작성해주세요',
                        hintStyle: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                        border: InputBorder.none,
                        counterStyle: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 음성 인사말 (선택)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color(0xFFE9ECEF),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.mic,
                              size: 20,
                              color: Color(0xFFFF2058),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '음성 인사말 (선택)',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            if (hasVoiceGreeting) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Color(0xFF28A745),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '녹음완료',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '목소리로 자신을 소개해보세요 (30초 이내)',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 36,
                          child: CustomButton(
                            label: isRecording ? '녹음 중지' : (hasVoiceGreeting ? '다시 녹음' : '음성 녹음'),
                            color: isRecording ? ButtonColorTheme.bright : ButtonColorTheme.dark,
                            borderRadius: 4,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            onPressed: handleVoiceRecording,
                          ),
                        ),
                      ],
                    ),
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
                          color: Color(0xFF28A745), // 완료
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF28A745), // 완료
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFF2058), // 현재 단계
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // 완료 버튼
                  SizedBox(
                    width: 342,
                    height: 48,
                    child: CustomButton(
                      label: '회원가입 완료',
                      color: ButtonColorTheme.dark,
                      borderRadius: 4,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      onPressed: handleComplete,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }
}