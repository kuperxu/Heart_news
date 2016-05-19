
//
//  GradientView.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/6.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self drawRect:(CGRect)];
//    }
//    return self;
//}

- (void)drawRect:(CGRect)rect{
    CAGradientLayer *layer = [CAGradientLayer new];
    
    layer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blackColor].CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(0, 1);
    layer.frame = rect;
}

@end
