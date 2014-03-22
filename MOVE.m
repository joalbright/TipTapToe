//
//  MOVE.m
//
//
//  Created by Jo Albright on 8/20/13.
//  Copyright (c) 2013 Jo2co. All rights reserved.
//
//  http://jo2.co
//

#import "MOVE.h"

@implementation MOVE


+ (void)animateView:(UIView *)obj properties:(NSDictionary *)props { [MOVE animateView:obj properties:props block:nil]; }

+ (void)animateView:(UIView *)obj properties:(NSDictionary *)props block:(void(^)(id obj))block
{
	float duration = ([props objectForKey:@"duration"]) ? [[props objectForKey:@"duration"] floatValue] : 0;
	float delay = ([props objectForKey:@"delay"]) ? [[props objectForKey:@"delay"] floatValue] : 0;
	
	float alpha = ([props objectForKey:@"alpha"]) ? [[props objectForKey:@"alpha"] floatValue] : obj.alpha;
	float height = ([props objectForKey:@"height"]) ? [[props objectForKey:@"height"] floatValue] : obj.frame.size.height;
	float width = ([props objectForKey:@"width"]) ? [[props objectForKey:@"width"] floatValue] : obj.frame.size.width;
	float x = ([props objectForKey:@"x"]) ? [[props objectForKey:@"x"] floatValue] : obj.frame.origin.x;
	float y = ([props objectForKey:@"y"]) ? [[props objectForKey:@"y"] floatValue] : obj.frame.origin.y;
	
	BOOL r = ([props objectForKey:@"remove"]) ? [[props objectForKey:@"remove"] boolValue] : FALSE;
    
    int animation = ([props objectForKey:@"animation"]) ? [[props objectForKey:@"animation"] intValue] : (UIViewAnimationOptions)UIViewAnimationOptionCurveEaseInOut;
    
	[UIView animateWithDuration:duration delay:delay options:(UIViewAnimationOptions)animation animations:^{
		
		obj.frame = CGRectMake(x,y,width,height);
		[obj setAlpha:alpha];
		
	}completion:^(BOOL finished){
		
		if(block != nil) block(obj);
		if(r) [obj removeFromSuperview];
		
	}];
}

@end
