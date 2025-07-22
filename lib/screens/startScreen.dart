import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../styles/common_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with TickerProviderStateMixin {
  final List<String> _texts = [
    '낯선 누군가와 함께\n따스한 이야기를 나누어보세요',
    '한국인 남자친구와\n전세계의 여자친구가 대화를 나누어요',
    '매일 새로운 인연과\n무료로 대화할 수 있어요',
  ];
  int _currentDotIndex = 0;
  bool _showText = true;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _showText = true;
    _fadeController.value = 1.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startFadeRotation();
    });
  }

  void _startFadeRotation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _fadeController.reverse(); // Fade out (0.5s)
      setState(() => _showText = false); // 공백 (0.5s)
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _currentDotIndex = (_currentDotIndex + 1) % _texts.length;
        _showText = true;
      });
      await _fadeController.forward(); // Fade in (0.5s)
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    if (!(Platform.isIOS || Platform.isAndroid)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('지원하지 않는 플랫폼'),
          content: const Text('구글 로그인은 모바일(iOS/Android)에서만 지원됩니다.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('확인'))],
        ),
      );
      return;
    }
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // 로그인 취소
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/signupProfileName');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('구글 로그인 실패'),
          content: Text(e.toString()),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('확인'))],
        ),
      );
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/signupProfileName');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('애플 로그인 실패'),
          content: Text(e.toString()),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('확인'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E0FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 342,
                // height: 380, // Figma: image_container, scaleMode: FIT → Hug height, BoxFit.fit
                child: AspectRatio(
                  aspectRatio: 342 / 380,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/image_container.png',
                      width: 342,
                      fit: BoxFit.fitHeight, // Figma: scaleMode: FIT
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // main_content (FRAME, Hug height)
                        Container(
                          width: 342,
                          // height: Hug (생략)
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // text_container (FRAME, Hug height)
                              Container(
                                width: 340,
                                // height: Hug (생략)
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 340,
                                      height: 48, // Fixed
                                      child: FadeTransition(
                                        opacity: _fadeAnimation,
                                        child: Text(
                                          _texts[_currentDotIndex],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 16, // 16으로 되돌림
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFA87F94), // #A87F94로 변경
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Container(
                                      width: 340,
                                      height: 8, // Fixed
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(3, (index) {
                                          bool isActive = index == _currentDotIndex;
                                          return Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 4),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 300),
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isActive 
                                                  ? Colors.white.withOpacity(1.0)
                                                  : const Color(0xFFDDC2F6), // dot_off는 #DDC2F6, 100% 불투명
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // button_container (FRAME, Fixed height)
                              Container(
                                width: 342,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/login_email');
                                      },
                                      child: Container(
                                        width: 342,
                                        height: 48, // Fixed
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '이메일로 시작하기',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 13, // Figma와 동일하게 13px로 명확히 지정
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF333333),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // social_buttons_wrapper (FRAME, Hug height)
                                    Container(
                                      width: 342,
                                      // height: Hug (생략)
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomButton(
                                            label: '구글로 시작하기',
                                            iconLeft: Image.asset(
                                              'assets/icon/24/google.png',
                                              width: 24,
                                              height: 24,
                                            ),
                                            color: ButtonColorTheme.dark,
                                            height: 48, // Fixed
                                            borderRadius: 4,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            onPressed: () {
                                              _signInWithGoogle(context);
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          CustomButton(
                                            label: '애플로 시작하기',
                                            iconLeft: Image.asset(
                                              'assets/icon/24/apple.png',
                                              width: 24,
                                              height: 24,
                                            ),
                                            color: ButtonColorTheme.dark,
                                            height: 48, // Fixed
                                            borderRadius: 4,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            onPressed: () {
                                              _signInWithApple(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/join_email');
                                      },
                                      child: Container(
                                        width: 342,
                                        // height: Hug (생략)
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'KUPID에 처음이신가요?',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF888888),
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 