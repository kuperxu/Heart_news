//
//  FootTableViewCell.m
//  Heart_news
//
//  Created by 徐纪光 on 16/6/11.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import "FootTableViewCell.h"
#import <Masonry.h>

@interface FootTableViewCell ( )

//@property (strong, nonatomic) UILabel *titleLabel;
//@property (strong, nonatomic) UILabel *contentLabel;
//@property (strong, nonatomic) UIImageView *contentimage;

@end

@implementation FootTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.titleLabel = [[UILabel alloc]init];
    self.contentLabel = [[UILabel alloc]init];
    self.contentimage = [[UIImageView alloc]init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.font = [UIFont systemFontOfSize:11];
    //        cell.detailTextLabel.numberOfLines = 0;
    self.contentimage.contentMode = UIViewContentModeScaleAspectFill;
    //        cell.imageView.frame = CGRectMake(10, 10, 60, 60);
    
    [self addSubview:_titleLabel];
    [self addSubview:_contentimage];
    [self addSubview:_contentLabel];
    [self.contentimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(20);
        make.size.height.mas_equalTo(70);
        make.size.width.mas_equalTo(70);
        //        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.mas_equalTo(-32);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.right.equalTo(self);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-8);
    }];
    self.contentimage.clipsToBounds = YES;
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
