//
//  FootTableViewCell.h
//  Heart_news
//
//  Created by 徐纪光 on 16/6/11.
//  Copyright © 2016年 jiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIImageView *contentimage;
@end
