import 'dart:io';
import 'models/character.dart';
import 'models/monster.dart';
import 'game.dart';

void main() {
  try {
    // 게임 인스턴스 생성
    final game = Game();
    
    // 게임 시작
    game.startGame();
  } catch (e) {
    print('게임 실행 중 오류가 발생했습니다: $e');
    exit(1);
  }
} 