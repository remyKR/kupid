import 'package:flutter/material.dart';
import 'signupBasicInfo.dart';
import 'signupProfilePhoto.dart';
import 'signupSelfIntroduction.dart';

class SignupProcessManager extends StatefulWidget {
  const SignupProcessManager({Key? key}) : super(key: key);

  @override
  State<SignupProcessManager> createState() => _SignupProcessManagerState();
}

class _SignupProcessManagerState extends State<SignupProcessManager> {
  int currentStep = 0;
  
  // 사용자 데이터 저장
  Map<String, dynamic> userData = {};

  final List<Widget> steps = [];

  @override
  void initState() {
    super.initState();
    initializeSteps();
  }

  void initializeSteps() {
    setState(() {
      steps.clear();
      steps.addAll([
        SignupBasicInfoScreen(
          onCompleted: (data) => goToNextStep(data),
        ),
        SignupProfilePhotoScreen(
          onCompleted: (data) => goToNextStep(data),
        ),
        SignupSelfIntroductionScreen(
          onCompleted: (data) => completeSignup(data),
        ),
      ]);
    });
  }

  void goToNextStep(Map<String, dynamic> stepData) {
    setState(() {
      userData.addAll(stepData);
      if (currentStep < steps.length - 1) {
        currentStep++;
      }
    });
    print('현재 단계: ${currentStep + 1}/3');
    print('수집된 데이터: $userData');
  }

  void goToPreviousStep() {
    setState(() {
      if (currentStep > 0) {
        currentStep--;
      }
    });
  }

  void completeSignup(Map<String, dynamic> finalData) {
    userData.addAll(finalData);
    
    print('=== 회원가입 완료 ===');
    print('전체 사용자 데이터: $userData');
    
    // TODO: 서버에 회원가입 데이터 전송
    // TODO: 로컬 저장소에 사용자 정보 저장
    // TODO: 메인 화면으로 이동
    
    // 임시: 메인 화면으로 이동
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentStep > 0) {
          goToPreviousStep();
          return false;
        }
        return true;
      },
      child: steps[currentStep],
    );
  }
}

// 각 단계별 화면에서 사용할 콜백 타입 정의
typedef StepCompletedCallback = void Function(Map<String, dynamic> data);

// 기본 정보 입력 화면 (수정된 버전)
class SignupBasicInfoScreen extends StatefulWidget {
  final StepCompletedCallback onCompleted;
  
  const SignupBasicInfoScreen({
    Key? key,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<SignupBasicInfoScreen> createState() => _SignupBasicInfoScreenState();
}

class _SignupBasicInfoScreenState extends State<SignupBasicInfoScreen> {
  // 기존 SignupStepOneBasicInfoScreen 코드와 동일
  // handleNextButton() 메서드만 수정
  
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  DateTime? selectedDate;

  void handleNextButton() {
    // 유효성 검사 로직 (기존과 동일)
    
    // 검증 통과 시 다음 단계로 데이터 전달
    widget.onCompleted({
      'nickname': nicknameController.text,
      'birthdate': birthdateController.text,
      'phone': phoneController.text,
      'selectedDate': selectedDate,
    });
  }

  @override
  Widget build(BuildContext context) {
    // 기존 UI 코드와 동일 (간략화)
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('기본 정보 입력 화면'),
            ElevatedButton(
              onPressed: handleNextButton,
              child: Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}

// 프로필 사진 입력 화면 (수정된 버전)
class SignupProfilePhotoScreen extends StatefulWidget {
  final StepCompletedCallback onCompleted;
  
  const SignupProfilePhotoScreen({
    Key? key,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<SignupProfilePhotoScreen> createState() => _SignupProfilePhotoScreenState();
}

class _SignupProfilePhotoScreenState extends State<SignupProfilePhotoScreen> {
  List<String> uploadedPhotos = [];
  bool isFaceVerified = false;

  void handleNextButton() {
    widget.onCompleted({
      'photos': uploadedPhotos,
      'faceVerified': isFaceVerified,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('프로필 사진 입력 화면'),
            ElevatedButton(
              onPressed: handleNextButton,
              child: Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}

// 자기소개 입력 화면 (수정된 버전)
class SignupSelfIntroductionScreen extends StatefulWidget {
  final StepCompletedCallback onCompleted;
  
  const SignupSelfIntroductionScreen({
    Key? key,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<SignupSelfIntroductionScreen> createState() => _SignupSelfIntroductionScreenState();
}

class _SignupSelfIntroductionScreenState extends State<SignupSelfIntroductionScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController greetingController = TextEditingController();
  String? selectedBodyType;
  String? selectedMbti;
  List<String> selectedLanguages = [];
  bool hasVoiceGreeting = false;

  void handleComplete() {
    widget.onCompleted({
      'height': heightController.text,
      'bodyType': selectedBodyType,
      'nationality': '대한민국',
      'mbti': selectedMbti,
      'languages': selectedLanguages,
      'greeting': greetingController.text,
      'voiceGreeting': hasVoiceGreeting,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('자기소개 입력 화면'),
            ElevatedButton(
              onPressed: handleComplete,
              child: Text('회원가입 완료'),
            ),
          ],
        ),
      ),
    );
  }
}