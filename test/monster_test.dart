import 'package:test/test.dart';
import '../models/character.dart';
import '../models/monster.dart';

void main() {
  group('Monster 클래스 테스트', () {
    late Monster monster;
    late Character character;
    
    setUp(() {
      monster = Monster('TestMonster', 30, 20);
      character = Character('TestCharacter', 50, 10, 5);
    });
    
    test('Monster 초기화 테스트', () {
      expect(monster.name, 'TestMonster');
      expect(monster.health, 30);
      expect(monster.maxAttackPower, 20);
      expect(monster.defense, 0);
      expect(monster.turnCount, 0);
    });
    
    test('setAttackPower 메서드 테스트', () {
      monster.setAttackPower(character.defense);
      expect(monster.attackPower, greaterThanOrEqualTo(character.defense));
      expect(monster.attackPower, lessThanOrEqualTo(monster.maxAttackPower));
    });
    
    test('attackCharacter 메서드 테스트', () {
      final initialCharacterHealth = character.health;
      monster.setAttackPower(character.defense);
      monster.attackCharacter(character);
      
      // 데미지는 몬스터의 공격력에서 캐릭터의 방어력을 뺀 값
      final expectedDamage = monster.attackPower > character.defense ? monster.attackPower - character.defense : 0;
      expect(character.health, initialCharacterHealth - expectedDamage);
    });
    
    test('increaseDefense 메서드 테스트', () {
      // 초기 방어력
      expect(monster.defense, 0);
      
      // 첫 번째 턴
      monster.attackCharacter(character);
      expect(monster.turnCount, 1);
      expect(monster.defense, 0); // 아직 방어력 증가 없음
      
      // 두 번째 턴
      monster.attackCharacter(character);
      expect(monster.turnCount, 2);
      expect(monster.defense, 0); // 아직 방어력 증가 없음
      
      // 세 번째 턴 (3턴마다 방어력 증가)
      monster.attackCharacter(character);
      expect(monster.turnCount, 3);
      expect(monster.defense, 2); // 방어력 2 증가
      
      // 여섯 번째 턴까지 진행
      monster.attackCharacter(character);
      monster.attackCharacter(character);
      monster.attackCharacter(character);
      expect(monster.turnCount, 6);
      expect(monster.defense, 4); // 방어력 추가 2 증가
      
      // 방어력 최대값 테스트 (최대 8까지)
      for (int i = 0; i < 10; i++) {
        monster.attackCharacter(character);
      }
      expect(monster.defense, 8); // 최대 방어력 제한
    });
  });
} 