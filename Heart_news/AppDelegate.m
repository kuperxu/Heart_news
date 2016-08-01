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

//    [[NSUserDefaults standardUserDefaults]setObject:@"divcetoken" forKey:pToken];
    
//    NSLog(@"方式1：%@", deviceTokenString1);
//    NSLog(@"%@",str);
    
//    NSString *deviceTokenString2 = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
//                                     
//                                     stringByReplacingOccurrencesOfString:@">" withString:@""]
//                                    
//                                    stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    NSLog(@"方式2：%@", deviceTokenString2);
//    
//    
//}


    
    NSMutableString *tokenString = [self changeDeviceTokenToString:pToken];
    
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"divcetoken"] isEqualToString:tokenString])
        return;
        
    [[NSUserDefaults standardUserDefaults]setObject:@"divcetoken" forKey:tokenString];
    
    NSURLSessionConfiguration *con = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:con];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://114.215.83.1/apns/cer/MyCer/input.php"]];
    request.HTTPMethod = @"POST";
    
    NSData *postBody = [[NSString stringWithFormat:@"token=%@",tokenString] dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:postBody];
    NSURLSessionDataTask *dask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"jk  response :%@",d);
    }];
    [dask resume];
    //注册成功，将deviceToken保存到应用服务器数据库中
    
}

- (NSMutableString *)changeDeviceTokenToString:(NSData *)pToken{
    NSMutableString *deviceTokenString1 = [NSMutableString string];
    
    const char *bytes = pToken.bytes;
    
    int iCount = pToken.length;
    
    for (int i = 0; i < iCount; i++) {
        [deviceTokenString1 appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    return deviceTokenString1;
}




- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    NSLog(@"i'm info%@", userInfo);
}

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
