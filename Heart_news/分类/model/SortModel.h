//
//  SortModel.h
//  Heart_news
//
//  Created by 徐纪光 on 16/5/16.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotDetail.h"

@interface SortModel : NSObject

+ (NSURLSessionDataTask *)globalTimelinePostsWithSort:(NSString *)sort Block:(void (^)(SortModel *posts, NSError *error))block;
+ (instancetype)shareInstance;
@property (nonatomic, copy)NSArray<HotDetail *> *data;

@end
