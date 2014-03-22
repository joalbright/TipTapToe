//
//  TTTRootVC.m
//  Tip Tap Top
//
//  Created by Jo Albright on 3/20/14.
//  Copyright (c) 2014 Jo Albright. All rights reserved.
//

#import "TTTRootVC.h"

#import "TTTGames.h"

@interface TTTRootVC ()

@end

@implementation TTTRootVC

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tableView.bounces = NO;
        self.tableView.pagingEnabled = YES;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = SCREEN_HEIGHT;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [[[TTTGames collection] games] count]; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GameCell";
    
    [tableView registerClass:[TTTGameCell class] forCellReuseIdentifier:cellIdentifier];
    
    TTTGameCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) cell = [[TTTGameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
//    TTTGameCell *cell = [[TTTGameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    for (UIView *view in cell.contentView.subviews) { [view removeFromSuperview]; }
    
    cell.choices = [[[TTTGames collection] games] objectAtIndex:indexPath.row];
    cell.delegate = self;
    
    [cell setupGame];
    
    return cell;
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)turnPlayed
{
    
}

- (void)changePlayer
{
    TTTGameCell *cell = self.tableView.visibleCells[0];
    [cell runRobot];
}

- (void)enableInteraction
{
    self.tableView.userInteractionEnabled = YES;
}

- (void)newGame
{
    [self.tableView reloadData];
    
//    NSLog(@"%@",[[TTTGames collection] games]);
    
    self.tableView.userInteractionEnabled = NO;
    
    [[self tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[TTTGames collection] games] count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView { [self scaleCells:scrollView]; }
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView { [self scaleCells:scrollView]; }

- (void)scaleCells:(UIScrollView *)scrollView
{
    NSInteger scrollY = scrollView.contentOffset.y;
    
    for (TTTGameCell *cell in self.tableView.visibleCells)
    {
        NSInteger row = [self.tableView indexPathForCell:cell].row;
        
        NSInteger cellY = row * SCREEN_HEIGHT;
        
        if(scrollY - cellY >= -SCREEN_HEIGHT && scrollY - cellY < 0) // bottom scale
        {
            float percent = (scrollY - cellY) / -SCREEN_HEIGHT;
            float scale = 1.0 - (percent / 2.0);
            float offset = percent * -(SCREEN_HEIGHT/2.0);
            
            CATransform3D transform = CATransform3DTranslate(CATransform3DIdentity, 0, offset, 0);
            cell.layer.transform = CATransform3DScale(transform, scale, scale, scale);
            cell.alpha = 1.0 - percent;
        }
        
        if(scrollY - cellY <= SCREEN_HEIGHT && scrollY - cellY > 0) // top scale
        {
            float percent = (scrollY - cellY) / SCREEN_HEIGHT;
            float scale = 1.0 - (percent / 2.0);
            float offset = percent * (SCREEN_HEIGHT/2.0);
            
            CATransform3D transform = CATransform3DTranslate(CATransform3DIdentity, 0, offset, 0);
            cell.layer.transform = CATransform3DScale(transform, scale, scale, scale);
            cell.alpha = 1.0 - percent;
        }
        
        if(scrollY - cellY == 0)
        {
            float scale = 1.0;
            
            CATransform3D transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 0);
            cell.layer.transform = CATransform3DScale(transform, scale, scale, scale);
            cell.alpha = 1.0;
        }
    }
    // change scale of cells based on location
}

@end
