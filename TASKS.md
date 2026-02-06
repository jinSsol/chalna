# 찰나 (Chalna) 개발 태스크

## 완료된 작업

### 프로젝트 설정
- [x] Flutter 프로젝트 생성 (`com.chalna.chalna`)
- [x] 의존성 패키지 설정 (Riverpod, Hive, GoRouter, AdMob 등)
- [x] Android NDK 버전 설정 (27.0.12077973)
- [x] AdMob 테스트 ID 설정 (Android/iOS)

### Core 모듈
- [x] `app_colors.dart` - 앱 색상 상수 정의
- [x] `app_strings.dart` - 문자열 상수 정의
- [x] `app_config.dart` - 앱 설정 상수 정의
- [x] `app_theme.dart` - 라이트/다크 테마 정의
- [x] `ad_service.dart` - AdMob 광고 서비스
- [x] `share_service.dart` - 결과 공유 서비스
- [x] `haptic_service.dart` - 진동 피드백 서비스

### Features

#### Home (홈 화면)
- [x] `home_screen.dart` - 메인 홈 화면 UI
- [x] 게임 모드 선택 (클래식/랜덤/연속)
- [x] 최고 기록 표시
- [x] 설정/기록 화면 네비게이션

#### Game (게임)
- [x] `game_mode.dart` - 게임 모드 enum
- [x] `game_state.dart` - 게임 상태 모델
- [x] `game_repository.dart` - 게임 데이터 레포지토리
- [x] `game_provider.dart` - 게임 상태 관리 (Riverpod)
- [x] `game_screen.dart` - 게임 화면
- [x] `tap_area.dart` - 탭 영역 위젯
- [x] `result_card.dart` - 결과 카드 위젯
- [x] `continuous_result_card.dart` - 연속 모드 결과 카드

#### Records (기록)
- [x] `record_model.dart` - 기록 데이터 모델 (Hive)
- [x] `records_repository.dart` - 기록 저장소
- [x] `records_provider.dart` - 기록 상태 관리
- [x] `records_screen.dart` - 기록 화면 UI

#### Settings (설정)
- [x] `settings_model.dart` - 설정 데이터 모델
- [x] `settings_repository.dart` - 설정 저장소 (SharedPreferences)
- [x] `settings_provider.dart` - 설정 상태 관리
- [x] `settings_screen.dart` - 설정 화면 UI

### Shared
- [x] `custom_button.dart` - 커스텀 버튼 위젯
- [x] `ad_banner_widget.dart` - 배너 광고 위젯 (기록 화면에서 사용)
- [x] `glass_card.dart` - 글래스모피즘 카드/버튼 위젯
- [x] `main_shell.dart` - 하단 탭 네비게이션 쉘 (홈/기록/설정)

### 앱 진입점
- [x] `main.dart` - 앱 초기화 및 실행
- [x] `app.dart` - 앱 설정 및 라우팅 (MainShell + Game)

### UI 리디자인
- [x] 글래스모피즘 UI 적용 (반투명 카드 + 블러 + 그라데이션 배경)
- [x] 하단 탭 네비게이션 (홈/기록/설정) - 플로팅 글래스 스타일
- [x] 홈 화면 글래스모피즘 적용
- [x] 기록 화면 글래스모피즘 적용 (AppBar 제거, 탭 레이아웃)
- [x] 설정 화면 글래스모피즘 적용 (AppBar 제거, 탭 레이아웃)
- [x] 다크 모드 글래스 투명도 대응

### 광고 시스템 개선
- [x] 전면 광고(Interstitial Ad) 추가 - 게임 3회 완료마다 노출
- [x] AdService에 전면 광고 로드/표시 로직 추가
- [x] AppConfig에 전면 광고 테스트 ID 및 간격 설정 추가
- [x] 설정 화면 배너 광고 제거 (기록 화면에만 배너 유지)

---

## 진행하면 좋을 작업들

### P0 (필수)

#### 테스트 및 디버깅
- [ ] 실제 기기에서 테스트 (Android/iOS)
- [ ] 반응 시간 측정 정확도 검증
- [ ] 백그라운드 진입/복귀 시 동작 확인
- [ ] 다양한 화면 크기 대응 확인

#### 광고 설정
- [ ] 실제 AdMob 앱 ID 발급 및 적용
- [ ] 실제 광고 단위 ID 발급 및 적용
- [ ] 광고 테스트 (실제 환경)

#### 스토어 출시 준비
- [ ] 앱 아이콘 디자인 및 적용
- [ ] 스플래시 화면 디자인
- [ ] 앱 스크린샷 제작
- [ ] 개인정보처리방침 작성
- [ ] 앱 설명 작성

### P1 (권장)

#### UI/UX 개선
- [x] 애니메이션 효과 추가 (결과 표시, 화면 전환)
- [ ] 로딩 인디케이터 개선
- [ ] 빈 상태 화면 개선
- [ ] 온보딩/튜토리얼 화면

#### 기능 개선
- [ ] 사운드 효과 추가 (신호음, 결과음)
- [ ] 결과 이미지 생성 및 공유 (RepaintBoundary 활용)
- [ ] 기록 필터링 (모드별, 기간별)
- [ ] 통계 차트 추가 (기록 추이)

#### 코드 품질
- [ ] 단위 테스트 작성
- [ ] 위젯 테스트 작성
- [ ] 에러 핸들링 강화
- [ ] 로깅 시스템 추가

### P2 (선택)

#### 추가 기능
- [ ] 사운드 모드 (소리 신호에 반응)
- [ ] 업적/도전과제 시스템
- [ ] 온라인 랭킹 (Firebase 연동)
- [ ] 친구와 대결 기능
- [ ] 일일 챌린지

#### 수익화
- [ ] 프리미엄 버전 (광고 제거)
- [ ] 인앱 결제 연동
- [x] 전면 광고 추가 (3회 게임마다 노출)

#### 국제화
- [ ] 다국어 지원 (영어, 일본어 등)
- [ ] 지역별 랭킹

---

## 알려진 이슈

- [ ] NDK 경고 메시지 (빌드에는 영향 없음)
- [ ] 일부 패키지 최신 버전 업데이트 가능

---

## 실행 명령어

```bash
# 의존성 설치
flutter pub get

# 분석
flutter analyze

# 개발 모드 실행
flutter run

# 릴리즈 빌드 (Android)
flutter build apk --release

# 릴리즈 빌드 (iOS)
flutter build ios --release
```

---

## 참고 문서

- [CLAUDE.md](./chalna-claude-md.md) - 개발 가이드
- [README.md](./chalna-readme-md.md) - 프로젝트 소개
- [PRD.md](./chalna-prd-md.md) - 제품 요구사항
