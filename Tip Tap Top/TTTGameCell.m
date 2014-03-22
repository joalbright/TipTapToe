//
//  TTTGameCell.m
//  Tip Tap Top
//
//  Created by Jo Albright on 3/20/14.
//  Copyright (c) 2014 Jo Albright. All rights reserved.
//

#import "TTTGameCell.h"

#import "TTTSpotVC.h"

#import "TTTGames.h"
#import "TTTRobot.h"

#import <Accelerate/Accelerate.h>

@implementation TTTGameCell
{
    NSMutableArray *spots;
    UILabel *turn;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupGame
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    spots = [@[] mutableCopy];
    
    NSArray *rows = @[@[@1,@2,@3],@[@4,@5,@6],@[@7,@8,@9]];
    NSArray *cols = @[@[@1,@4,@7],@[@2,@5,@8],@[@3,@6,@9]];
    
    for (NSInteger i = 1; i < 10; i++)
    {
        NSInteger row = 0;
        NSInteger col = 0;
        
        for (NSArray *r in rows) if([r containsObject:@(i)]) row = [rows indexOfObject:r];
        for (NSArray *c in cols) if([c containsObject:@(i)]) col = [cols indexOfObject:c];
        
        CGPoint point = {0,0};
        
        point.x = (SCREEN_WIDTH / 2.0) + ((col - 1) * 90);
        point.y = (SCREEN_HEIGHT / 2.0) + ((row - 1) * 90);
        
        TTTSpotVC *spotVC = [[TTTSpotVC alloc] initWithPoint:point];
        spotVC.spot = i;
        spotVC.delegate = self;
        
        [spots addObject:spotVC];
        
        NSInteger choice = [[self.choices objectForKey:@(i)] intValue];
        
        if(choice == 0) [spotVC setChoice:RED_COLOR];
        if(choice == 1) [spotVC setChoice:GREEN_COLOR];
        
        spotVC.gamePlayed = [self gameStarted];
        
        [self.contentView addSubview:spotVC.view];
    }
    
    [self.delegate enableInteraction];
    
    turn = [[UILabel alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT / 2) - 180, SCREEN_WIDTH, 30)];
    turn.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    turn.adjustsFontSizeToFitWidth = YES;
    turn.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:turn];
    
    if([[self choices] objectForKey:@"winner"] != nil)
    {
        UIView *lock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.contentView addSubview:lock];
        
        int winner_num = [[[self choices] objectForKey:@"winner"] intValue];
        
        if(winner_num == 0) { turn.text = @"RED WON!"; turn.textColor = RED_COLOR; }
        if(winner_num == 1) { turn.text = @"GREEN WON!"; turn.textColor = GREEN_COLOR; }
        if(winner_num == 2) { turn.text = @"STALEMATE"; turn.textColor = [UIColor colorWithWhite:0.0 alpha:0.8]; }
        
        if([[self choices] isEqual:[[[TTTGames collection] games] lastObject]])
        {
            
            // play again button
            
            [self addNew];
        }
        
    } else {
        
        [self setTurn];
        [self runRobot];
    }
    
    turn.alpha = 0;
    [MOVE animateView:turn properties:@{@"alpha":@1,@"duration":@0.4,@"delay":@0.2}];
}

- (BOOL)gameStarted
{
    BOOL gameStarted = NO;
    
    for (NSNumber *key in self.choices)
    {
        NSNumber *num = [self.choices objectForKey:key];
        if(![num isEqual:@2]) gameStarted = YES;
    }
    
    return gameStarted;
}

- (void)tapSpot:(NSInteger)spot
{
    if([[TTTGames collection] checkGame])
    {
        turn.text = @"";
        
        int winner_num = [[[[[TTTGames collection] games] lastObject] objectForKey:@"winner"] intValue];
        
        UIView *lock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.contentView addSubview:lock];
        
        UIView *gameBar = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - 200) / 2, SCREEN_WIDTH, 200)];
        gameBar.clipsToBounds = YES;
        gameBar.alpha = 0;
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - 200) / -2, SCREEN_WIDTH, SCREEN_HEIGHT)];
        background.image = [self blurView];
        
        [gameBar addSubview:background];

        [self.contentView addSubview:gameBar];
        
        // status label
        UILabel *winner = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, SCREEN_WIDTH - 40, 50)];
        winner.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
        winner.adjustsFontSizeToFitWidth = YES;
        winner.textAlignment = NSTextAlignmentCenter;
        winner.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        
        [gameBar addSubview:winner];
        
        // play again button
        
        [self addNew];
        
        if(winner_num == 0)
        {
            winner.text = @"RED WINS!";
        }
        
        if(winner_num == 1)
        {
            winner.text = @"GREEN WINS!";
        }
        
        if(winner_num == 2)
        {
            winner.text = @"STALEMATE";
            winner.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        }
        
        [MOVE animateView:gameBar properties:@{@"alpha":@1,@"duration":@0.4}];
        
    } else {
        
        [self setTurn];
        
        turn.alpha = 0;
        [MOVE animateView:turn properties:@{@"alpha":@1,@"duration":@0.2}];
        
        [self runRobot];
    }
    
    [self.delegate turnPlayed];
}

