#\!/bin/bash

# Kupid iOS 빌드 스크립트
echo "🚀 Kupid iOS 빌드 시작..."

# 1. Flutter 환경 확인
echo "📱 Flutter 환경 확인..."
flutter doctor

# 2. 의존성 정리 및 재설치
echo "🧹 캐시 및 의존성 정리..."
flutter clean
rm -rf ios/Pods ios/Podfile.lock
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner*

# 3. Flutter 의존성 재설치
echo "📦 Flutter 의존성 설치..."
flutter pub get

# 4. iOS CocoaPods 재설치
echo "🍎 CocoaPods 의존성 설치..."
cd ios && pod install && cd ..

# 5. 디바이스 확인
echo "📲 연결된 디바이스 확인..."
flutter devices

echo "✅ 빌드 준비 완료\!"
echo "이제 다음 중 하나를 선택하세요:"
echo "1. flutter run -d [DEVICE_ID] (Flutter 명령어)"
echo "2. Xcode에서 직접 빌드 (권장): open ios/Runner.xcworkspace"
EOF < /dev/null