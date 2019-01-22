//
//  ISYCategoryFilterCollectionCell.m
//  iShuYin
//
//  Created by 李艺真 on 2018/12/17.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYCategoryFilterCollectionCell.h"
@interface ISYCategoryFilterCollectionCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ISYCategoryFilterCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
            self.contentView.layer.borderWidth = 0.5f;
            self.contentView.layer.borderColor = kColorValue(0x666666).CGColor;
            self.contentView.layer.masksToBounds = YES;
            self.contentView.layer.cornerRadius = 2.f;
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.contentView.backgroundColor = kMainTone;
        self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = kColorValue(0x666666);
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = kColorValue(0x666666);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end


