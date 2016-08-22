//
//  HomeModel.h
//  Heart_news
//
//  Created by 徐纪光 on 16/5/8.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
+ (instancetype)shareInstance;
- (void)getModel;
- (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;
@property (nonatomic, copy)NSArray *data;
@end
