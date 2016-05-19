//
//  WebDetailVC.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/15.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "WebDetailVC.h"
#import <Masonry.h>
#import "WebModel.h"



@interface WebDetailVC (){
    UIWebView *web;
}

@end

@implementation WebDetailVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadWebView];
}

- (void)loadWebView{
    web = [[UIWebView alloc]init];
    [self.view addSubview:web];
    [web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [WebModel globalTimelinePostsWithID:_hotModel.ID Block:^(WebModel *webmodel, NSError *error) {
        [web loadHTMLString:[WebModel shareInstance].content baseURL:nil];
        NSLog(@"%@",[WebModel shareInstance].content);
    }];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.xinli001.com/info/100318734"]];
//    [web loadRequest:request];
}

@end
