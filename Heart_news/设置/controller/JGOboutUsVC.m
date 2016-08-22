
//
//  JGOboutUsVC.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/19.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "JGOboutUsVC.h"
#import <POP.h>
#import <Masonry.h>

@interface JGOboutUsVC (){
    UIImageView *people;
    UIImageView *we;
    UILabel *about;
}

@end

@implementation JGOboutUsVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    people = [[UIImageView alloc]init];
    we = [[UIImageView alloc]init];
    we.image = [UIImage imageNamed:@"we"];
    people.image = [UIImage imageNamed:@"people"];
    [self.view addSubview:we];
    [self.view addSubview:people];
    
    [we mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    [people mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-80);
        make.height.mas_equalTo(100);
    }];
    about =[[UILabel alloc]init];
    about.text = @"Thank You!";
    about.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:about];
    [about mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
//    UIImageView *image = [[UIImageView alloc]init];
//    [self.view addSubview:image];
//    [image mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.view);
//        make.left.mas_equalTo(20);
//        make.size.mas_equalTo(CGSizeMake(60, 60));
//    }];
//    image.image = [UIImage imageNamed:@"unload"];
//    
//    POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
//    anBasic.toValue = @(image.center.y+300);
//    anBasic.beginTime = CACurrentMediaTime() + 1.0f;
//    [image pop_addAnimation:anBasic forKey:@"position"];
    
    
    
}

@end
