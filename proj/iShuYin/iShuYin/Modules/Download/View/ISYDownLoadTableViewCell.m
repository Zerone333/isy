//
//  DownLoadTableViewCell.m
//  iShuYin
//
//  Created by ND on 2018/10/28.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYDownLoadTableViewCell.h"
@interface ISYDownLoadTableViewCell ()
@property (nonatomic, strong) UILabel *label1;      //已经下载
@property (nonatomic, strong)UILabel *label2;   // 占用内存
@property (nonatomic, strong) UIImageView *downLoadIcon;
@property (nonatomic, strong) UILabel *label3;  // 正在下载
@property (nonatomic, strong) UIButton *button;
@end
@implementation ISYDownLoadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:[ISYDownLoadTableViewCell cellID]]) {
  
        [self setupUI2];
    }return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellID {
    return @"DownLoadTableViewCellID";
}

- (void)setupUI2 {
    [self.contentView addSubview:self.label1];
    [self.contentView addSubview:self.label2];
    [self.contentView addSubview:self.label3];
    [self.contentView addSubview:self.downLoadIcon];
    [self.contentView addSubview:self.button];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.thumImageView);
        make.left.equalTo(self.nameLabel);
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label1.mas_bottom).mas_offset(6);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.downLoadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.thumImageView).mas_offset(-8);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downLoadIcon);
        make.left.equalTo(self.downLoadIcon.mas_right).mas_offset(4);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).mas_offset(-20);
        make.size.mas_equalTo(CGSizeMake(80, 32));
    }];
    
}

- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        _label1.text = @"已经下载";
    }
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"占用";
    }
    return _label2;
}

- (UILabel *)label3 {
    if (!_label3) {
        _label3 = [[UILabel alloc] init];
        _label3.text = @"正在下载";
    }
    return _label3;
}

- (UIImageView *)downLoadIcon {
    if (!_downLoadIcon) {
        _downLoadIcon = [[UIImageView alloc] init];
        _downLoadIcon.image = [UIImage imageNamed:@"已下载"];
    }
    return _downLoadIcon;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = kColorRGB(231, 32, 35);
        [_button setTitle:@"继续下载" forState:UIControlStateNormal];
    }
    return _button;
}

@end
