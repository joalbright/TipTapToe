//
//  MOVE.h
//
//
//  Created by Jo Albright on 8/20/13.
//  Copyright (c) 2013 Jo2co. All rights reserved.
//
//  http://jo2.co
//

@interface MOVE : NSObject

+ (void)animateView:(UIView *)obj properties:(NSDictionary *)props;
+ (void)animateView:(UIView *)obj properties:(NSDictionary *)props block:(void(^)(id obj))block;

@end
