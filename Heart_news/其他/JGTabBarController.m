//
//  JGTabBarController.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/6.
//  Copyright © 2016年 jiguang. All rights reserved.
//
#import "SDImageCache.h"
#import "JGTabBarController.h"
#import "JGHomeVC.h"
#import "JGMineVC.h"
#import "JGSetupVC.h"
#import "JGCategoryVC.h"
#import "JGFootprintVC.h"
#import "HomeModel.h"
//#import "SDWebImage/SDImageCache.h"

//#define BACKGROUND_COLOR [UIColor colorWithRed:163.0/255.0 green:205.0/255.0 blue:156.0/255.0 alpha:1.0]
#define BACKGROUND_COLOR [UIColor whiteColor]


#define TAB_COLOR [UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:86.0/255.0 alpha:1.0]
@interface JGTabBarController ()

@end

@implementation JGTabBarController


-(void)viewDidLoad{
    
//    jiashangle 
    [super viewDidLoad];
    [self.tabBar setTintColor:TAB_COLOR];
    [UITabBar appearance].translucent = YES;
    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CustomPathImages"];
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];
    
    JGHomeVC *vc1 = [[JGHomeVC alloc] init];
    [self addChildViewController:vc1 withImage:[UIImage imageNamed:@"tabbar_news"] selectedImage:[UIImage imageNamed:@"tabbar_news_hl"] withTittle:@"心文"];
    
    JGCategoryVC *vc2 = [[JGCategoryVC alloc] init];
    [self addChildViewController:vc2 withImage:[UIImage imageNamed:@"tabbar_cate"] selectedImage:[UIImage imageNamed:@"tabbar_cate_hl"] withTittle:@"分类"];
    
    JGMineVC *vc3 = [[JGMineVC alloc] init];
    [self addChildViewController:vc3 withImage:[UIImage imageNamed:@"tabbar_mine"] selectedImage:[UIImage imageNamed:@"tabbar_mine_hl"] withTittle:@"我的"];
    
    JGFootprintVC *vc4 = [[JGFootprintVC alloc] init];
    [self addChildViewController:vc4 withImage:[UIImage imageNamed:@"tabbar_foot"] selectedImage:[UIImage imageNamed:@"tabbar_foot_hl"] withTittle:@"足迹"];
    
    JGSetupVC  *vc5 = [[JGSetupVC alloc]init];
    [self addChildViewController:vc5 withImage:[UIImage imageNamed:@"tabbar_setting"] selectedImage:[UIImage imageNamed:@"tabbar_setting_hl"] withTittle:@"设置"];
    

}

- (void)addChildViewController:(UIViewController *)controller withImage:(UIImage *)image selectedImage:(UIImage *)selectImage withTittle:(NSString *)tittle{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [nav.tabBarItem setImage:image];
    //    [nav.tabBarItem setSelectedImage:[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    
//    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
//    returnButtonItem.title = @"返回";
//    [returnButtonItem setTintColor:[UIColor grayColor]];
//    nav.navigationItem.backBarButtonItem = returnButtonItem;
    
//    [[UINavigationBar appearance] setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIColor whiteColor],
//      NSForegroundColorAttributeName,
//      [UIColor whiteColor],
//      NSForegroundColorAttributeName,
//      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
//      NSForegroundColorAttributeName,
//      [UIFont fontWithName:@"Arial-Bold" size:0.0],
//      NSFontAttributeName,
//      nil]];

//    设置返回键颜色--不会影响
    [nav.navigationBar setTintColor:[UIColor grayColor]];
    
    controller.title = tittle;//这句代码相当于上面两句代码
    if([tittle isEqualToString:@"心文"]){
        nav.tabBarItem.title = @"首页";
    }
    
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:TAB_COLOR} forState:UIControlStateSelected];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    [self addChildViewController:nav];
}
@end
