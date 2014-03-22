//
//  TTTNavController.m
//  Tip Tap Top
//
//  Created by Jo Albright on 3/21/14.
//  Copyright (c) 2014 Jo Albright. All rights reserved.
//

#import "TTTNavController.h"

#import "TTTGames.h"

#import "TTTRootVC.h"

#import <Accelerate/Accelerate.h>

@interface TTTNavController ()

@end

@implementation TTTNavController
{
    UIView *lock;
    UIView *nav;
    UIButton *stats;
    UIButton *player;
    
    BOOL statsOpen;
    
    TTTRootVC *rVC;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        self.navigationBar.translucent = YES;
        self.navigationBarHidden = YES;
        
        statsOpen = NO;
        
        rVC = (TTTRootVC *)rootViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
//    nav.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    [self.view addSubview:nav];
    
    player = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 10, 40, 40)];
    [player setBackgroundImage:[UIImage imageNamed:@"person"] forState:UIControlStateNormal];
    player.layer.cornerRadius = 20;
    
    [player addTarget:self action:@selector(changePlayer) forControlEvents:UIControlEventTouchUpInside];
    
    [nav addSubview:player];
    
    stats = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [stats setBackgroundImage:[UIImage imageNamed:@"stats"] forState:UIControlStateNormal];
    stats.layer.cornerRadius = 20;
    
    [stats addTarget:self action:@selector(showStats) forControlEvents:UIControlEventTouchUpInside];
    
    [nav addSubview:stats];
}

- (void)changePlayer
{
    [[TTTGames collection] changePlayer];
    
    if([[TTTGames collection] isPlayer] == PlayerTypePerson)
    {
        [player setBackgroundImage:[UIImage imageNamed:@"person"] forState:UIControlStateNormal];
    } else {
        [player setBackgroundImage:[UIImage imageNamed:@"robot"] forState:UIControlStateNormal];
        [rVC changePlayer];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showStats
{
    if(statsOpen)
    {
        statsOpen = NO;
        
        [lock removeFromSuperview];
        
        return;
    }
    
    statsOpen = YES;
    
    lock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:lock];
    
    UIView *statsBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    statsBar.clipsToBounds = YES;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background.image = [self blurView];
    
    [statsBar addSubview:background];
    
    [lock addSubview:statsBar];
    
    // stats label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT / 4) - 25, SCREEN_WIDTH - 40, 50)];
    label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    label.text = @"STATS";
    
    [statsBar addSubview:label];
    
    int red_wins = 0;
    int green_wins = 0;
    int stalemates = 0;
    
    for (NSDictionary *game in [[TTTGames collection] games])
    {
        if([[game objectForKey:@"winner"] isEqual:@0]) red_wins++;
        if([[game objectForKey:@"winner"] isEqual:@1]) green_wins++;
        if([[game objectForKey:@"winner"] isEqual:@2]) stalemates++;
    }
    
    // greens label
    UILabel *greens = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 260) / 2, (SCREEN_HEIGHT - 80) / 2, 80, 80)];
    greens.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
    greens.adjustsFontSizeToFitWidth = YES;
    greens.textAlignment = NSTextAlignmentCenter;
    greens.textColor = [UIColor whiteColor];
    greens.backgroundColor = GREEN_COLOR;
    greens.text = [NSString stringWithFormat:@"%d", green_wins];
    greens.layer.cornerRadius = 40;
    greens.clipsToBounds = YES;
    
    [statsBar addSubview:greens];
    
    // reds label
    UILabel *reds = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80) / 2, (SCREEN_HEIGHT - 80) / 2, 80, 80)];
    reds.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
    reds.adjustsFontSizeToFitWidth = YES;
    reds.textAlignment = NSTextAlignmentCenter;
    reds.textColor = [UIColor whiteColor];
    reds.backgroundColor = RED_COLOR;
    reds.text = [NSString stringWithFormat:@"%d", red_wins];
    reds.layer.cornerRadius = 40;
    reds.clipsToBounds = YES;
    
    [statsBar addSubview:reds];
    
    // ties label
    UILabel *ties = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH + 100) / 2, (SCREEN_HEIGHT - 80) / 2, 80, 80)];
    ties.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
    ties.adjustsFontSizeToFitWidth = YES;
    ties.textAlignment = NSTextAlignmentCenter;
    ties.textColor = [UIColor whiteColor];
    ties.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    ties.text = [NSString stringWithFormat:@"%d", stalemates];
    ties.layer.cornerRadius = 40;
    ties.clipsToBounds = YES;
    
    [statsBar addSubview:ties];
    
    // play again button
    
    UIButton *closeStats = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [closeStats addTarget:self action:@selector(closeStats) forControlEvents:UIControlEventTouchUpInside];
    [closeStats setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    closeStats.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    closeStats.titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    [lock addSubview:closeStats];
}

- (void)closeStats
{
    [lock removeFromSuperview];
}

- (UIImage *)blurView
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    CGContextFillRect(context, self.view.bounds);
    
    [self.view.layer renderInContext:context];
    
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	vImage_Buffer inBuffer;
	inBuffer.data = CGBitmapContextGetData(context);
	inBuffer.width = CGBitmapContextGetWidth(context);
	inBuffer.height = CGBitmapContextGetHeight(context);
	inBuffer.rowBytes = CGBitmapContextGetBytesPerRow(context);
    
	UIGraphicsBeginImageContext(self.view.bounds.size);
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
    
	// add tint
	UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.7];
	
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
