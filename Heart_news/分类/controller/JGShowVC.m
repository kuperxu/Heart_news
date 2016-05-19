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
#import <UIRefreshControl+AFNetworking.h>
#import "DetailCell.h"

@interface JGShowVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_table;
    SortModel *sortmodel;
    UIRefreshControl *_refreshControl;
}

@end



@implementation JGShowVC


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
    [_table.tableHeaderView addSubview:_refreshControl];
}

- (void)reload:(__unused id)sender{
    NSURLSessionDataTask *task = [SortModel globalTimelinePostsWithSort:self.title Block:^(SortModel *posts, NSError *error) {
        sortmodel = posts;
        [_table reloadData];
    }];
    [_refreshControl setRefreshingWithStateOfTask:task];
}

- (void)initTableview{
    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _table.frame.size.width, 100.0f)];
    [_refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    
    _table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.estimatedRowHeight = 40;
    _table.rowHeight = UITableViewAutomaticDimension;
    
    
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
    [_table.tableHeaderView addSubview:_refreshControl];
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
