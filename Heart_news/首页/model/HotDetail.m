//
//  HotDetail.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/11.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "HotDetail.h"

@interface HotDetail ()<NSCoding,NSCopying>

@end

@implementation HotDetail

- (NSString *)arrayObjectClass{
    return @"NSString";
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.tags forKey:@"tags"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.view forKey:@"view"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self.ID = [aDecoder decodeObjectForKey:@"ID"];
    self.author = [aDecoder decodeObjectForKey:@"author"];
    self.image = [aDecoder decodeObjectForKey:@"image"];
    self.tags = [aDecoder decodeObjectForKey:@"tags"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.view = [aDecoder decodeObjectForKey:@"view"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    HotDetail *one = [[HotDetail alloc]init];
    one.ID = self.ID;
    one.author = self.author;
    one.image = self.image;
    one.tags = self.tags;
    one.title = self.title;
    one.view = self.view;
    return one;
}

@end
