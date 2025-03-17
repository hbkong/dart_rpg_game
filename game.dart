import 'dart:io';
import 'dart:math';
import 'models/character.dart';
import 'models/monster.dart';

class Game {
  late Character character;
  List<Monster> monsters = [];
  int defeatedMonsters = 0;
  bool isTestMode;
  
  Game({this.isTestMode = false}) {
    // 게임 초기화
    loadCharacterStats();
    loadMonsterStats();
  }
  
  void startGame() {
    print('게임을 시작합니다!');
    character.showStatus();
    
    // 게임 루프
    while (character.health > 0 && defeatedMonsters < monsters.length) {
      // 랜덤 몬스터 선택
      final monster = getRandomMonster();
      print('새로운 몬스터가 나타났습니다!');
      monster.showStatus();
      
      // 전투 진행
      final battleResult = battle(monster);
      
      // 전투 결과 처리
      if (battleResult) {
        defeatedMonsters++;
        print('${monster.name}을(를) 물리쳤습니다!');
        
        // 경험치 획득
        character.gainExperience(monster.experienceReward);
        
        // 스탯 포인트가 있으면 분배 기회 제공
        if (character.statPoints > 0) {
          distributeStatPoints();
        }
        
        // 모든 몬스터를 물리쳤는지 확인
        if (defeatedMonsters >= monsters.length) {
          print('모든 몬스터를 물리쳤습니다! 게임에서 승리했습니다!');
          saveGameResult(true);
          return;
        }
        
        // 다음 몬스터와 대결할지 선택
        print('다음 몬스터와 싸우시겠습니까? (y/n):');
        final answer = isTestMode 
            ? 'y' // 테스트 환경에서는 항상 계속 진행
            : stdin.readLineSync()?.toLowerCase() ?? 'n';
        if (answer != 'y') {
          print('게임을 종료합니다.');
          saveGameResult(true);
          return;
        }
      } else {
        // 캐릭터가 패배한 경우
        print('${character.name}이(가) 패배했습니다.');
        saveGameResult(false);
        return;
      }
    }
  }
  
  // 스탯 포인트 분배 메서드
  void distributeStatPoints() {
    // 테스트 환경에서는 자동으로 처리
    if (isTestMode) {
      if (character.statPoints > 0) {
        // 테스트에서는 체력에 모든 포인트 할당
        character.distributeStatPoints('체력', character.statPoints);
      }
      return;
    }
    
    print('\n스탯 포인트를 분배하시겠습니까? (y/n):');
    final answer = stdin.readLineSync()?.toLowerCase() ?? 'n';
    
    if (answer == 'y') {
      bool distributing = true;
      
      while (distributing && character.statPoints > 0) {
        print('\n사용 가능한 스탯 포인트: ${character.statPoints}');
        print('어떤 스탯을 올리시겠습니까? (1: 체력, 2: 공격력, 3: 방어력, 4: 취소):');
        final statChoice = stdin.readLineSync();
        
        if (statChoice == '4') {
          distributing = false;
          continue;
        }
        
        String statType;
        switch (statChoice) {
          case '1':
            statType = '체력';
            break;
          case '2':
            statType = '공격력';
            break;
          case '3':
            statType = '방어력';
            break;
          default:
            print('잘못된 선택입니다.');
            continue;
        }
        
        print('몇 포인트를 사용하시겠습니까? (최대 ${character.statPoints}):');
        final pointsInput = stdin.readLineSync();
        int points;
        
        try {
          points = int.parse(pointsInput ?? '0');
        } catch (e) {
          print('유효한 숫자를 입력하세요.');
          continue;
        }
        
        if (character.distributeStatPoints(statType, points)) {
          print('스탯 포인트가 성공적으로 분배되었습니다.');
          character.showStatus();
        }
        
        if (character.statPoints <= 0) {
          distributing = false;
        } else {
          print('\n계속해서 스탯 포인트를 분배하시겠습니까? (y/n):');
          final continueAnswer = stdin.readLineSync()?.toLowerCase() ?? 'n';
          if (continueAnswer != 'y') {
            distributing = false;
          }
        }
      }
    }
  }
  
