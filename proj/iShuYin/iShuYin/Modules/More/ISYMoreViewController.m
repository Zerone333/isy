//
//  ISYMoreViewController.m
//  iShuYin
//
//  Created by ND on 2018/10/27.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYMoreViewController.h"
#import "ISYMoreListViewController.h"

@interface ISYMoreViewController ()
@property (nonatomic, strong) HMSegmentedControl *seg;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) ISYMoreListViewController *vc1;
@property (nonatomic, strong) ISYMoreListViewController *vc2;

@end

@implementation ISYMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作者作品";
    [self.view addSubview:self.seg];
    [self.view addSubview:self.contentScrollView];
    
    [self.seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
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

- (HMSegmentedControl *)seg {
    if (!_seg) {
        _seg = [[HMSegmentedControl alloc]init];
        _seg.backgroundColor = [UIColor whiteColor];
        _seg.selectionIndicatorColor = kMainTone;
        _seg.selectionIndicatorHeight = 1.0;
        _seg.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _seg.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _seg.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _seg.sectionTitles = @[@"热播", @"最新"];
        _seg.selectedTitleTextAttributes = @{NSFontAttributeName:kFontSystem(14),NSForegroundColorAttributeName:kMainTone};
        _seg.titleTextAttributes = @{NSFontAttributeName:kFontSystem(14),NSForegroundColorAttributeName:kColorValue(0x9b9b9b)};
        __weak __typeof(self)weakSelf = self;
        _seg.indexChangeBlock = ^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            [self.contentScrollView scrollRectToVisible:CGRectMake(index *kScreenWidth, 0, CGRectGetWidth(self.contentScrollView.frame), CGRectGetHeight(self.contentScrollView.frame)) animated:YES];
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


- (ISYMoreListViewController *)vc1 {
    if (!_vc1) {
        _vc1 = [[ISYMoreListViewController alloc] init];
    }
    return _vc1;
}


- (ISYMoreListViewController *)vc2 {
    if (!_vc2) {
        _vc2 = [[ISYMoreListViewController alloc] init];
    }
    return _vc2;
}
@end
