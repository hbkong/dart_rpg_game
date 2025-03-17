# Today I Learned (TIL)

## Dart 프로그래밍 언어 학습

오늘 Dart 프로그래밍 언어를 사용하여 텍스트 기반 RPG 게임을 개발하면서 다음과 같은 내용을 배웠습니다:

### 1. Dart의 파일 입출력 처리

Dart에서 파일 입출력을 처리하는 방법을 배웠습니다. `dart:io` 라이브러리를 사용하여 파일을 읽고 쓰는 방법을 익혔습니다.

```dart
import 'dart:io';

// 파일 읽기
final file = File('data/characters.txt');
final contents = file.readAsStringSync();

// 파일 쓰기
file.writeAsStringSync('50,10,5');
```

### 2. 객체 지향 프로그래밍 적용

객체 지향 프로그래밍 원칙을 적용하여 코드를 구조화하는 방법을 배웠습니다:

- **캡슐화**: 각 클래스는 자신의 데이터와 기능을 캡슐화하여 관리합니다.
- **상속과 다형성**: 각 클래스는 자신의 역할에 맞는 메서드를 구현합니다.
- **추상화**: 복잡한 게임 로직을 간단한 인터페이스로 추상화했습니다.

### 3. 예외 처리

Dart에서 예외 처리를 하는 방법을 배웠습니다. try-catch 블록을 사용하여 파일 입출력 오류, 형식 오류 등을 처리했습니다.

```dart
try {
  // 위험한 코드
  final file = File('data/characters.txt');
  final contents = file.readAsStringSync();
  // 처리 로직
} catch (e) {
  print('오류 발생: $e');
  // 오류 처리 로직
}
```

### 4. 사용자 입력 검증

사용자 입력을 받고 검증하는 방법을 배웠습니다. 정규 표현식을 사용하여 입력값이 특정 패턴을 따르는지 확인했습니다.

```dart
final nameRegex = RegExp(r'^[a-zA-Z가-힣]+$');
if (!nameRegex.hasMatch(name)) {
  print('이름은 한글, 영문 대소문자만 포함할 수 있습니다.');
}
```

### 5. 테스트 코드 작성

Dart에서 테스트 코드를 작성하는 방법을 배웠습니다. `test` 패키지를 사용하여 단위 테스트를 작성하고 실행했습니다.

```dart
test('Character 초기화 테스트', () {
  expect(character.name, 'TestCharacter');
  expect(character.health, greaterThanOrEqualTo(50));
  expect(character.attack, 10);
  expect(character.defense, 5);
});
```

## 경험치 및 레벨 시스템 구현하기

### 학습 내용

오늘은 RPG 게임에 경험치 및 레벨 시스템을 구현하는 방법을 배웠습니다. 이 시스템은 게임에 진행감과 성장 요소를 추가하여 플레이어에게 더 큰 만족감을 줄 수 있습니다.

### 구현 방법

1. **Character 클래스 확장**
   - 경험치, 레벨, 스탯 포인트 등의 속성 추가
   - 경험치 획득 및 레벨업 메서드 구현
   - 스탯 포인트 분배 메서드 구현
   - 캐릭터 데이터 저장 및 불러오기 기능 추가

2. **Monster 클래스 확장**
   - 경험치 보상 속성 추가
   - 몬스터의 체력과 공격력에 비례하여 경험치 보상 설정

3. **Game 클래스 확장**
   - 몬스터 처치 시 경험치 획득 로직 추가
   - 스탯 포인트 분배 인터페이스 구현
   - 캐릭터 데이터 저장 및 불러오기 기능 통합

### 경험치 계산 방식

경험치 보상은 몬스터의 체력과 공격력에 비례하여 계산됩니다:
```dart
experienceReward = (health * 0.5 + maxAttackPower * 2).round();
```

이 공식은 몬스터의 체력에 0.5를 곱하고, 최대 공격력에 2를 곱한 후 합산하여 경험치 보상을 결정합니다. 이렇게 하면 강한 몬스터일수록 더 많은 경험치를 제공합니다.

### 레벨업 시스템

레벨업은 다음과 같은 방식으로 구현했습니다:
```dart
void checkLevelUp() {
  while (experience >= experienceToNextLevel) {
    // 레벨업
    level++;
    experience -= experienceToNextLevel;
    statPoints += 3; // 레벨업 시 3개의 스탯 포인트 획득
    
    // 다음 레벨까지 필요한 경험치 증가 (레벨에 따라 증가)
    experienceToNextLevel = (experienceToNextLevel * 1.5).round();
    
    print('축하합니다! $name이(가) 레벨 $level이(가) 되었습니다!');
    print('스탯 포인트를 $statPoints개 보유하고 있습니다.');
  }
}
```

