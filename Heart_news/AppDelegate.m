//
//  AppDelegate.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/3.
//  Copyright © 2016年 jiguang. All rights reserved.
//
//#define BACKGROUND_COLOR [UIColor colorWithRed:163.0/255.0 green:205.0/255.0 blue:156.0/255.0 alpha:1.0]
#define BACKGROUND_COLOR [UIColor whiteColor]
#import "AppDelegate.h"
#import "JGTabBarController.h"




@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[JGTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    
    
    
    
//    [[UINavigationBar appearance] setBarTintColor:BACKGROUND_COLOR];
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    if([[[UIDevice currentDevice]systemVersion]floatValue] >=8.0)
        
    {
        
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings
                                                                           settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge)
                                                                           categories:nil]];
        
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        
    }else{
        //这里还是原来的代码
        //注册启用push
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
        
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken {
    
    NSLog(@"regisger success:%@", pToken);
    
    //注册成功，将deviceToken保存到应用服务器数据库中
    
}




- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:@"远程通知"  preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"CLOSE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        ;
//    }];
//    [alert addAction:okaction];
//    [self.roo presentViewController:alert animated:NO completion:^{
//        ;
//    }];
    NSLog(@"i'm info%@", userInfo);
}
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    
//}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Regist fail%@",error);
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
