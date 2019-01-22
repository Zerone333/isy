//
//  BookDetailInfoView.m
//  iShuYin
//
//  Created by Apple on 2017/8/14.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookDetailInfoView.h"
#import "BookDetailModel.h"

@interface BookDetailInfoView ()
@property (strong, nonatomic)  UIImageView *imgView;

@property (strong, nonatomic)  UIImageView *directorImageView;
@property (strong, nonatomic)  UIImageView *authorImageView;
@property (strong, nonatomic)  UIImageView *statusImageView;
@property (strong, nonatomic)  UIImageView *timeImageView;
@property (strong, nonatomic)  UIButton *orderButton;

@property (strong, nonatomic)  UILabel *directorLabel;
@property (strong, nonatomic)  UILabel *authorLabel;
@property (strong, nonatomic)  UILabel *statusLabel;
@property (strong, nonatomic)  UILabel *timeLabel;

@end

@implementation BookDetailInfoView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setModel:(BookDetailModel *)model {
    _model = model;
    if ([model.thumb containsString:kPrefixImageDefault]) {
        [_imgView sd_setImageWithURL:[model.thumb url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }else {
        [_imgView sd_setImageWithURL:[[kPrefixImageDefault stringByAppendingString:model.thumb] url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }
    
    self.directorLabel.text = model.director;
    self.authorLabel.text = model.status;
    self.statusLabel.text = model.add_time;
    self.timeLabel.text = model.runtime;
}

#pragma mark - private
- (void)setupUI {
    [self addSubview:self.imgView];
    [self addSubview:self.directorLabel];
    [self addSubview:self.authorLabel];
    [self addSubview:self.statusLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.directorImageView];
    [self addSubview:self.authorImageView];
    [self addSubview:self.statusImageView];
    [self addSubview:self.timeImageView];
    [self addSubview:self.orderButton];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 110));
        make.centerY.equalTo(self);
        make.left.equalTo(self).mas_offset(20);
    }];
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).mas_offset(-20);
    }];
    
    [self.directorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView).mas_offset(0);
        make.left.equalTo(self.imgView.mas_right).mas_offset(16);
        make.size.mas_equalTo(CGSizeMake(22, 110/4));
    }];
    
    [self.authorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.directorImageView.mas_bottom);
        make.left.equalTo(self.directorImageView);
        make.size.mas_equalTo(CGSizeMake(22, 110/4));
    }];
    
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorImageView.mas_bottom);
        make.left.equalTo(self.directorImageView);
        make.size.mas_equalTo(CGSizeMake(22, 110/4));
    }];
    
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusImageView.mas_bottom);
        make.left.equalTo(self.directorImageView);
        make.size.mas_equalTo(CGSizeMake(22, 110/4));
    }];
    
    [self.directorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.directorImageView.mas_right).mas_offset(16);
        make.centerY.equalTo(self.directorImageView);
    }];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.directorLabel);
        make.centerY.equalTo(self.authorImageView);
    }];

    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.directorLabel);
        make.centerY.equalTo(self.statusImageView);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.directorLabel);
        make.centerY.equalTo(self.timeImageView);
    }];
}

#pragma mark - action

- (void)likeBtnClick:(id)sender {
    !_collectionBlock?:_collectionBlock();
}

- (void)shareBtnClick:(id)sender {
    !_shareBlock?:_shareBlock();
}


#pragma mark - getter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UILabel *)directorLabel {
    if (!_directorLabel) {
        _directorLabel = [[UILabel alloc] init];
        _directorLabel.font = [UIFont systemFontOfSize:13];
        _directorLabel.textColor = kColorValue(0x282828);
    }
    return _directorLabel;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:13];
        _authorLabel.textColor = kColorValue(0x282828);
    }
    return _authorLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.textColor = kColorValue(0x282828);
    }
    return _statusLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = kColorValue(0x282828);
    }
    return _timeLabel;
}

- (UIImageView *)directorImageView {
    if (!_directorImageView) {
        _directorImageView = [[UIImageView alloc] init];
        [_directorImageView setImage:[UIImage imageNamed:@"播报icon"]];
        _directorImageView.contentMode = UIViewContentModeCenter;
    }
    return _directorImageView;
}

- (UIImageView *)authorImageView {
    if (!_authorImageView) {
        _authorImageView = [[UIImageView alloc] init];
        [_authorImageView setImage:[UIImage imageNamed:@"进度"]];
        _authorImageView.contentMode = UIViewContentModeCenter;
    }
    return _authorImageView;
}

- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
        [_statusImageView setImage:[UIImage imageNamed:@"更新"]];
        _statusImageView.contentMode = UIViewContentModeCenter;
    }
    return _statusImageView;
}

- (UIImageView *)timeImageView {
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc] init];
        [_timeImageView setImage:[UIImage imageNamed:@"播放次数"]];
        _timeImageView.contentMode = UIViewContentModeCenter;
    }
    return _timeImageView;
}

- (UIButton *)orderButton {
    if (!_orderButton) {
        _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderButton setImage:[UIImage imageNamed:@"订阅btn"] forState:UIControlStateNormal];
        [_orderButton addTarget:self action:@selector(orderBook) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderButton;
}

- (void)orderBook {
    if (self.collectionBlock != nil) {
        self.collectionBlock();
    }
}
@end

