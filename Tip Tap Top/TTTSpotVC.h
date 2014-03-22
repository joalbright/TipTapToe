//
//  TTTSpotVC.h
//  Tip Tap Top
//
//  Created by Jo Albright on 3/20/14.
//  Copyright (c) 2014 Jo Albright. All rights reserved.
//

@protocol TTTSpotVCDelegate <NSObject>

- (void)tapSpot:(NSInteger)spot;

@end

@interface TTTSpotVC : UIViewController

@property (nonatomic, assign) id <TTTSpotVCDelegate> delegate;
@property (nonatomic) NSInteger spot;
@property (nonatomic) BOOL gamePlayed;
@property (nonatomic) BOOL tapped;

- (id)initWithPoint:(CGPoint)point;
- (void)setChoice:(UIColor *)color;

@end
