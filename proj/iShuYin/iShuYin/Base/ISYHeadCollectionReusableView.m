//
//  ISYHeadCollectionReusableView.m
//  iShuYin
//
//  Created by ND on 2018/11/13.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYHeadCollectionReusableView.h"

@interface ISYHeadCollectionReusableView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ISYHeadCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageView];
        [self addSubview:self.clearHistoryBtn];
        self.clearHistoryBtn.hidden = YES;
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(12);
            make.centerY.equalTo(self);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).mas_offset(0);
            make.centerY.equalTo(self);
        }];
        [self.clearHistoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-50);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor redColor];
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (UIButton *)clearHistoryBtn {
    if (!_clearHistoryBtn) {
        _clearHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearHistoryBtn setTitle:@"  清空" forState:UIControlStateNormal];
        [_clearHistoryBtn setImage:[UIImage imageNamed:@"search_delete"] forState:UIControlStateNormal];
        _clearHistoryBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_clearHistoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_clearHistoryBtn addTarget:self action:@selector(clearHistoryAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearHistoryBtn;
}

- (void)clearHistoryAction {
    self.completion ? self.completion() : nil;
}

@end
