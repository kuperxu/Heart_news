//
//  JGFootprintVC.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/6.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "JGFootprintVC.h"
#import "HotDetail.h"
#import <Masonry.h>
#import "SDWebImageManager.h"
#import "SDWebImageOperation.h"
#import <AFNetworkReachabilityManager.h>
#import "UIImageView+WebCache.h"
#import "FootTableViewCell.h"

@interface JGFootprintVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *table;
    NSMutableDictionary *archiveDic;
    NSString *filePath;
    UILabel *commitLabel;
}
@property(nonatomic, copy)NSArray *tit;
@property(nonatomic, copy)NSMutableArray *commit;
@property(nonnull, copy)NSMutableArray<HotDetail *> *modelARR;
@end

@implementation JGFootprintVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self initTable];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
    [table reloadData];
}

- (void)initData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"commit.archiver"]];
    archiveDic = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath]mutableCopy];
    _commit = [[NSMutableArray alloc]init];
    _modelARR = [[archiveDic allKeys]mutableCopy];
    for (id obj in _modelARR) {
        [_commit addObject:[archiveDic objectForKey:obj]];
    }
}

- (void)initTable{
    table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
//    table.estimatedRowHeight = 40;
//    table.rowHeight = UITableViewAutomaticDimension;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    FootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[FootTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    [cell.titleLabel setText:_modelARR[indexPath.row].title];
    [cell.contentLabel setText:_commit[indexPath.row]];
    UIImage *defaultimage = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:_modelARR[indexPath.row].image];
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    UIImage *unload = [UIImage imageNamed:@"unload"];
    if(defaultimage){
        [cell.contentimage sd_setImageWithURL:[NSURL URLWithString:_modelARR[indexPath.row].image] placeholderImage:unload];
    }else if ((![[NSUserDefaults standardUserDefaults]objectForKey:@"noimage"]) || mgr.isReachableViaWiFi) {
        [cell.contentimage sd_setImageWithURL:[NSURL URLWithString:_modelARR[indexPath.row].image] placeholderImage:unload];
    }else{
        [cell.contentimage sd_setImageWithURL:nil placeholderImage:unload];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelARR.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    commitLabel = [[UILabel alloc]init];
//    commitLabel.text = _commit[indexPath.row];
//    [table addSubview:commitLabel];
//    [commitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(table);
//        make.left.mas_equalTo(10);
//        make.right.mas_equalTo(-10);
//        make.height.mas_equalTo(400);
//    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"笔记" message:_commit[indexPath.row]  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"CLOSE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    [alert addAction:okaction];
    [self presentViewController:alert animated:NO completion:^{
        ;
    }];
    
}


//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
//    if ([tableView isEqual:myTableView]) {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
//    }
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [table setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[self.modelARR count]) {
//            [self.arrayOfRows removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [archiveDic removeObjectForKey:_modelARR[indexPath.row]];
            [_modelARR removeObjectAtIndex:indexPath.row];
            [_commit removeObjectAtIndex:indexPath.row];
            [NSKeyedArchiver archiveRootObject:archiveDic toFile:filePath];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
        [table reloadData];
    }
}


@end
