//
//  JGShowHealVC.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/17.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "JGShowHealVC.h"

@implementation JGShowHealVC
- (void)viewDidLoad{
//    self.title = @"健康";
    
    [super viewDidLoad];
    NSLog(@"0-----------%@",self.title);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

@end