이 메서드는 현재 경험치가 다음 레벨에 필요한 경험치 이상인 경우 레벨업을 수행합니다. 레벨업 시 다음과 같은 작업이 이루어집니다:
- 레벨 증가
- 경험치 차감
- 스탯 포인트 획득
- 다음 레벨까지 필요한 경험치 증가 (1.5배씩)

### 스탯 포인트 분배

스탯 포인트는 다음과 같은 방식으로 분배할 수 있습니다:
```dart
bool distributeStatPoints(String statType, int points) {
  if (points <= 0 || points > statPoints) {
    print('유효하지 않은 포인트 수입니다.');
    return false;
  }
  
  switch (statType.toLowerCase()) {
    case 'health':
    case '체력':
      health += points * 5; // 체력은 포인트당 5 증가
      print('체력이 ${points * 5} 증가했습니다. 현재 체력: $health');
      break;
    case 'attack':
    case '공격력':
      attack += points; // 공격력은 포인트당 1 증가
      print('공격력이 $points 증가했습니다. 현재 공격력: $attack');
      break;
    case 'defense':
    case '방어력':
      defense += points; // 방어력은 포인트당 1 증가
      print('방어력이 $points 증가했습니다. 현재 방어력: $defense');
      break;
    default:
      print('유효하지 않은 스탯 유형입니다. (체력, 공격력, 방어력 중 선택)');
      return false;
  }
  
  statPoints -= points;
  return true;
}
```

이 메서드는 스탯 유형과 포인트 수를 받아 해당 스탯을 증가시킵니다. 각 스탯별로 증가량이 다릅니다:
- 체력: 포인트당 5 증가
- 공격력: 포인트당 1 증가
- 방어력: 포인트당 1 증가

### 데이터 저장 및 불러오기

캐릭터 데이터는 다음과 같은 형식으로 저장됩니다:
```dart
String toSaveString() {
  return '$health,$attack,$defense,$level,$experience,$experienceToNextLevel,$statPoints,$hasUsedItem';
}
```

이 문자열은 캐릭터의 모든 중요한 속성을 포함하며, 게임을 다시 시작할 때 불러올 수 있습니다:
```dart
void loadFromString(String data) {
  final parts = data.split(',');
  if (parts.length >= 7) {
    health = int.parse(parts[0]);
    attack = int.parse(parts[1]);
    defense = int.parse(parts[2]);
    level = int.parse(parts[3]);
    experience = int.parse(parts[4]);
    experienceToNextLevel = int.parse(parts[5]);
    statPoints = int.parse(parts[6]);
    hasUsedItem = parts.length > 7 ? parts[7] == 'true' : false;
  }
}
```

### 배운 점

1. **게임 진행감 설계**: 경험치와 레벨 시스템은 플레이어에게 진행감과 성취감을 제공합니다.
2. **밸런싱의 중요성**: 경험치 획득량, 레벨업에 필요한 경험치, 스탯 포인트 분배 비율 등을 적절히 조절하는 것이 중요합니다.
3. **데이터 지속성**: 게임 데이터를 저장하고 불러오는 기능은 플레이어의 진행 상황을 유지하는 데 중요합니다.
4. **사용자 인터페이스 설계**: 스탯 포인트 분배와 같은 복잡한 기능은 사용자가 이해하기 쉬운 인터페이스가 필요합니다.

### 트러블 슈팅

1. **레벨업 루프**: 경험치가 충분히 많으면 여러 번 레벨업할 수 있도록 while 루프를 사용했습니다.
2. **스탯 변경**: 기존에 final로 선언된 attack과 defense 속성을 변경 가능하도록 수정했습니다.
3. **데이터 검증**: 저장된 데이터를 불러올 때 데이터 형식이 올바른지 검증하는 로직을 추가했습니다.

### 앞으로의 개선 방향

1. **더 다양한 스탯**: 현재는 체력, 공격력, 방어력만 있지만, 추가적인 스탯(예: 민첩성, 지능 등)을 추가할 수 있습니다.
2. **스킬 시스템**: 레벨업 시 새로운 스킬을 배울 수 있는 시스템을 추가할 수 있습니다.
3. **클래스 시스템**: 캐릭터 클래스(전사, 마법사, 궁수 등)를 추가하여 다양한 플레이 스타일을 제공할 수 있습니다.
4. **퀘스트 시스템**: 경험치를 얻는 방법으로 몬스터 처치 외에도 퀘스트 완료를 추가할 수 있습니다. 