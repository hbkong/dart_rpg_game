import 'dart:math';
import 'character.dart';

class Monster {
  final String name;
  int health;
  final int maxAttackPower;
  late int attackPower; // late 키워드 추가
  int defense = 0; // 몬스터의 방어력은 0으로 초기화
  int turnCount = 0; // 턴 카운터 변수 추가
  final int maxDefense = 8; // 최대 방어력 제한
  late int experienceReward; // late 키워드 추가하여 초기화 지연
  
  Monster(this.name, this.health, this.maxAttackPower) {
    // 몬스터의 공격력은 캐릭터의 방어력보다 작을 수 없음
    // 실제 공격력은 battle 메서드에서 캐릭터의 방어력과 비교하여 설정
    attackPower = maxAttackPower;
    
    // 경험치 보상은 체력과 최대 공격력에 비례하여 설정
    experienceReward = (health * 0.5 + maxAttackPower * 2).round();
  }
  
  void attackCharacter(Character character) {
    // 캐릭터에게 데미지를 입힘
    // 데미지는 몬스터의 공격력에서 캐릭터의 방어력을 뺀 값 (최소 0)
    final damage = attackPower > character.defense ? attackPower - character.defense : 0;
    character.health -= damage;
    print('$name이(가) ${character.name}에게 $damage의 데미지를 입혔습니다.');
    
    // 턴 카운터 증가 및 방어력 증가 확인
    turnCount++;
    increaseDefense();
  }
  
  void showStatus() {
    // 몬스터의 현재 상태 출력
    print('$name - 체력: $health, 공격력: $attackPower, 방어력: $defense');
    print('처치 시 경험치: $experienceReward');
  }
  
  // 몬스터의 공격력을 설정하는 메서드 (캐릭터의 방어력과 비교하여 설정)
  void setAttackPower(int characterDefense) {
    // 랜덤 공격력 생성 (1부터 maxAttackPower까지)
    final random = Random();
    final randomAttack = random.nextInt(maxAttackPower) + 1;
    
    // 캐릭터의 방어력과 랜덤 공격력 중 최대값으로 설정
    attackPower = max(randomAttack, characterDefense);
  }
  
  // 3턴마다 방어력 증가 메서드 (최대 방어력 제한)
  void increaseDefense() {
    if (turnCount % 3 == 0 && defense < maxDefense) {
      defense += 2;
      if (defense > maxDefense) {
        defense = maxDefense;
      }
      print('$name의 방어력이 증가했습니다! 현재 방어력: $defense');
    }
  }
} 