import 'package:test/test.dart';
import '../models/character.dart';
import '../models/monster.dart';

void main() {
  group('Character 클래스 테스트', () {
    late Character character;
    late Monster monster;
    
    setUp(() {
      character = Character('TestCharacter', 50, 10, 5);
      monster = Monster('TestMonster', 30, 20);
    });
    
    test('Character 초기화 테스트', () {
      expect(character.name, 'TestCharacter');
      expect(character.health, greaterThanOrEqualTo(50)); // 보너스 체력 가능성 고려
      expect(character.attack, 10);
      expect(character.defense, 5);
      expect(character.hasUsedItem, false);
    });
    
    test('attackMonster 메서드 테스트', () {
      final initialMonsterHealth = monster.health;
      character.attackMonster(monster);
      expect(monster.health, initialMonsterHealth - character.attack);
    });
    
    test('defend 메서드 테스트', () {
      final initialHealth = character.health;
      character.defend();
      expect(character.health, greaterThan(initialHealth)); // 체력 회복 확인
    });
    
    test('useItem 메서드 테스트', () {
      // 아이템 사용 전
      expect(character.hasUsedItem, false);
      
      // 아이템 사용
      final result = character.useItem();
      expect(result, true);
      expect(character.hasUsedItem, true);
      
      // 아이템 재사용 시도
      final secondResult = character.useItem();
      expect(secondResult, false);
    });
    
    test('attackWithItem 메서드 테스트', () {
      final initialMonsterHealth = monster.health;
      character.attackWithItem(monster);
      expect(monster.health, initialMonsterHealth - (character.attack * 2));
    });
  });
} 