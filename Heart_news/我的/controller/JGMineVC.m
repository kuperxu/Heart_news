//
//  JGMineVC.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/6.
//  Copyright © 2016年 jiguang. All rights reserved.
//



#import "JGMineVC.h"
#import <Masonry.h>
#define TAB_COLOR [UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:86.0/255.0 alpha:1.0]
#define AUTHOR_COLOR [UIColor colorWithRed:150.0/255.0 green:217.0/255.0 blue:247.0/255.0 alpha:1.0]
@interface JGMineVC ()
@property (nonatomic) CGPoint inputPoint0;
@property (nonatomic) CGPoint inputPoint1;
@property (nonatomic) UIColor *inputColor0;
@property (nonatomic) UIColor *inputColor1;

@end


@implementation JGMineVC
- (void)viewDidLoad{
    [super viewDidLoad];
    CAGradientLayer *layer = [CAGradientLayer new];
    _inputColor0 = [UIColor whiteColor];
    _inputColor1 = AUTHOR_COLOR;
    _inputPoint0 = CGPointMake(0, 0);
    _inputPoint1 = CGPointMake(0, 1);

    layer.colors = @[(__bridge id)_inputColor0.CGColor, (__bridge id)_inputColor1.CGColor];
    layer.startPoint = _inputPoint0;
    layer.endPoint = _inputPoint1;
    layer.frame = self.view.bounds;
//        self.view.layer = layer;
    [self.view.layer addSublayer:layer];
    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    loginButton.backgroundColor = [UIColor clearColor];
    [loginButton setTitle:@"请登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:TAB_COLOR forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
}

- (void)login{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"文本对话框" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"登录";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"密码";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        UITextField *login = alertController.textFields.firstObject;
//        UITextField *password = alertController.textFields.lastObject;
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    [alertController addAction:cancleAction];
    [alertController addAction:okAction];
     [self presentViewController: alertController animated: YES completion: nil];
    
}


@end
