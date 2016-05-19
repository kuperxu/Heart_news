//
//  JGHomeVC.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/6.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "JGHomeVC.h"
#import "AdView.h"
#import "HomeModel.h"
#import "GMDCircleLoader.h"
#import "DetailModel.h"
#import <Masonry.h>
#import <UIRefreshControl+AFNetworking.h>
#import "HotModel.h"
#import "HotDetail.h"
#import "UIImageView+WebCache.h"
#import "DetailCell.h"
#import "WebDetailVC.h"

@interface JGHomeVC ()
<UITableViewDelegate,
UITableViewDataSource
>{
    AdView * adView;
    UITableView *table;
    HomeModel *model;
    UIRefreshControl *refreshControl;
    HotModel *hotmodel;
}


@end
@implementation JGHomeVC

- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSURLSessionTask *task = [model globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            NSMutableArray *imagesURL = [NSMutableArray array];
            NSMutableArray *titles = [NSMutableArray array];
            for (DetailModel *mo in model.data) {
                [imagesURL addObject:mo.image];
                [titles addObject:mo.tip];
            }
            
            adView.adTitleArray = titles;
            adView.imageLinkURL = imagesURL;
//            NSLog(@"%@,---%@",[adView class],[NSThread currentThread]);
            
//            [GMDCircleLoader hideFromView:self.view animated:NO];
        }
    }];
    [hotmodel globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error) {
//        NSLog(@"%@--%@",hotmodel,[[HotModel alloc]init]);
        [table reloadData];
    }];
    
    [refreshControl setRefreshingWithStateOfTask:task];
}


- (void)viewDidLoad{
    [super viewDidLoad];

    
    hotmodel = [HotModel shareInstance];
    model = [HomeModel shareInstance];
    
    
    
    [self initTableview];
    
    [self initScrolleview];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self reload:nil];
}

- (void)initScrolleview{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    NSArray *imagesURL = @[
                           @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                           @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
                           @"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"
                           ];
    
    // 情景三：图片配文字(可选)
    NSArray *titles = @[@"we",
                        @"are",
                        @"young",
                        ];
    
    //如果你的这个广告视图是添加到导航控制器子控制器的View上,请添加此句,否则可忽略此句
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    adView = [AdView adScrollViewWithFrame:CGRectMake(0, 64, width, 220)  \
                              imageLinkURL:imagesURL\
                       placeHoderImageName:@"placeHoder.jpg" \
                      pageControlShowStyle:UIPageControlShowStyleLeft];
    
    
    //    是否需要支持定时循环滚动，默认为YES
    //    adView.isNeedCycleRoll = YES;
    
    [adView setAdTitleArray:titles withShowStyle:AdTitleShowStyleRight];
    //    设置图片滚动时间,默认3s
    //    adView.adMoveTime = 2.0;
    
    //图片被点击后回调的方法
    adView.callBack = ^(NSInteger index,NSString * imageURL)
    {
        NSLog(@"被点中图片的索引:%ld---地址:%@",index,imageURL);
    };
    //    [self.view addSubview:adView];
    table.tableHeaderView = adView;
    
    refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, table.frame.size.width, 100.0f)];
    [refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [table.tableHeaderView addSubview:refreshControl];
}


- (void)initTableview{
    table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.estimatedRowHeight = 40;
    table.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 49, 0));
    }];
}
//delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return hotmodel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebDetailVC *vc = [[WebDetailVC alloc]init];
    vc.hotModel = hotmodel.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:NO];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[DetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = hotmodel.data[indexPath.row];
    return cell;
}

@end
