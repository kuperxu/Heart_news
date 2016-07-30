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
#import "GMDCircleLoader.h"
//#import "LeafProgressView.h"
#define AUTHOR_COLOR [UIColor colorWithRed:150.0/255.0 green:217.0/255.0 blue:247.0/255.0 alpha:1.0]
#define TAB_COLOR [UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:86.0/255.0 alpha:1.0]
@interface WebDetailVC ()<UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>{
    UIWebView *web;
    UITapGestureRecognizer *tap;
    UIView *maskView;
    UIButton *rightButton;
    UITextView *commitFiled;
    UIButton *okButton;
}
//@property (nonatomic, strong)LeafProgressView *progress;
@end

@implementation WebDetailVC

- (void)viewDidLoad{
    [super viewDidLoad];
//    self.progress = [[LeafProgressView alloc]initWithFrame:CGRectMake(36, 200, 248, 35)];
//    [self.view addSubview:_progress];
    [self loadWebView];
    [self setupButton];
    [self addNavItem];
}


- (void)addNavItem{
    rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [rightButton setImage:[UIImage imageNamed:@"comment"]forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"commentb"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(addCommit:)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
}

//相应时间用户写评论
- (void)addCommit:(id)sender{
    
    UIButton *button =sender;
    [button setEnabled:NO];
//    添加一个蒙版视图
     maskView = ({
        UIView *view = [UIView new];
        view.frame = self.view.frame;
        view.backgroundColor = [UIColor grayColor];
        view.alpha = 0.5;
        [self.view addSubview:view];
        view;
    });
    
    commitFiled = [[UITextView alloc]init];
    [commitFiled setBackgroundColor:[UIColor whiteColor]];
    commitFiled.delegate = self;
    [maskView addSubview:commitFiled];
    
    
    [commitFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(maskView);
        make.bottom.mas_equalTo(-49);
        make.height.mas_equalTo(180);
    }];
    okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setBackgroundColor:AUTHOR_COLOR];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitFiled addSubview:okButton];
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(commitFiled);
        
//        make.center.equalTo(commitFiled);
        make.size.mas_equalTo(CGSizeMake(40, 25));
    }];
    okButton.layer.cornerRadius = 10;
    [okButton addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [self.view sendSubviewToBack:web];
}

- (void)saveData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"commit.archiver"]];
    
    NSMutableDictionary *archiveDic = [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath]mutableCopy];
    
    if(!archiveDic){
        archiveDic = [@{[_hotModel copy]:commitFiled.text} mutableCopy];
    }else{
        [archiveDic setObject:commitFiled.text forKey:[_hotModel copy]];
    }
    
    [NSKeyedArchiver archiveRootObject:archiveDic toFile:filePath];
    
}

// top到达顶部

- (void)setupButton{
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [web addSubview:topButton];
    [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGPointMake(40, 40));
        make.right.mas_equalTo(20);
        make.bottom.mas_equalTo(-69);
    }];
    topButton.backgroundColor = [UIColor clearColor];
    [topButton setImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
    topButton.layer.cornerRadius = 20;
    topButton.layer.borderColor = TAB_COLOR.CGColor;
    topButton.layer.borderWidth = 2;
//    [topButton setTitle:@"查询" forState:UIControlStateNormal];
//    [topButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(goTop) forControlEvents:UIControlEventTouchUpInside];
    
    

    NSLog(@"%@",NSStringFromCGRect(topButton.frame));
}

- (void)goTop{
    web.scrollView.contentOffset = CGPointMake(0, -(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10));
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)loadWebView{
    web = [[UIWebView alloc]init];
    [self.view addSubview:web];
    [web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(0);
//        make.edges.equalTo(self.view);
    }];
    web.scrollView.delegate = self;
    web.delegate = self;
    
    [WebModel globalTimelinePostsWithID:_hotModel.ID Block:^(WebModel *webmodel, NSError *error) {
//        NSLog(@"%@",webmodel.content);
        [web loadHTMLString:[WebModel shareInstance].content baseURL:nil];
    }];
    
//    手动布局，不用官方的判断nav来使用
    self.automaticallyAdjustsScrollViewInsets = NO;
//    内容的位置
    web.scrollView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, 0, 0, 0);
    web.scrollView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
//    滚动条的位置
    web.scrollView.scrollIndicatorInsets = web.scrollView.contentInset;
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNV)];
//    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [web addGestureRecognizer:tap];
    
    
    [GMDCircleLoader setOnView:self.view withTitle:@"loading" animated:YES];
}


#pragma gesture.delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
        return YES;
}

- (void)showNV{
    self.navigationController.navigationBar.alpha = 1.f;
    NSLog(@"tap success!");
}


//做一些移除操作,, save
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"touch success!");
//    [maskView setHidden:YES];
    [commitFiled removeFromSuperview];
    
    [maskView removeFromSuperview];
//    [maskView removeFromSuperview];
    //减少使用
    [rightButton setEnabled:YES];
}

#pragma web delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [GMDCircleLoader hideFromView:self.view animated:YES];
}

#pragma web.scrollview  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (web.scrollView.contentOffset.y>0) {
        self.navigationController.navigationBar.alpha = 0;
    } else {
        CGFloat yValue = - web.scrollView.contentOffset.y;//纵向的差距
        CGFloat alphValue = yValue/web.scrollView.contentInset.top;
        self.navigationController.navigationBar.alpha =alphValue;
    }
    
    
//    NSLog(@"contentOffset is: %@",NSStringFromUIEdgeInsets( web.scrollView.contentInset));
}

#pragma textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
//    CGRect frame = textView.frame;
    int offset = 226;//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //    这个表示多长时间完成这个操作
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        textView.frame = CGRectMake(textView.frame.origin.x, offset, textView.frame.size.width, textView.frame.size.height);
    
    [UIView commitAnimations];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self saveData];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


@end
