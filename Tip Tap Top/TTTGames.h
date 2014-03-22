//
//  TTTGames.h
//  Tip Tap Top
//
//  Created by Jo Albright on 3/20/14.
//  Copyright (c) 2014 Jo Albright. All rights reserved.
//

#import "MOVE.h"

typedef enum : NSUInteger {
    CurrentTurnIsRed,
    CurrentTurnIsGreen
} CurrentTurn;

typedef enum : NSUInteger {
    PlayerTypePerson,
    PlayerTypeRobot
} PlayerType;

@interface TTTGames : NSObject
{
    NSMutableArray *allGames;
    CurrentTurn turn;
    CurrentTurn lastTurn;
    PlayerType player;
}

+ (TTTGames *)collection;

- (void)newGame;
- (NSArray *)games;

- (CurrentTurn)isTurn;
- (UIColor *)placeTurnWithSpot:(NSInteger)spot;

- (BOOL)checkGame;

- (PlayerType)isPlayer;
- (void)changePlayer;

@end
