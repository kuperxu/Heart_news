//
//  JGSetupVC.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/6.
//  Copyright © 2016年 jiguang. All rights reserved.
//
#define AUTHOR_COLOR [UIColor colorWithRed:150.0/255.0 green:217.0/255.0 blue:247.0/255.0 alpha:1.0]
#import "JGSetupVC.h"
#import "JGOboutUsVC.h"
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
    
    _array=@[@[@"夜间模式",@"智能无图",@"离线下载"],@[@"清空缓存",@"版本更新",@"关于我们"]];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"Cell";
    //   自定义cell类
    UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text=_array[indexPath.section][indexPath.row];
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
        BOOL night = [user boolForKey:@"night"];
        BOOL noImage = [user boolForKey:@"noimage"];
        BOOL download = [user boolForKey:@"download"];
        
        if (indexPath.row==0) {
            switchButton.tag=1;
            if (night) {
                switchButton.on=YES;
            }
            else{
                switchButton.on=NO;
            }
        }
        if (indexPath.row==1) {
            switchButton.tag=2;
            if (noImage) {
                switchButton.on=YES;
            }
            else{
                switchButton.on=NO;
            }
        }
        if (indexPath.row==2) {
            switchButton.tag=3;
            if (download) {
                switchButton.on=YES;
            }
            else{
                switchButton.on=NO;
            }
        }
    }else{
        
        cell.textLabel.text=_array[indexPath.section][indexPath.row];
        cell.backgroundColor=[UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(indexPath.row == 0){
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
    path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Caches/tag.archiver"];
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
            [user setBool:1 forKey:@"night"];
        }else{
            [user setBool:0 forKey:@"night"];
        }
    }
    else if(sender.tag == 2){
        if (sender.on) {
            [user setBool:1 forKey:@"noimage"];
        }else{
            [user setBool:0 forKey:@"noimage"];
        }
    }else{
        if (sender.on) {
            [user setBool:1 forKey:@"download"];
        }else{
            [user setBool:0 forKey:@"download"];
        }
    }
    [user synchronize];
}
-(void)rool:(UIButton *)sender{
    
}
#pragma  mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 30;
    else
        return 15;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        
        if (indexPath.row==0) {
            [self delete];
        }
        //    else if(indexPath.row==1){
        //        return ;
        //    }
        else if(indexPath.row==1){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:@"暂无可用更新" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ;
            }];
            [alert addAction:okaction];
            [self presentViewController:alert animated:NO completion:^{
                ;
            }];
        }
        else if (indexPath.row==2) {
            JGOboutUsVC *faqVC=[[JGOboutUsVC alloc] init];
            [self.navigationController pushViewController:faqVC animated:YES];
        }
        
    }else
        return ;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return @"通用设置";
    else
        return @"应用设置";
}



@end
