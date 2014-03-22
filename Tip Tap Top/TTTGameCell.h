//
//  TTTGameCell.h
//  Tip Tap Top
//
//  Created by Jo Albright on 3/20/14.
//  Copyright (c) 2014 Jo Albright. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTTSpotVC.h"

@protocol TTTGameCellDelegate <NSObject>

- (void)turnPlayed;
- (void)newGame;
- (void)enableInteraction;

@end

@interface TTTGameCell : UITableViewCell <TTTSpotVCDelegate>

@property (nonatomic, assign) id <TTTGameCellDelegate> delegate;

@property (nonatomic) NSDictionary *choices;

- (void)setupGame;
- (void)runRobot;

@end
