//
//  ISYDownLoadViewController.m
//  iShuYin
//
//  Created by ND on 2018/10/28.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYDownLoadViewController.h"
#import "ISYDownLoadListViewController.h"

@interface ISYDownLoadViewController ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) HMSegmentedControl *seg;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) ISYDownLoadListViewController *vc1;
@property (nonatomic, strong) ISYDownLoadListViewController *vc2;
@end

@implementation ISYDownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下载";
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.label];
    
    [self.view addSubview:self.seg];
    [self.view addSubview:self.contentScrollView];
    
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topView);
    }];
    
    [self.seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    
    [self.contentScrollView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seg.mas_bottom);
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [self.contentScrollView addSubview:contentView];
    
    [contentView addSubview:self.vc1.view];
    [contentView addSubview:self.vc2.view];
    
    [self addChildViewController:self.vc1];
    [self addChildViewController:self.vc2];
    
    [self.vc1.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(contentView);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.vc2.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(contentView);
        make.left.equalTo(self.vc1.view.mas_right);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentScrollView);
        make.height.mas_equalTo(self.contentScrollView);
        make.top.equalTo(self.contentScrollView);
        make.right.equalTo(self.vc2.view);
    }];
}

#pragma mark - getter
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = kColorRGB(247, 247, 247);
    }
    return _topView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"xxx";
    }
    return _label;
}


- (HMSegmentedControl *)seg {
    if (!_seg) {
        _seg = [[HMSegmentedControl alloc]init];
        _seg.backgroundColor = [UIColor whiteColor];
        _seg.selectionIndicatorColor = kMainTone;
        _seg.selectionIndicatorHeight = 1.0;
        _seg.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _seg.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _seg.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _seg.sectionTitles = @[@"已下载", @"下载中"];
        _seg.selectedTitleTextAttributes = @{NSFontAttributeName:kFontSystem(14),NSForegroundColorAttributeName:kMainTone};
        _seg.titleTextAttributes = @{NSFontAttributeName:kFontSystem(14),NSForegroundColorAttributeName:kColorValue(0x9b9b9b)};
        __weak __typeof(self)weakSelf = self;
        _seg.indexChangeBlock = ^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.contentScrollView scrollRectToVisible:CGRectMake(index *kScreenWidth, 0, CGRectGetWidth(strongSelf.contentScrollView.frame), CGRectGetHeight(strongSelf.contentScrollView.frame)) animated:YES];
        };
    }
    return _seg;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.scrollEnabled = NO;
    }
    return _contentScrollView;
}


- (ISYDownLoadListViewController *)vc1 {
    if (!_vc1) {
        _vc1 = [[ISYDownLoadListViewController alloc] init];
    }
    return _vc1;
}


- (ISYDownLoadListViewController *)vc2 {
    if (!_vc2) {
        _vc2 = [[ISYDownLoadListViewController alloc] init];
    }
    return _vc2;
}
@end
