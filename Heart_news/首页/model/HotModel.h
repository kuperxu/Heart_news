//
//  HotModel.h
//  Heart_news
//
//  Created by 徐纪光 on 16/5/11.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HotDetail;


@interface HotModel : NSObject<NSURLSessionDataDelegate>
//- (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;
- (NSURLSessionDataTask *)globalTimelinePostsWithPage:(NSInteger)page Block:(void (^)(NSArray *posts, NSError *error))block;
+ (instancetype)shareInstance;
@property (nonatomic, copy)NSArray<HotDetail *> *data;

@end
