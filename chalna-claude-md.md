# CLAUDE.md - 찰나 (Chalna) 반응속도 테스트

## 프로젝트 개요

반응속도를 측정하고 기록하는 테스트 앱. 다양한 게임 모드와 랭킹 시스템으로 재미 요소 추가. Flutter로 개발하여 Android/iOS 동시 지원.

### 핵심 컨셉

- 화면 색상 변화 감지 후 탭하는 시간 측정
- 밀리초(ms) 단위로 정밀 측정
- 결과 공유로 바이럴 유도

## 기술 스택

- **Framework**: Flutter 3.x (최신 stable)
- **Language**: Dart
- **State Management**: Riverpod 2.x
- **Local Storage**: SharedPreferences (설정), Hive (기록 데이터)
- **Ads**: google_mobile_ads (AdMob)
- **Share**: share_plus (결과 공유)
- **Architecture**: Clean Architecture + Feature-first 구조

## 프로젝트 구조

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_config.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── services/
│       ├── ad_service.dart
│       ├── share_service.dart
│       └── haptic_service.dart
├── features/
│   ├── home/
│   │   └── presentation/
│   │       └── screens/
│   │           └── home_screen.dart
│   ├── game/
│   │   ├── data/
│   │   │   └── game_repository.dart
│   │   ├── domain/
│   │   │   ├── game_state.dart
│   │   │   └── game_mode.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── game_screen.dart
│   │       │   └── result_screen.dart
│   │       ├── widgets/
│   │       │   ├── tap_area.dart
│   │       │   ├── countdown_overlay.dart
│   │       │   └── result_card.dart
│   │       └── providers/
│   │           └── game_provider.dart
│   ├── records/
│   │   ├── data/
│   │   │   └── records_repository.dart
│   │   ├── domain/
│   │   │   └── record_model.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── records_screen.dart
│   │       └── providers/
│   │           └── records_provider.dart
│   └── settings/
│       ├── data/
│       │   └── settings_repository.dart
│       ├── domain/
│       │   └── settings_model.dart
│       └── presentation/
│           ├── screens/
│           │   └── settings_screen.dart
│           └── providers/
│               └── settings_provider.dart
└── shared/
    └── widgets/
        ├── main_shell.dart        # 하단 탭 네비게이션 + 글래스모피즘 배경
        ├── glass_card.dart        # 글래스모피즘 카드/버튼 위젯
        ├── custom_button.dart
        └── ad_banner_widget.dart
```

## 코딩 컨벤션

### Dart/Flutter 규칙

- 파일명: snake_case (예: game_screen.dart)
- 클래스명: PascalCase (예: GameScreen)
- 변수/함수명: camelCase (예: startGame)
- 상수: lowerCamelCase 또는 SCREAMING_CAPS
- private 멤버: underscore prefix (_privateVar)

### 위젯 작성 규칙

- StatelessWidget 우선 사용
- 상태 필요시 ConsumerWidget (Riverpod) 사용
- 위젯은 단일 책임 원칙 준수
- 100줄 초과시 분리 고려

### 주석 규칙

- 모든 public API에 문서 주석 (///) 작성
- TODO 주석 형식: `// TODO(작성자): 설명`
- 복잡한 로직에 설명 주석 추가

## 주요 기능 명세

### 1. 게임 모드

- **클래식 모드**: 빨간→초록 색상 변화 감지 후 탭
- **랜덤 모드**: 랜덤한 대기 시간 (1~5초)
- **연속 모드**: 5회 연속 측정 후 평균값
- **사운드 모드**: 소리 신호에 반응 (P2)

### 2. 결과 화면

- 반응 시간 (ms) 대형 표시
- 등급 부여 (번개급, 빠름, 보통, 느림 등)
- 역대 최고 기록 비교
- SNS 공유 버튼

### 3. 기록 화면

- 최고 기록 (개인 베스트)
- 최근 10회 기록 리스트
- 평균 반응 시간
- 모드별 기록 분리

### 4. 설정

- 진동 피드백 on/off
- 사운드 on/off
- 다크모드 지원
- 기록 초기화

### 5. 광고

- 배너 광고: 기록 화면 하단, 설정 화면 하단
- 메인/게임 화면은 광고 없이 깔끔하게 유지

## UI/네비게이션 아키텍처

### 네비게이션 구조

- **MainShell** (`shared/widgets/main_shell.dart`): 앱의 메인 쉘 위젯
  - `IndexedStack`으로 홈/기록/설정 3개 탭을 관리
  - 글래스모피즘 스타일의 플로팅 하단 탭 바 (`BackdropFilter` 블러 처리)
  - 라벤더~바이올렛 그라데이션 배경 (다크 모드 대응)
- **GoRouter**: `/` (MainShell), `/game` (GameScreen) 2개 라우트
- 홈/기록/설정은 탭 전환으로 이동, 게임 화면만 `context.push('/game')`으로 이동

### 디자인 시스템

- **글래스모피즘**: 반투명 카드 + `BackdropFilter` 블러 + 그라데이션 배경
- 각 화면의 `Scaffold`는 `backgroundColor: Colors.transparent` (MainShell 배경이 보이도록)
- 카드/리스트 아이템: `ClipRRect` + `BackdropFilter` + 반투명 Container
- 다크 모드: 투명도 값만 조절하여 대응 (밝은 모드 0.5~0.6, 다크 모드 0.06~0.08)

## 의존성 패키지

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  shared_preferences: ^2.2.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  google_mobile_ads: ^4.0.0
  share_plus: ^7.0.0
  go_router: ^12.0.0
  audioplayers: ^5.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  hive_generator: ^2.0.0
  build_runner: ^2.4.0
```

## 빌드 및 실행 명령어

```bash
# 의존성 설치
flutter pub get

# Hive 어댑터 생성
flutter pub run build_runner build

# 개발 모드 실행
flutter run

# 릴리즈 빌드 (Android)
flutter build apk --release

# 릴리즈 빌드 (iOS)
flutter build ios --release
```

## 반응 시간 측정 로직

```dart
// 핵심 측정 로직
DateTime? _signalTime;

void onSignalShow() {
  _signalTime = DateTime.now();
}

void onUserTap() {
  if (_signalTime == null) {
    // 너무 빨리 탭함 (신호 전)
    return handleEarlyTap();
  }
  final reactionTime = DateTime.now().difference(_signalTime!);
  final milliseconds = reactionTime.inMilliseconds;
  // 결과 처리
}
```

## 등급 시스템

| 등급 | 반응 시간 | 설명 |
| --- | --- | --- |
| ⚡ 번개 | < 150ms | 프로게이머급 |
| 🚀 매우 빠름 | 150-200ms | 상위 10% |
| 🏃 빠름 | 200-250ms | 평균 이상 |
| 🚶 보통 | 250-300ms | 평균 |
| 🐢 느림 | > 300ms | 연습 필요 |

## 중요 참고사항

1. 정확한 시간 측정을 위해 `DateTime.now()` 대신 `Stopwatch` 클래스 고려
2. 너무 빠른 탭(신호 전 탭) 감지 및 처리 필요
3. 백그라운드 진입 시 게임 일시정지 처리
4. 공유 이미지 생성 시 `RepaintBoundary` + `RenderRepaintBoundary` 활용

## Git 커밋 메시지 규칙

```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 수정
style: 코드 포맷팅
refactor: 코드 리팩토링
test: 테스트 코드
chore: 빌드, 설정 파일 수정
```
