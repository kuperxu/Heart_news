//
//  DetailCell.m
//  Heart_news
//
//  Created by 徐纪光 on 16/5/12.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "DetailCell.h"
#import "HotDetail.h"
#import "UIImageView+WebCache.h"
#import <Masonry.h>
#import "SDWebImageManager.h"
#import "SDWebImageOperation.h"
#import <AFNetworkReachabilityManager.h>

@interface DetailCell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UILabel *viewLabel;
@end

#define AUTHOR_COLOR [UIColor colorWithRed:150.0/255.0 green:217.0/255.0 blue:247.0/255.0 alpha:1.0]
//#define AUTHOR_COLOR [UIColor whiteColor]
#define TAG_COLOR [UIColor colorWithRed:255.0/255.0 green:91.0/255.0 blue:86.0/255.0 alpha:1.0]



@implementation DetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    //    self.textLabel.adjustsFontSizeToFitWidth = YES;
    //    self.textLabel.textColor = [UIColor darkGrayColor];
    
    
    //    [self addSubview:self.detailTextLabel];
    
    [self createView];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-20);
        make.size.height.mas_equalTo(70);
        make.size.width.mas_equalTo(70);
        //        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    //self.imageView.frame = CGRectMake(200.0f, 10.0f, 50.0f, 50.0f);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(10);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
        
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-90);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.mas_equalTo(-32);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        //        make.right.mas_equalTo(-90);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-8);
    }];
    
    [self.viewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagLabel.mas_right);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-8);
    }];
    //    self.textLabel.frame = CGRectMake(70.0f, 6.0f, 240.0f, 20.0f);
    
    //    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    //    CGFloat calculatedHeight = [[self class] detailTextHeight:self.model.title];
    //    detailTextLabelFrame.size.height = calculatedHeight;
    //    self.detailTextLabel.frame = detailTextLabelFrame;
    
    return self;
}


- (void) createView {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIImageView *contentImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:contentImageView];
    self.contentImageView = contentImageView;
    
    UILabel *userLabel = [[UILabel alloc] init];
    [self.contentView addSubview:userLabel];
    self.tagLabel = userLabel;
    
    
    _viewLabel = ({
        UILabel *viewLabel = [[UILabel alloc] init];
        [self.contentView addSubview:viewLabel];
        viewLabel.textColor = [UIColor grayColor];
        viewLabel.font = [UIFont systemFontOfSize:12.f];
        viewLabel;
    });
    
    self.tagLabel.layer.cornerRadius = 7;
    self.tagLabel.layer.borderColor = TAG_COLOR.CGColor;
    self.tagLabel.layer.borderWidth = 1.f;
    [self.tagLabel setTextColor:TAG_COLOR];
    self.tagLabel.font = [UIFont systemFontOfSize:10.0f];
    
    
    self.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [self.titleLabel setTextColor:AUTHOR_COLOR];
    
    
    self.contentLabel.font = [UIFont systemFontOfSize:17.0f];
    self.contentLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    [self.contentImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.contentImageView.clipsToBounds = YES;
    //    这个是不是很耗费性能一会真机测试看下，不然就拿image直接绘制
}

- (void)setModel:(HotDetail *)model{
    _model = model;
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 8.f;
    NSMutableAttributedString *attributedString;
    if(_model.title){
        attributedString = [[NSMutableAttributedString alloc]initWithString:_model.title];
    }else{
        attributedString = [[NSMutableAttributedString alloc]initWithString:@"莫言"];
    }
    
    
    NSRange range = NSMakeRange(0, _model.title.length);
    //    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:range];
    //    [attributedString addAttribute:NSForegroundColorAttributeName value:AUTHOR_COLOR range:range];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:range];
    
    
    self.titleLabel.text = _model.author;
    self.contentLabel.attributedText = attributedString;
    
    
    UIImage *defaultimage = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:_model.image];
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    UIImage *unload = [UIImage imageNamed:@"unload"];
    if(defaultimage){
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:unload];
    }else if ((![[NSUserDefaults standardUserDefaults]objectForKey:@"noimage"]) || mgr.isReachableViaWiFi) {
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:unload];
    }else{
        [self.contentImageView sd_setImageWithURL:nil placeholderImage:unload];
    }
    //    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:nil];
    self.tagLabel.text = [NSString stringWithFormat:@" %@ ",_model.tags[0]];
    self.viewLabel.text = [NSString stringWithFormat:@" 阅读 %@",_model.view];
    
    //    [self setNeedsLayout];
}


//+ (CGFloat)heightForCellWithPost:(HotDetail *)model {
//    return (CGFloat)fmaxf(70.0f, (float)[self detailTextHeight:model.title] + 45.0f);
//}
//
//+ (CGFloat)detailTextHeight:(NSString *)text {
//    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(240.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0f]} context:nil];
//    return rectToFit.size.height;
//}

//http://www.varpm.com:3002/v1/article/getDetail/100317885

@end
