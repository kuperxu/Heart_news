//
//  HotDetail.h
//  Heart_news
//
//  Created by 徐纪光 on 16/5/11.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotDetail : NSObject

@property(nonatomic, copy)NSString *ID;
@property(nonatomic, copy)NSString *author;
@property(nonatomic, copy)NSString *image;
@property(nonatomic, copy)NSArray *tags;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *view;

@end