  bool battle(Monster monster) {
    // 몬스터의 공격력 설정 (캐릭터의 방어력과 비교하여)
    monster.setAttackPower(character.defense);
    
    // 전투 루프
    while (character.health > 0 && monster.health > 0) {
      // 캐릭터의 턴
      character.showStatus();
      monster.showStatus();
      
      print('${character.name}의 턴');
      
      // 테스트 환경에서는 자동으로 공격 선택
      String? action;
      if (isTestMode) {
        action = '1'; // 항상 공격 선택
      } else {
        // 아이템 사용 옵션 추가
        String actionPrompt = character.hasUsedItem 
            ? '행동을 선택하세요 (1: 공격, 2: 방어):'
            : '행동을 선택하세요 (1: 공격, 2: 방어, 3: 아이템 사용):';
        print(actionPrompt);
        
        action = stdin.readLineSync();
      }
      
      if (action == '1') {
        // 공격
        character.attackMonster(monster);
      } else if (action == '2') {
        // 방어
        character.defend();
      } else if (action == '3' && !character.hasUsedItem) {
        // 아이템 사용
        if (character.useItem()) {
          // 아이템 사용 후 바로 공격
          character.attackWithItem(monster);
        } else {
          // 아이템 사용 실패 시 다시 행동 선택
          continue;
        }
      } else {
        print('잘못된 입력입니다. 다시 선택하세요.');
        continue;
      }
      
      // 몬스터가 패배했는지 확인
      if (monster.health <= 0) {
        return true;
      }
      
      // 몬스터의 턴
      print('${monster.name}의 턴');
      monster.attackCharacter(character);
      
      // 캐릭터가 패배했는지 확인
      if (character.health <= 0) {
        return false;
      }
    }
    
    // 캐릭터가 살아있으면 승리, 아니면 패배
    return character.health > 0;
  }
  
  Monster getRandomMonster() {
    // 몬스터 리스트에서 랜덤으로 몬스터 선택
    final random = Random();
    final index = random.nextInt(monsters.length);
    final selectedMonster = monsters[index];
    
    // 선택된 몬스터를 리스트에서 제거
    monsters.removeAt(index);
    
    return selectedMonster;
  }
  
