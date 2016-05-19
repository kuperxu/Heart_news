//
//  WebModel.h
//  Heart_news
//
//  Created by 徐纪光 on 16/5/15.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebModel : NSObject

@property(nonatomic, copy)NSString *content;
@property(nonatomic, copy)NSString *data;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *etag;
+ (instancetype)shareInstance;
//+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;

+ (NSURLSessionDataTask *)globalTimelinePostsWithID:(NSString*)ID Block:(void (^)(WebModel *webmodel, NSError *error))block;

@end
