//
//  TTTSpotVC.m
//  Tip Tap Top
//
//  Created by Jo Albright on 3/20/14.
//  Copyright (c) 2014 Jo Albright. All rights reserved.
//

#import "TTTSpotVC.h"

#import "TTTGames.h"

@class TTTRootVC;

@interface TTTSpotVC ()

@end

@implementation TTTSpotVC
{
    CGPoint position;
    
    int diameter;
    int radius;
}

- (id)initWithPoint:(CGPoint)point
{
    self = [super init];
    if (self)
    {
        diameter = 80;
        radius = 40;
        
        self.view.backgroundColor = TAN_COLOR;
        self.view.alpha = 0.9;
        self.view.layer.cornerRadius = radius;
        self.gamePlayed = NO;
        self.tapped = NO;
        
        position = point;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    if(!self.gamePlayed)
    {
        self.view.frame = CGRectMake(position.x, position.y, 0, 0);
        
        [MOVE animateView:self.view properties:@{
                                                 @"x":@(position.x - radius),
                                                 @"y":@(position.y - radius),
                                                 @"width":@(diameter),
                                                 @"height":@(diameter),
                                                 @"delay":@(RANDOM_01 * 0.5),
                                                 @"duration":@0.6
                                                 }];
    } else {
        self.view.frame = CGRectMake(position.x - radius, position.y - radius, diameter, diameter);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.tapped) return;
    
    self.view.backgroundColor = [[TTTGames collection] placeTurnWithSpot:self.spot];
    
    self.tapped = YES;
    
    [self.delegate tapSpot:self.spot];
}

- (void)setChoice:(UIColor *)color
{
    self.view.backgroundColor = color;
}

@end
