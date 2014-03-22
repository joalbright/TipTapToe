//
//  TTTAIPlayer.m
//  Tip Tap Top
//
//  Created by Jo Albright on 3/21/14.
//  Copyright (c) 2014 Jo Albright. All rights reserved.
//

#import "TTTRobot.h"

#import "TTTGames.h"

@implementation TTTRobot
{
    NSDictionary *choices;
    NSArray *threes;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        threes = @[
                   
        // rows
        @[@1,@2,@3], @[@4,@5,@6], @[@7,@8,@9],
        @[@3,@2,@1], @[@6,@5,@4], @[@9,@8,@7],
        @[@1,@3,@2], @[@4,@6,@5], @[@7,@9,@8],
        
        // columns
        @[@1,@4,@7], @[@2,@5,@8], @[@3,@6,@9],
        @[@7,@4,@1], @[@8,@5,@2], @[@9,@6,@3],
        @[@1,@7,@4], @[@2,@8,@5], @[@3,@9,@6],
        
        // diagonals
        @[@1,@5,@9], @[@7,@5,@3],
        @[@9,@5,@1], @[@3,@5,@7],
        @[@1,@9,@5], @[@7,@3,@5]
        
        ];
    }
    return self;
}

- (NSNumber *)chooseSpot
{
    choices = [[[TTTGames collection] games] lastObject];
    
    NSNumber *num = @1;
    
    if(![[self checkForWin] isEqual:@0])
    {
        num = [self checkForWin];
        
//        NSLog(@"winning : %@",num);
        
    } else if (![[self checkForBlock] isEqual:@0]){
        
        num = [self checkForBlock];
        
//        NSLog(@"blocking : %@",num);
        
    } else {
        
        NSMutableArray *open = [@[] mutableCopy];
        
        for (NSNumber *n in choices) if([[choices objectForKey:n] isEqual:@2]) [open addObject:n];
        
        int random_spot = floor([open count] * RANDOM_01); if(random_spot == [open count]) random_spot--;
        
//        NSLog(@"open spots : %@",open);
        
        num = open[random_spot];
    }
    
    return num;
}

- (NSNumber *)checkForWin
{
    NSNumber *num = @0;
    
    for (NSArray *three in threes) if([choices[three[0]] isEqual:@1] && [choices[three[1]] isEqual:@1] && [choices[three[2]] isEqual:@2])num = three[2];
    
    return num;
}

- (NSNumber *)checkForBlock
{
    NSNumber *num = @0;
    
    for (NSArray *three in threes) if([choices[three[0]] isEqual:@0] && [choices[three[1]] isEqual:@0] && [choices[three[2]] isEqual:@2])num = three[2];
    
    return num;
}

@end
