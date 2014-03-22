//
//  TTTGames.m
//  Tip Tap Top
//
//  Created by Jo Albright on 3/20/14.
//  Copyright (c) 2014 Jo Albright. All rights reserved.
//

#import "TTTGames.h"

@implementation TTTGames

+ (id)allocWithZone:(NSZone *)zone
{
    return [self collection];
}

+ (TTTGames *)collection
{
    static TTTGames *collection = nil;
    if(!collection)
    {
        collection = [[super allocWithZone:NULL] init];
    }
    return collection;
}

- (NSArray *)games
{
    if(allGames == nil) [self start];
    return [allGames copy];
}

- (void)newGame
{
    if(lastTurn == CurrentTurnIsRed) lastTurn = CurrentTurnIsGreen;
    else lastTurn = CurrentTurnIsRed;
    
    turn = lastTurn;
    
    [allGames addObject:[@{@1:@2,@2:@2,@3:@2,@4:@2,@5:@2,@6:@2,@7:@2,@8:@2,@9:@2} mutableCopy]];
}

- (CurrentTurn)isTurn { return turn; }
- (PlayerType)isPlayer { return player; }

- (void)changePlayer
{
    if(player == PlayerTypePerson) player = PlayerTypeRobot;
    else player = PlayerTypePerson;
}

- (UIColor *)placeTurnWithSpot:(NSInteger)spot
{
    UIColor *turnColor;
    if(turn == CurrentTurnIsGreen) turnColor = GREEN_COLOR;
    else turnColor = RED_COLOR;
    
    [[allGames lastObject] setObject:@(turn) forKey:@(spot)];
    
    if(turn == CurrentTurnIsRed) turn = CurrentTurnIsGreen;
    else turn = CurrentTurnIsRed;
    
    return turnColor;
}

- (void)start
{
    allGames = [@[] mutableCopy];
    player = PlayerTypePerson;
    lastTurn = CurrentTurnIsGreen;
    [self newGame];
}

- (BOOL)checkGame
{
    BOOL gameFinished = YES;
    
    NSMutableDictionary *game = [allGames lastObject];
    
    for (NSNumber *key in game)
    {
        NSNumber *num = [game objectForKey:key];
        if([num isEqual:@2]) gameFinished = NO;
    }
    
    // check rows
    if([self checkWinnerWithSpots:@[game[@1],game[@2],game[@3]]]) gameFinished = YES;
    if([self checkWinnerWithSpots:@[game[@4],game[@5],game[@6]]]) gameFinished = YES;
    if([self checkWinnerWithSpots:@[game[@7],game[@8],game[@9]]]) gameFinished = YES;
    // check columns
    if([self checkWinnerWithSpots:@[game[@1],game[@4],game[@7]]]) gameFinished = YES;
    if([self checkWinnerWithSpots:@[game[@2],game[@5],game[@8]]]) gameFinished = YES;
    if([self checkWinnerWithSpots:@[game[@3],game[@6],game[@9]]]) gameFinished = YES;
    // check diagonals
    if([self checkWinnerWithSpots:@[game[@1],game[@5],game[@9]]]) gameFinished = YES;
    if([self checkWinnerWithSpots:@[game[@7],game[@5],game[@3]]]) gameFinished = YES;
    
    if(gameFinished && [game objectForKey:@"winner"] == nil) [game setObject:@2 forKey:@"winner"];
    
    return gameFinished;
}

- (BOOL)checkWinnerWithSpots:(NSArray *)spots
{
    BOOL winner = NO;
    
    if([spots[0] isEqualToValue:spots[1]] && [spots[1] isEqualToValue:spots[2]] && ![spots[0] isEqualToValue:@2])
    {
        winner = YES;
        [[allGames lastObject] setObject:spots[0] forKey:@"winner"];
    }
    
    return winner;
}

@end
