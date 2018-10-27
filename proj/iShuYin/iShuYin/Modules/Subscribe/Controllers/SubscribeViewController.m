//
//  SubscribeViewController.m
//  iShuYin
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "SubscribeViewController.h"
#import "SubscribeHeader.h"
#import "SubscribeListViewController.h"

@interface SubscribeViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong) SubscribeHeader *header;
@property (nonatomic, strong) HMSegmentedControl *seg;
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) NSMutableArray *vcArray;
@end

@implementation SubscribeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.header reloadHeader];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
    [self configPageVC];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"私定"];
    [self.view addSubview:self.header];
    [self.view addSubview:self.seg];
}


- (void)configPageVC {
    _vcArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        SubscribeListViewController *vc = [[SubscribeListViewController alloc]init];
        vc.listType = i;
        [_vcArray addObject:vc];
    }
    [self.pageVC setViewControllers:@[_vcArray[0]]
                          direction:UIPageViewControllerNavigationDirectionForward
                           animated:NO
                         completion:nil];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [_vcArray indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    return _vcArray[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [_vcArray indexOfObject:viewController];
    if (index == _vcArray.count-1 || index == NSNotFound) {
        return nil;
    }
    return _vcArray[++index];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    NSInteger index = [_vcArray indexOfObject:pageViewController.viewControllers.lastObject];
    self.seg.selectedSegmentIndex = index;
}

#pragma mark - Getter
- (SubscribeHeader *)header {
    if (!_header) {
        _header = [SubscribeHeader loadFromNib];
        _header.frame = CGRectMake(0, kNavBarOffset, kScreenWidth, 128);
    }
    return _header;
}

- (HMSegmentedControl *)seg {
    if (!_seg) {
        _seg = [[HMSegmentedControl alloc]init];
        _seg.frame = CGRectMake(0, kNavBarOffset+128, kScreenWidth, 44);
        _seg.backgroundColor = [UIColor whiteColor];
        _seg.selectionIndicatorColor = kMainTone;
        _seg.selectionIndicatorHeight = 1.0;
        _seg.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _seg.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _seg.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _seg.sectionTitles = @[@"我的下载",@"我的收藏",@"最近收听"];
        _seg.selectedTitleTextAttributes = @{NSFontAttributeName:kFontSystem(13),
                                             NSForegroundColorAttributeName:kMainTone};
        _seg.titleTextAttributes = @{NSFontAttributeName:kFontSystem(13),
                                     NSForegroundColorAttributeName:kColorValue(0x4a4a4a)};
        __weak __typeof(self)weakSelf = self;
        _seg.indexChangeBlock = ^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSInteger last = [strongSelf.vcArray indexOfObject:strongSelf.pageVC.viewControllers.lastObject];
            UIPageViewControllerNavigationDirection direction = (index > last)?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse;
            [strongSelf.pageVC setViewControllers:@[strongSelf.vcArray[index]]
                                        direction:direction
                                         animated:YES
                                       completion:nil];
        };
    }
    return _seg;
}

- (UIPageViewController *)pageVC {
    if (!_pageVC) {
        _pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageVC.delegate = self;
        _pageVC.dataSource = self;
        _pageVC.view.frame = CGRectMake(0, kNavBarOffset+128+44, kScreenWidth, self.view.bounds.size.height-kNavBarOffset-128-44-kTabBarOffset);
        [self addChildViewController:_pageVC];
        [self.view addSubview:_pageVC.view];
    }
    return _pageVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
