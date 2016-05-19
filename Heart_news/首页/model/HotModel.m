//
//  HotModel.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/11.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "HotModel.h"
#import <AFNetworking.h>
#import "NSObject+Json.h"
#define BASE_URL @"http://www.varpm.com:3002/v1/article/getList?flag=hot"
@implementation HotModel


+ (instancetype)shareInstance{
    static HotModel *once;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        once = [[self alloc]init];
    });
    return once;
}

- (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    
    return [[AFHTTPSessionManager manager] GET:BASE_URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSDictionary *dic = (NSDictionary *)responseObject;
        [self serializationDataWith:dic];
        if (block) {
            block([NSArray array], nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
}

- (NSString *)arrayObjectClass{
    return @"HotDetail";
}

@end
