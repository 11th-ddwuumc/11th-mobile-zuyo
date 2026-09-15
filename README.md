# UMC 11th Mobile · zuyo

UMC 11기 모바일 파트 주차별 학습 및 미션 제출 저장소입니다.

## 제출 방식

1. `main`에서 주차별 브랜치(`feat/week0`, `feat/week1` 등)를 생성합니다.
2. 해당 주차의 학습 내용과 미션 코드를 커밋합니다.
3. `main`을 대상으로 Pull Request를 생성하고 제출 양식을 작성합니다.

## 저장소 구성

- `.github/pull_request_template.md`: 주차별 PR 제출 양식
- `.coderabbit.yaml`: 한국어 자동 코드 리뷰 설정
- `movielog/`: Flutter 앱 및 Dart 연습 코드 (주차별 브랜치에서 추가)

## 앱 실행

앱 코드가 포함된 브랜치에서 Flutter SDK를 설치한 뒤 실행합니다.

```sh
cd movielog
flutter pub get
flutter run
```

## 코드 리뷰

CodeRabbit을 저장소에 연결하면 PR 자동 리뷰에 한국어 설정이 적용됩니다.
