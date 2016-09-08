//
//  JGHomeVC.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/6.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "JGHomeVC.h"


@interface JGHomeVC ()
<UITableViewDelegate,
UITableViewDataSource
>{
    AdView * adView;
    UITableView *table;
    HomeModel *model;
    HotModel *hotmodel;
}


@end
@implementation JGHomeVC
NSInteger page;

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.alpha = 1.f;
}
- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
//    修改将task结果去掉
    model.data = nil;
    [model globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            NSMutableArray *imagesURL = [NSMutableArray array];
            NSMutableArray *titles = [NSMutableArray array];
            for (DetailModel *mo in model.data) {
                [imagesURL addObject:mo.image];
                [titles addObject:mo.tip];
            }
            
            adView.adTitleArray = titles;
            adView.imageLinkURL = imagesURL;

            [table.mj_header endRefreshing];
        }
    }];
    page =1;
    [hotmodel globalTimelinePostsWithPage:page Block:^(NSArray *posts, NSError *error) {
        [table reloadData];
    }];

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
                           @"http://image.xinli001.com/20160108/083644mzfz746b6ubo9lsl.jpg",
                           @"http://image.xinli001.com/20160607/063410od0v9fhhf2c1ofac.jpg",
                           @"http://image.xinli001.com/20160606/113934bcbfzrxqpqp4ylba.jpg"
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
    //    table.mj_header = [MJRefreshNormalHeader ]
    
    
}
- (void)loadMoreData{

    page ++;
    [hotmodel globalTimelinePostsWithPage:page Block:^(NSArray *posts, NSError *error) {
        [table reloadData];
        [table.mj_footer endRefreshing];
    }];
}

- (void)initTableview{
    table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.estimatedRowHeight = 40;
    table.rowHeight = UITableViewAutomaticDimension;
#warning need anther huadong lan
    table.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 49, 0));
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload:)];
    
    // 设置文字
    [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor redColor];
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置刷新控件
    table.mj_header = header;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(loadMoreData)];
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
    
    //1.设置self.tabBarController.tabBar.hidden=YES;
    
//    self.tabBarController.tabBar.hidden=YES;
    
    //2.如果在push跳转时需要隐藏tabBar，设置self.hidesBottomBarWhenPushed=YES;
    
//    self.hidesBottomBarWhenPushed=YES;
    
    
    WebDetailVC *vc = [[WebDetailVC alloc]init];
    vc.hotModel = hotmodel.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:NO];
    
    
//    self.hidesBottomBarWhenPushed=NO;
    
    //并在push后设置self.hidesBottomBarWhenPushed=NO;
    //这样back回来的时候，tabBar会恢复正常显示。
    
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
