//
//  JGShowVC.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/16.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "JGShowVC.h"
#import <Masonry.h>
#import "WebDetailVC.h"
#import "SortModel.h"
#import "HotDetail.h"
#import "DetailCell.h"
#import <MJRefresh.h>
#import <MJRefreshAutoGifFooter.h>

@interface JGShowVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_table;
    SortModel *sortmodel;
}

@end



@implementation JGShowVC
NSInteger pagec;

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    sortmodel = [[SortModel alloc]init];
    
    [self initTableview];
    NSLog(@"%@",self.title);
    
    [self reload:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setAlpha:1.f];
}

- (void)reload:(__unused id)sender{
    pagec = 1;
    NSURLSessionDataTask *task = [SortModel globalTimelinePostsWithSort:self.title Page:1 Block:^(SortModel *posts, NSError *error) {
        sortmodel = posts;
        [_table reloadData];
        [_table.mj_header endRefreshing];
    }];
}

- (void)initTableview{
    //    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _table.frame.size.width, 100.0f)];
    //    [_refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    
    _table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.estimatedRowHeight = 40;
    _table.rowHeight = UITableViewAutomaticDimension;
    
    
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
    //    [_table.tableHeaderView addSubview:_refreshControl];
    
    
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
    _table.mj_header = header;
    
//    __weak __typeof (self) weakself = self;
//    _table.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        [weakself loadMoreData];
//    }];
    
//    MJRefreshAutoFooter不能显示
//    MJRefreshAutoGifFooter可以显示
    
    _table.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    [_table.mj_footer beginRefreshing];  这个方法是马上调用刷新不行
}
- (void)loadMoreData{
    
    //    [hotmodel globalTimelinePostsWithBlock:^(NSArray *posts, NSError *error) {
    //        //        NSLog(@"%@--%@",hotmodel,[[HotModel alloc]init]);
    //        [table reloadData];
    //    }];
    pagec ++;
    [SortModel globalTimelinePostsWithSort:self.title Page:pagec Block:^(SortModel *posts, NSError *error) {
        sortmodel = posts;
        [_table reloadData];
        [_table.mj_footer endRefreshing];
    }];
}

//delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sortmodel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebDetailVC *vc = [[WebDetailVC alloc]init];
    vc.hotModel = sortmodel.data[indexPath.row];
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
    cell.model = sortmodel.data[indexPath.row];
    return cell;
}


@end
