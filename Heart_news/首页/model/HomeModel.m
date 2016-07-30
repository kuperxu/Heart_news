//
//  HomeModel.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/8.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "HomeModel.h"
#import "NSObject+Json.h"
#import <AFNetworking.h>
#import "DetailModel.h"

@implementation HomeModel

static HomeModel *once;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        once = [[HomeModel alloc]init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    
    return once;
}

- (void)getModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://www.varpm.com:3002/v1/article/getBanner/" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        _data = [NSArray array];
        NSDictionary *dic = (NSDictionary *)responseObject;
        [self serializationDataWith:dic];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
    
}


- (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
//    return [[AFHTTPSessionManager manager] GET:@"http://www.varpm.com:3002/v1/article/getBanner/" parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
//        NSLog(@"%@",JSON);
//        NSDictionary *dic = (NSDictionary *)JSON;
//        
//        
//        if (block) {
//            block([NSArray array], nil);
//        }
//    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
//        if (block) {
//            block([NSArray array], error);
//        }
//    }];
    
    return [[AFHTTPSessionManager manager] GET:@"http://www.varpm.com:3002/v1/article/getBanner/" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[NSThread currentThread]);
        NSDictionary *dic = (NSDictionary *)responseObject;
        [self serializationDataWith:dic];
        if (block) {
            block([NSArray array], nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

- (NSString *)arrayObjectClass{
    return @"DetailModel";
}

@end
