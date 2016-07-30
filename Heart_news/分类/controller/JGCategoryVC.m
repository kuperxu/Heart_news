//
//  JGCategoryVC.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/6.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "JGCategoryVC.h"
#import "WebDetailVC.h"
#import "JGShowVC.h"



@interface JGCategoryVC (){
    NSOperationQueue *que;
}
@property(nonatomic, copy)NSArray *currentChannelsArray;
@end
@implementation JGCategoryVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加所有子控制器
    [self setupAllChildViewController];
    [self.view setBackgroundColor:[UIColor grayColor]];
    
}

#pragma mark - 添加所有子控制器
- (void)setupAllChildViewController
{
    
    JGShowVC *vc6 = [[JGShowVC alloc] initWithTitle:@"全部"];
//    vc6.view.backgroundColor = [UIColor grayColor];
    
    [self addChildViewController:vc6];
    
    
    JGShowVC *vc1 = [[JGShowVC alloc] initWithTitle:@"亲子"];
//    vc1.view.backgroundColor = [UIColor redColor];
    //    vc1.title = [@"亲子" copy];
    [self addChildViewController:vc1];
    
    
    JGShowVC *vc2 = [[JGShowVC alloc] initWithTitle:@"婚恋"];
//    vc2.view.backgroundColor = [UIColor yellowColor];
    //    vc2.title = @"婚恋";
    [self addChildViewController:vc2];
    
    JGShowVC *vc3 = [[JGShowVC alloc] initWithTitle:@"职场"];
//    vc3.view.backgroundColor = [UIColor greenColor];
    //    vc3.title = @"职场";
    [self addChildViewController:vc3];
    
    JGShowVC *vc4 = [[JGShowVC alloc] initWithTitle:@"健康"];
//    vc4.view.backgroundColor = [UIColor blueColor];
    //        vc4.title = @"健康";
    [self addChildViewController:vc4];
    
    JGShowVC *vc5 = [[JGShowVC alloc] initWithTitle:@"科普"];
//    vc5.view.backgroundColor = [UIColor purpleColor];
    //    vc5.title = @"科普";
    [self addChildViewController:vc5];
    
    
}





@end
