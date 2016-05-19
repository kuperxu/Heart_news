//
//  SortModel.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/16.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "SortModel.h"
#import <AFNetworking.h>
#import "NSObject+Json.h"

@interface SortModel ()


@end

@implementation SortModel

+ (instancetype)shareInstance{
    static SortModel *once;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        once = [[self alloc]init];
    });
    return once;
}

+ (NSURLSessionDataTask *)globalTimelinePostsWithSort:(NSString *)sort Block:(void (^)(SortModel *, NSError *))block{
    NSDictionary *SortDIC = @{
                              @"全部":@"",
                              @"婚恋":@"marry",
                              @"职场":@"career",
                              @"健康":@"science",
                              @"科普":@"healthy",
                              @"亲子":@"family",
                              @"最新":@""
                              };
    return [[AFHTTPSessionManager manager] GET:[NSString stringWithFormat:@"http://www.varpm.com:3002/v1/article/getList?sort=%@",SortDIC[sort]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = (NSDictionary *)responseObject;
        SortModel *one = [[self alloc]init];
        [one serializationDataWith:dic];
        if (block) {
            block(one, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@---%@",sort,SortDIC[sort]);
    }];
}


- (NSString *)arrayObjectClass{
    return @"HotDetail";
}

@end
