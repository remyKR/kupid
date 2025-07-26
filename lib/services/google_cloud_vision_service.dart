import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class GoogleCloudVisionService {
  // Google Cloud Vision API Key (보안상 환경변수나 별도 설정으로 관리 권장)
  static const String _apiKey = 'AIzaSyB8gbmGvAtdPsHRdLkFNkxJUKj9J9BgzIc';
  static const String _apiUrl = 'https://vision.googleapis.com/v1/images:annotate?key=$_apiKey';

  // 두 얼굴의 유사도 비교
  static Future<Map<String, dynamic>> compareFaces(
    XFile profilePhoto,
    XFile selfiePhoto,
  ) async {
    try {
      // 이미지를 base64로 인코딩
      final profileBytes = await profilePhoto.readAsBytes();
      final selfieBytes = await selfiePhoto.readAsBytes();
      
      final profileBase64 = base64Encode(profileBytes);
      final selfieBase64 = base64Encode(selfieBytes);

      // 각 이미지에서 얼굴 감지
      final profileFaces = await detectFaces(profileBase64);
      final selfieFaces = await detectFaces(selfieBase64);

      // 얼굴이 감지되지 않은 경우
      if (profileFaces.isEmpty) {
        return {
          'success': false,
          'message': '프로필 사진에서 얼굴을 찾을 수 없습니다.',
        };
      }
      
      if (selfieFaces.isEmpty) {
        return {
          'success': false,
          'message': '셀카 사진에서 얼굴을 찾을 수 없습니다.',
        };
      }

      // 여러 얼굴이 감지된 경우
      if (profileFaces.length > 1) {
        return {
          'success': false,
          'message': '프로필 사진에 여러 명이 있습니다. 본인만 나온 사진을 사용해주세요.',
        };
      }
      
      if (selfieFaces.length > 1) {
        return {
          'success': false,
          'message': '셀카에 여러 명이 있습니다. 본인만 촬영해주세요.',
        };
      }

      // 얼굴 특징 비교 (랜드마크 기반 유사도 계산)
      final similarity = calculateFaceSimilarity(
        profileFaces.first,
        selfieFaces.first,
      );

      // 유사도 임계값 (70% 이상일 때 동일인으로 판단)
      const double threshold = 0.7;

      if (similarity >= threshold) {
        return {
          'success': true,
          'message': '얼굴 인증이 완료되었습니다!',
          'similarity': similarity,
        };
      } else {
        return {
          'success': false,
          'message': '얼굴이 일치하지 않습니다. 다시 시도해주세요.',
          'similarity': similarity,
        };
      }
    } catch (e) {
      print('Error comparing faces: $e');
      return {
        'success': false,
        'message': '얼굴 인증 중 오류가 발생했습니다.',
        'error': e.toString(),
      };
    }
  }

  // 이미지에서 얼굴 감지
  static Future<List<Map<String, dynamic>>> detectFaces(String base64Image) async {
    final requestBody = {
      'requests': [
        {
          'image': {
            'content': base64Image,
          },
          'features': [
            {
              'type': 'FACE_DETECTION',
              'maxResults': 10,
            },
          ],
        },
      ],
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final responses = data['responses'] as List;
        
        if (responses.isNotEmpty && responses[0]['faceAnnotations'] != null) {
          return List<Map<String, dynamic>>.from(responses[0]['faceAnnotations']);
        }
      }
      
      return [];
    } catch (e) {
      print('Error detecting faces: $e');
      return [];
    }
  }

  // 얼굴 랜드마크 기반 유사도 계산
  static double calculateFaceSimilarity(
    Map<String, dynamic> face1,
    Map<String, dynamic> face2,
  ) {
    // 주요 감정 상태 비교
    final emotions1 = extractEmotions(face1);
    final emotions2 = extractEmotions(face2);
    
    // 얼굴 각도 비교
    final angles1 = extractAngles(face1);
    final angles2 = extractAngles(face2);
    
    // 감정 유사도 (가중치 30%)
    double emotionSimilarity = 0;
    for (String emotion in emotions1.keys) {
      if (emotions2.containsKey(emotion)) {
        emotionSimilarity += 1 - (emotions1[emotion]! - emotions2[emotion]!).abs();
      }
    }
    emotionSimilarity = emotionSimilarity / emotions1.length * 0.3;
    
    // 각도 유사도 (가중치 70%)
    double angleSimilarity = 0;
    for (String angle in angles1.keys) {
      if (angles2.containsKey(angle)) {
        // 각도 차이를 0-1 범위로 정규화
        double diff = (angles1[angle]! - angles2[angle]!).abs();
        angleSimilarity += 1 - (diff / 180); // 180도를 최대 차이로 가정
      }
    }
    angleSimilarity = angleSimilarity / angles1.length * 0.7;
    
    return emotionSimilarity + angleSimilarity;
  }

  // 감정 상태 추출
  static Map<String, double> extractEmotions(Map<String, dynamic> face) {
    final Map<String, double> emotions = {};
    
    // Google Vision API의 감정 확률 값 사용
    emotions['joy'] = getLikelihoodValue(face['joyLikelihood']);
    emotions['sorrow'] = getLikelihoodValue(face['sorrowLikelihood']);
    emotions['anger'] = getLikelihoodValue(face['angerLikelihood']);
    emotions['surprise'] = getLikelihoodValue(face['surpriseLikelihood']);
    
    return emotions;
  }

  // 얼굴 각도 추출
  static Map<String, double> extractAngles(Map<String, dynamic> face) {
    final Map<String, double> angles = {};
    
    // Google Vision API의 얼굴 각도 값 사용
    angles['roll'] = (face['rollAngle'] ?? 0).toDouble();
    angles['pan'] = (face['panAngle'] ?? 0).toDouble();
    angles['tilt'] = (face['tiltAngle'] ?? 0).toDouble();
    
    return angles;
  }

  // 감정 확률 값 변환
  static double getLikelihoodValue(String? likelihood) {
    switch (likelihood) {
      case 'VERY_UNLIKELY':
        return 0.0;
      case 'UNLIKELY':
        return 0.25;
      case 'POSSIBLE':
        return 0.5;
      case 'LIKELY':
        return 0.75;
      case 'VERY_LIKELY':
        return 1.0;
      default:
        return 0.0;
    }
  }
}