- (void)runRobot
{
    if([[TTTGames collection] isPlayer] == PlayerTypeRobot && [[TTTGames collection] isTurn] == CurrentTurnIsGreen)
    {        
        TTTRobot *robot = [[TTTRobot alloc] init];
        
        UIView *lock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.contentView addSubview:lock];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spinner.backgroundColor = GREEN_COLOR;
        spinner.frame = CGRectMake((SCREEN_WIDTH - 40) / 2, 10, 40, 40);
        spinner.layer.cornerRadius = 20;
        
        [spinner startAnimating];
        
        [lock addSubview:spinner];
        
        [MOVE animateView:lock properties:@{@"alpha":@0,@"delay":@(RANDOM_01)} block:^(id obj) {
            
            NSInteger choice = [[robot chooseSpot] integerValue];
            
            TTTSpotVC *spot = spots[choice - 1];
            
            spot.view.backgroundColor = [[TTTGames collection] placeTurnWithSpot:choice];
            spot.tapped = YES;
            
            [lock removeFromSuperview];
            
            [self tapSpot:choice];
            
        }];
    }
}

- (void)addNew
{
    // play again button
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80) / 2, SCREEN_HEIGHT - 100, 80, 80)];
    [button setTitle:@"NEW" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.8] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(newGame) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    button.titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    button.backgroundColor = GREEN_COLOR;
    button.layer.cornerRadius = 40;
    button.clipsToBounds = YES;
    
    [self.contentView addSubview:button];
}

- (void)setTurn
{
    if([[TTTGames collection] isTurn] == CurrentTurnIsRed)
    {
        turn.text = @"RED'S TURN";
        turn.textColor = RED_COLOR;
    } else {
        turn.text = @"GREEN'S TURN!";
        turn.textColor = GREEN_COLOR;
    }
}

- (void)newGame
{
    [[TTTGames collection] newGame];
    
    [self.delegate newGame];
}

- (UIImage *)blurView
{
    UIGraphicsBeginImageContext(self.bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    CGContextFillRect(context, self.bounds);
    
    [self.layer renderInContext:context];
    
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	vImage_Buffer inBuffer;
	inBuffer.data = CGBitmapContextGetData(context);
	inBuffer.width = CGBitmapContextGetWidth(context);
	inBuffer.height = CGBitmapContextGetHeight(context);
	inBuffer.rowBytes = CGBitmapContextGetBytesPerRow(context);
    
	UIGraphicsBeginImageContext(self.bounds.size);
	CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
	vImage_Buffer outBuffer;
	outBuffer.data = CGBitmapContextGetData(effectOutContext);
	outBuffer.width = CGBitmapContextGetWidth(effectOutContext);
	outBuffer.height = CGBitmapContextGetHeight(effectOutContext);
	outBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
	
	CGFloat blurRadius = 10;
	CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
	int radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
	if (radius % 2 != 1) { radius += 1; }
	vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
	vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
	vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
	
    int winner_num = [[[[[TTTGames collection] games] lastObject] objectForKey:@"winner"] intValue];
    
	// add tint
	UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    if(winner_num == 0) tintColor = RED_TRANSPARENT;
    if(winner_num == 1) tintColor = GREEN_TRANSPARENT;
	
	CGContextSaveGState(context);
	CGContextSetFillColorWithColor(context, tintColor.CGColor);
	CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
	CGContextRestoreGState(context);
	
	
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
	
	UIGraphicsEndImageContext();
	UIGraphicsEndImageContext();
    
    CGImageRelease(imageRef);
    
    
    return returnImage;
}

@end
