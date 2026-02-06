# ⚡ 찰나 (Chalna) - 반응속도 테스트

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

당신의 반응속도는 몇 ms? 찰나의 순간을 측정하세요!

## 📱 스크린샷

<!-- TODO: 앱 스크린샷 추가 -->

## ✨ 주요 기능

- ⚡ **정밀 측정**: 밀리초(ms) 단위 반응속도 측정
- 🎮 **다양한 모드**: 클래식, 랜덤, 연속 모드
- 🏆 **등급 시스템**: 번개급부터 거북이까지 등급 부여
- 📊 **기록 관리**: 최고 기록, 평균, 히스토리 확인
- 📤 **결과 공유**: SNS에 결과 이미지 공유
- 🌙 **다크 모드**: 눈 편한 다크 테마 지원

## 🎯 게임 방법

1. **시작** 버튼을 누릅니다
2. 화면이 **빨간색**으로 변하면 기다립니다
3. **초록색**으로 바뀌는 순간 탭!
4. 당신의 반응속도가 측정됩니다

## 🏅 등급 시스템

| 등급 | 반응 시간 | 설명 |
| --- | --- | --- |
| ⚡ 번개 | < 150ms | 프로게이머급 |
| 🚀 매우 빠름 | 150-200ms | 상위 10% |
| 🏃 빠름 | 200-250ms | 평균 이상 |
| 🚶 보통 | 250-300ms | 평균 |
| 🐢 느림 | > 300ms | 연습 필요 |

## 🚀 시작하기

### 요구사항

- Flutter SDK 3.x 이상
- Dart SDK 3.x 이상
- Android Studio / VS Code
- Xcode (iOS 빌드 시)

### 설치

```bash
# 저장소 클론
git clone https://github.com/yourusername/chalna.git
cd chalna

# 의존성 설치
flutter pub get

# Hive 어댑터 생성
flutter pub run build_runner build --delete-conflicting-outputs

# 앱 실행
flutter run
```

### AdMob 설정

1. [AdMob](https://admob.google.com)에서 앱 등록
2. 앱 ID 및 광고 단위 ID 발급
3. 환경 설정:

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
```

**iOS** (`ios/Runner/Info.plist`):

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
```

## 📁 프로젝트 구조

```
lib/
├── main.dart              # 앱 진입점
├── app.dart               # 앱 설정 (GoRouter)
├── core/                  # 공통 유틸리티
├── features/              # 기능별 모듈
│   ├── home/             # 홈 화면
│   ├── game/             # 게임 로직
│   ├── records/          # 기록 관리
│   └── settings/         # 설정
└── shared/               # 공유 위젯
    └── widgets/
        ├── main_shell.dart   # 하단 탭 네비게이션 쉘
        ├── glass_card.dart   # 글래스모피즘 위젯
        └── ...
```

## 🛠️ 기술 스택

| 카테고리 | 기술 |
| --- | --- |
| Framework | Flutter |
| Language | Dart |
| State Management | Riverpod |
| Local Storage | SharedPreferences, Hive |
| Ads | Google Mobile Ads (AdMob) |
| Share | share_plus |
| Routing | GoRouter |

## 📝 개발 로드맵

- [x] 프로젝트 초기 설정
- [x] 홈 화면 UI
- [x] 클래식 모드 게임 로직
- [x] 결과 화면 + 등급 시스템
- [x] 기록 저장 및 조회
- [x] 연속 모드
- [x] 랜덤 모드
- [x] 결과 공유 기능
- [x] AdMob 연동
- [x] 다크 모드
- [x] 글래스모피즘 UI 리디자인
- [x] 하단 탭 네비게이션 (홈/기록/설정)

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

MIT License - 자세한 내용은 [LICENSE](LICENSE) 파일 참조

## 📧 문의

프로젝트 관련 문의사항이 있으시면 이슈를 등록해주세요.

---

⭐ 이 프로젝트가 도움이 되셨다면 Star를 눌러주세요!
