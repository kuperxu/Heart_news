//
//  NSObject+Json.h
//  demo-for-kvc-json
//
//  Created by 徐纪光 on 16/4/30.
//  Copyright © 2016年 徐纪光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Json)
-(void) serializationDataWith:(NSDictionary *)dic;
+ (instancetype)objectWithDict:(NSDictionary *)dict;
- (NSString *)arrayObjectClass;

@end
