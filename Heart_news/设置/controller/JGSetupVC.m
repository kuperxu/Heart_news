//
//  JGSetupVC.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/6.
//  Copyright © 2016年 jiguang. All rights reserved.
//
#define AUTHOR_COLOR [UIColor colorWithRed:150.0/255.0 green:217.0/255.0 blue:247.0/255.0 alpha:1.0]
#import "JGSetupVC.h"
#import <Masonry.h>
#import "SDWebImageManager.h"

@interface JGSetupVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tabView;
}
@property(nonatomic, copy)NSArray *array;
@end

@implementation JGSetupVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _array=@[@"夜间模式",@"智能无图",@"关于我们",@"清空缓存"];
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tabView reloadData];
}
-(void)initView{
    self.automaticallyAdjustsScrollViewInsets = 0;
    _tabView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tabView.dataSource=self;
    _tabView.delegate=self;
    _tabView.scrollEnabled=NO;
//    _tabView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:_tabView];
    [_tabView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.left.and.right.equalTo(self.view);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(49);
    }];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"Cell";
    //   自定义cell类
    UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.row==0||indexPath.row==1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text=_array[indexPath.row];
        cell.backgroundColor=[UIColor whiteColor];
        //大小固定，设置无效
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchButton.onTintColor = AUTHOR_COLOR;
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchButton];
        
        [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        
        
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        BOOL notion=[user boolForKey:@"notion"];
        BOOL show=[user boolForKey:@"show"];
        
        
        if (indexPath.row==0) {
            switchButton.tag=1;
            if (notion) {
                switchButton.on=YES;
            }
            else{
                switchButton.on=NO;
            }
        }
        if (indexPath.row==1) {
            switchButton.tag=2;
            if (show) {
                switchButton.on=YES;
            }
            else{
                switchButton.on=NO;
            }
        }
    }else{
        
        cell.textLabel.text=_array[indexPath.row];
        cell.backgroundColor=[UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(indexPath.row == 3){
            UILabel *label = ({
                UILabel *view = [[UILabel alloc]init];
                [cell.contentView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.height.mas_equalTo(30);
                    make.right.mas_equalTo(20);
                    make.width.mas_equalTo(60);
                }];
                view.font = [UIFont systemFontOfSize:16.f];
                [view setTextColor:[UIColor grayColor]];
                [view setText:[NSString stringWithFormat:@"%.1fM",[self calculateCache]]];
                view;
            });
        }
        
    }
    return cell;
}

-(void)delete{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Caches/xiyouMobile.Heart-news"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [[SDImageCache sharedImageCache]clearDisk];
    [fileManager removeItemAtPath:path error:nil];
    [_tabView reloadData];
}

- (CGFloat)calculateCache{
    CGFloat content;
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Caches/xiyouMobile.Heart-news"];
    content = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0 + [self folderSizeAtPath:path];
    
    return content;
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
    
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

-(void)switchAction:(UISwitch *)sender{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (sender.tag==1) {
        if (sender.on) {
            [user setBool:1 forKey:@"notion"];
        }else{
            [user setBool:0 forKey:@"notion"];
        }
    }
    else{
        if (sender.on) {
            [user setBool:1 forKey:@"show"];
        }else{
            [user setBool:0 forKey:@"show"];
        }
    }
    [user synchronize];
}
-(void)rool:(UIButton *)sender{
    
}
#pragma  mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return ;
    }
//    else if(indexPath.row==1){
//        return ;
//    }
//    else if (indexPath.row==2) {
//        FAQViewController *faqVC=[[FAQViewController alloc] init];
//        [self.navigationController pushViewController:faqVC animated:YES];
//    }
    else if(indexPath.row==3){
        [self delete];
    }
    else{
    
        [self delete];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
