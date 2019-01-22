//
//  ISYCategoryMoreHeadView.m
//  iShuYin
//
//  Created by 李艺真 on 2018/12/15.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYCategoryMoreHeadView.h"


@interface ISYCategoryMoreHeadView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation ISYCategoryMoreHeadView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(12);
            make.centerY.equalTo(self);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageView.mas_right).mas_offset(4);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"??";
    }
    return _titleLabel;
}
@end
