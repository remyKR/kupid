import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kupid/styles/common_styles.dart';
import 'package:kupid/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kupid/services/google_cloud_vision_service.dart';
import 'dart:io';
import 'signupSelfIntroduction.dart';

typedef StepCompletedCallback = void Function(Map<String, dynamic> data);

class SignupProfilePhotoScreen extends StatefulWidget {
  final StepCompletedCallback? onCompleted;
  
  const SignupProfilePhotoScreen({Key? key, this.onCompleted}) : super(key: key);

  @override
  State<SignupProfilePhotoScreen> createState() => _SignupProfilePhotoScreenState();
}

class _SignupProfilePhotoScreenState extends State<SignupProfilePhotoScreen> {
  List<XFile> uploadedPhotos = [];
  bool showFaceVerification = false;
  bool isFaceVerified = false;
  final ImagePicker imagePicker = ImagePicker();

  Future<void> startFaceVerification() async {
    // 프로필 사진이 없는 경우
    if (uploadedPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('먼저 프로필 사진을 업로드해주세요'),
          backgroundColor: Color(0xFFFF2058),
        ),
      );
      return;
    }

    // 바로 카메라 촬영 시작 (중간 다이얼로그 제거)
    final XFile? selfie = await imagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    
    if (selfie != null) {
      // 인증 중 로딩 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF2058),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '얼굴 인증 중...',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      
      try {
        // Google Cloud Vision API를 사용한 얼굴 비교
        final result = await GoogleCloudVisionService.compareFaces(
          uploadedPhotos.first, // 첫 번째 프로필 사진 사용
          selfie,
        );
        
        Navigator.pop(context); // 로딩 다이얼로그 닫기
        
        if (result['success'] == true) {
          setState(() {
            isFaceVerified = true;
          });
          
          // 성공 다이얼로그 표시
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Color(0xFF28A745),
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '인증 성공',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Color(0xFF28A745),
                    ),
                  ),
                ],
              ),
              content: Text(
                result['message'] ?? '얼굴 인증이 완료되었습니다!',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Color(0xFFFF2058),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.error,
                    color: Color(0xFFFF2058),
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '인증 실패',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Color(0xFFFF2058),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result['message'] ?? '얼굴 인증에 실패했습니다.',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                    ),
                  ),
                  if (result['similarity'] != null) ...[
                    SizedBox(height: 8),
                    Text(
                      '유사도: ${(result['similarity'] * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                  SizedBox(height: 8),
                  Text(
                    '다시 시도해보세요.',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Color(0xFFFF2058),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              '오류 발생',
              style: TextStyle(
                fontFamily: 'Pretendard',
                color: Color(0xFFFF2058),
              ),
            ),
            content: Text(
              '인증 중 오류가 발생했습니다. 다시 시도해주세요.',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '확인',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    color: Color(0xFFFF2058),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> handleImageUpload() async {
    if (uploadedPhotos.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('최대 10장까지 업로드 가능합니다'),
          backgroundColor: Color(0xFFFF2058),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('갤러리에서 선택'),
                onTap: () async {
                  Navigator.pop(context);
                  final List<XFile> images = await imagePicker.pickMultiImage();
                  if (images.isNotEmpty) {
                    setState(() {
                      for (var image in images) {
                        if (uploadedPhotos.length < 10) {
                          uploadedPhotos.add(image);
                        }
                      }
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('카메라로 촬영'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      uploadedPhotos.add(image);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('동영상 선택'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? video = await imagePicker.pickVideo(source: ImageSource.gallery);
                  if (video != null) {
                    setState(() {
                      uploadedPhotos.add(video);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
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
                        'Profile\nPhotos',
                        style: CommonStyles.poppinsBold40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '프로필 사진을 업로드해주세요 (1-10장)',
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

                  // 사진/동영상 업로드 영역
                  GestureDetector(
                    onTap: handleImageUpload,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFDDDDDD),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: uploadedPhotos.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 48,
                                  color: Color(0xFFAAAAAA),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '사진이나 동영상을 업로드하세요',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFAAAAAA),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '최대 10장, 동영상도 가능',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFCCCCCC),
                                  ),
                                ),
                              ],
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(8),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: uploadedPhotos.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xFFF5F5F5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '사진 ${index + 1}',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 12,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 본인 인증 섹션 (선택사항)
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
                              Icons.verified_user,
                              size: 20,
                              color: Color(0xFF28A745),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '본인 인증 (선택)',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            if (isFaceVerified) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Color(0xFF28A745),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '인증완료',
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
                          '프로필 사진과 본인 얼굴을 매칭하여 신뢰도를 높이세요',
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
                            label: isFaceVerified ? '인증 완료' : '얼굴 인증하기',
                            color: isFaceVerified ? ButtonColorTheme.bright : ButtonColorTheme.dark,
                            borderRadius: 4,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            onPressed: () {
                              if (isFaceVerified) {
                                // 인증 완료 상태에서 탭하면 3단계로 이동 (테스트용)
                                if (widget.onCompleted != null) {
                                  widget.onCompleted!({
                                    'photos': uploadedPhotos.map((photo) => photo.path).toList(),
                                    'faceVerified': isFaceVerified,
                                  });
                                } else {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => SignupSelfIntroductionScreen())
                                  );
                                }
                              } else {
                                // 얼굴 인증 시작
                                startFaceVerification();
                              }
                            },
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
                        if (uploadedPhotos.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('최소 1장의 사진을 업로드해주세요'),
                              backgroundColor: Color(0xFFFF2058),
                            ),
                          );
                          return;
                        }
                        
                        if (widget.onCompleted != null) {
                          widget.onCompleted!({
                            'photos': uploadedPhotos.map((photo) => photo.path).toList(),
                            'faceVerified': isFaceVerified,
                          });
                        } else {
                          // 단독 실행 시 다음 화면으로 이동
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => SignupSelfIntroductionScreen())
                          );
                        }
                      },
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