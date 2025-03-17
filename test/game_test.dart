import 'dart:io';
import 'package:test/test.dart';
import '../models/character.dart';
import '../models/monster.dart';
import '../game.dart';

void main() {
  // 테스트 데이터 파일 생성
  setUp(() {
    // 테스트용 data 디렉토리 생성
    Directory('data').createSync(recursive: true);
    
    // 테스트용 characters.txt 파일 생성
    File('data/characters.txt').writeAsStringSync('50,10,5');
    
    // 테스트용 monsters.txt 파일 생성
    File('data/monsters.txt').writeAsStringSync('TestMonster1,30,20\nTestMonster2,20,30\nTestMonster3,30,10');
  });
  
  // 테스트 후 파일 정리
  tearDown(() {
    // 테스트 결과 파일 삭제
    if (File('data/result.txt').existsSync()) {
      File('data/result.txt').deleteSync();
    }
  });
  
  group('Game 클래스 테스트', () {
    test('Game 클래스 초기화 테스트', () {
      // 테스트를 위한 입력 시뮬레이션
      stdin.echoMode = false;
      stdin.lineMode = false;
      
      // 테스트 실행
      final game = Game();
      
      // 검증
      expect(game.monsters.length, 3);
      expect(game.defeatedMonsters, 0);
    });
    
    test('getRandomMonster 메서드 테스트', () {
      // 테스트를 위한 입력 시뮬레이션
      stdin.echoMode = false;
      stdin.lineMode = false;
      
      // 테스트 실행
      final game = Game();
      final initialCount = game.monsters.length;
      final monster = game.getRandomMonster();
      
      // 검증
      expect(monster, isNotNull);
      expect(game.monsters.length, initialCount - 1);
    });
  });
} 