  void loadCharacterStats() {
    try {
      // characters.txt 파일에서 캐릭터 스탯 읽기
      final file = File('data/characters.txt');
      if (!file.existsSync()) {
        // 파일이 없으면 기본값으로 생성
        Directory('data').createSync(recursive: true);
        file.writeAsStringSync('50,10,5');
        if (!isTestMode) {
          print('data/characters.txt 파일이 없어 기본값으로 생성했습니다.');
        }
      }
      
      final contents = file.readAsStringSync();
      final stats = contents.split(',');
      
      if (stats.length < 3) {
        throw FormatException('잘못된 캐릭터 데이터 형식입니다.');
      }
      
      final health = int.parse(stats[0]);
      final attack = int.parse(stats[1]);
      final defense = int.parse(stats[2]);
      
      // 사용자로부터 캐릭터 이름 입력 받기
      final name = getCharacterName();
      
      // 캐릭터 생성
      character = Character(name, health, attack, defense);
      
      // 저장된 캐릭터 데이터가 있는지 확인
      final saveFile = File('data/character_save.txt');
      if (saveFile.existsSync()) {
        final savedData = saveFile.readAsStringSync().split('\n');
        
        // 이름이 일치하는 캐릭터 데이터 찾기
        String? matchingData;
        for (final data in savedData) {
          if (data.isNotEmpty) {
            final parts = data.split(',');
            if (parts.isNotEmpty && parts[0] == name) {
              matchingData = data;
              break;
            }
          }
        }
        
        if (matchingData != null) {
          print('저장된 "$name" 캐릭터 데이터가 있습니다. 불러오시겠습니까? (y/n):');
          
          // 테스트 환경에서는 자동으로 'y' 선택
          final answer = isTestMode 
              ? 'y' 
              : stdin.readLineSync()?.toLowerCase() ?? 'n';
          
          if (answer == 'y') {
            character.loadFromString(matchingData);
            print('저장된 캐릭터 데이터를 불러왔습니다.');
          }
        } else {
          // 테스트 모드에서는 메시지 출력 생략
          if (!isTestMode) {
            print('저장된 "$name" 캐릭터 데이터가 없습니다. 새로운 캐릭터로 시작합니다.');
          }
        }
      }
      
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }
  
  void loadMonsterStats() {
    try {
      // monsters.txt 파일에서 몬스터 스탯 읽기
      final file = File('data/monsters.txt');
      if (!file.existsSync()) {
        // 파일이 없으면 기본값으로 생성
        Directory('data').createSync(recursive: true);
        file.writeAsStringSync('Batman,30,20\nSpiderman,20,30\nSuperman,30,10');
        if (!isTestMode) {
          print('data/monsters.txt 파일이 없어 기본값으로 생성했습니다.');
        }
      }
      
      final contents = file.readAsStringSync();
      final lines = contents.split('\n');
      
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        
        final stats = line.split(',');
        if (stats.length != 3) {
          if (!isTestMode) {
            print('잘못된 몬스터 데이터 형식입니다: $line');
          }
          continue;
        }
        
        final name = stats[0];
        final health = int.parse(stats[1]);
        final maxAttackPower = int.parse(stats[2]);
        
        // 몬스터 생성 및 리스트에 추가
        monsters.add(Monster(name, health, maxAttackPower));
      }
      
      if (monsters.isEmpty) {
        throw Exception('몬스터 데이터가 없습니다.');
      }
      
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }
  
  String getCharacterName() {
    // 테스트 환경에서는 기본 이름 반환
    if (isTestMode) {
      return 'TestCharacter';
    }
    
    String? name;
    final nameRegex = RegExp(r'^[a-zA-Z가-힣]+$');
    
    while (name == null || name.isEmpty || !nameRegex.hasMatch(name)) {
      print('캐릭터의 이름을 입력하세요 (한글, 영문 대소문자만 허용):');
      name = stdin.readLineSync()?.trim();
      
      if (name == null || name.isEmpty) {
        print('이름은 비어있을 수 없습니다.');
      } else if (!nameRegex.hasMatch(name)) {
        print('이름은 한글, 영문 대소문자만 포함할 수 있습니다.');
      }
    }
    
    return name;
  }
  
  void saveGameResult(bool isVictory) {
    // 테스트 환경에서는 자동으로 저장
    bool shouldSave = isTestMode ? true : false;
    
    if (!shouldSave) {
      print('결과를 저장하시겠습니까? (y/n)');
      final answer = stdin.readLineSync()?.toLowerCase() ?? 'n';
      shouldSave = answer == 'y';
    }
    
    if (shouldSave) {
      try {
        // 게임 결과 저장
        final resultFile = File('data/result.txt');
        final result = isVictory ? '승리' : '패배';
        final newContent = '${character.name},${character.health},$result';
        
        // 파일이 존재하는지 확인
        if (resultFile.existsSync()) {
          // 기존 내용에 새 내용 추가
          final existingContent = resultFile.readAsStringSync();
          final updatedContent = existingContent.isEmpty 
              ? newContent 
              : '$existingContent\n$newContent';
          resultFile.writeAsStringSync(updatedContent);
        } else {
          // 파일이 없으면 새로 생성
          resultFile.writeAsStringSync(newContent);
        }
        
        if (!isTestMode) {
          print('게임 결과가 data/result.txt 파일에 추가되었습니다.');
        }
        
        // 캐릭터 데이터 저장
        final saveFile = File('data/character_save.txt');
        final characterSaveData = character.toSaveString();
        
        // 기존 저장 데이터 불러오기
        Map<String, String> savedCharacters = {};
        if (saveFile.existsSync()) {
          final savedData = saveFile.readAsStringSync().split('\n');
          for (final data in savedData) {
            if (data.isNotEmpty) {
              final parts = data.split(',');
              if (parts.isNotEmpty) {
                savedCharacters[parts[0]] = data;
              }
            }
          }
        }
        
        // 현재 캐릭터 데이터 업데이트
        savedCharacters[character.name] = characterSaveData;
        
        // 저장 데이터 다시 쓰기
        final updatedSaveData = savedCharacters.values.join('\n');
        saveFile.writeAsStringSync(updatedSaveData);
        
        if (!isTestMode) {
          print('캐릭터 데이터가 저장되었습니다.');
        }
        
      } catch (e) {
        print('게임 결과를 저장하는 데 실패했습니다: $e');
      }
    }
  }
} 