import 'dart:math';
import 'monster.dart';

class Character {
  final String name;
  int health;
  int attack;
  int defense;
  bool hasUsedItem = false; // 아이템 사용 여부를 추적하는 변수
  
  // 경험치 및 레벨 시스템 관련 속성 추가
  int level = 1;
  int experience = 0;
  int experienceToNextLevel = 100; // 다음 레벨까지 필요한 경험치
  int statPoints = 0; // 레벨업 시 분배 가능한 스탯 포인트
  
  Character(this.name, this.health, this.attack, this.defense) {
    // 30% 확률로 보너스 체력 제공
    applyHealthBonus();
  }
  
  void attackMonster(Monster monster) {
    // 몬스터에게 데미지를 입힘
    final damage = attack > monster.defense ? attack - monster.defense : 0;
    monster.health -= damage;
    print('$name이(가) ${monster.name}에게 $damage의 데미지를 입혔습니다.');
  }
  
  void defend() {
    // 방어 시 특정 행동 수행
    // 방어 시 체력 회복 (1~5 사이의 랜덤 값)
    final random = Random();
    final healAmount = random.nextInt(5) + 1;
    health += healAmount;
    print('$name이(가) 방어 태세를 취하여 $healAmount 만큼 체력을 얻었습니다.');
  }
  
  bool useItem() {
    // 아이템 사용 기능
    if (hasUsedItem) {
      print('이미 아이템을 사용했습니다.');
      return false;
    }
    
    // 아이템 사용 - 한 턴 동안 공격력 두 배
    print('$name이(가) 특수 아이템을 사용하여 이번 턴에 공격력이 두 배가 됩니다!');
    hasUsedItem = true;
    return true;
  }
  
  void attackWithItem(Monster monster) {
    // 아이템을 사용한 공격 (공격력 두 배)
    final doubledAttack = attack * 2;
    final damage = doubledAttack > monster.defense ? doubledAttack - monster.defense : 0;
    monster.health -= damage;
    print('$name이(가) 강화된 공격으로 ${monster.name}에게 $damage의 데미지를 입혔습니다!');
  }
  
  void showStatus() {
    // 캐릭터의 현재 상태 출력
    print('$name - 레벨: $level, 체력: $health, 공격력: $attack, 방어력: $defense');
    print('경험치: $experience/$experienceToNextLevel');
    if (statPoints > 0) {
      print('사용 가능한 스탯 포인트: $statPoints');
    }
  }
  
  void applyHealthBonus() {
    // 30% 확률로 보너스 체력 제공
    final random = Random();
    if (random.nextDouble() < 0.3) { // 30% 확률
      health += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: $health');
    }
  }
  
  // 경험치 획득 메서드
  void gainExperience(int amount) {
    experience += amount;
    print('$name이(가) $amount 경험치를 획득했습니다!');
    
    // 레벨업 조건 확인
    checkLevelUp();
  }
  
  // 레벨업 확인 메서드
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
  
  // 스탯 포인트 분배 메서드
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
  
  // 캐릭터 정보를 문자열로 변환 (저장용)
  String toSaveString() {
    return '$name,$health,$attack,$defense,$level,$experience,$experienceToNextLevel,$statPoints,$hasUsedItem';
  }
  
  // 저장된 문자열에서 캐릭터 정보 복원
  void loadFromString(String data) {
    final parts = data.split(',');
    if (parts.length >= 8) {
      // 첫 번째 요소는 이름이므로 건너뜁니다 (이미 생성자에서 설정됨)
      health = int.parse(parts[1]);
      attack = int.parse(parts[2]);
      defense = int.parse(parts[3]);
      level = int.parse(parts[4]);
      experience = int.parse(parts[5]);
      experienceToNextLevel = int.parse(parts[6]);
      statPoints = int.parse(parts[7]);
      hasUsedItem = parts.length > 8 ? parts[8] == 'true' : false;
    }
  }
} 