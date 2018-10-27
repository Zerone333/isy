//
//  FinishManageViewController.m
//  iShuYin
//
//  Created by Apple on 2017/8/6.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "FinishManageViewController.h"
#import "FinishListViewController.h"

@interface FinishManageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong) HMSegmentedControl *seg;
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) NSMutableArray *vcArray;
@end

@implementation FinishManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
    [self configPageVC];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"完结"];
    [self.view addSubview:self.seg];
}

- (void)configPageVC {
    _vcArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        FinishListViewController *vc = [[FinishListViewController alloc]init];
        vc.type = i+1;
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
- (HMSegmentedControl *)seg {
    if (!_seg) {
        _seg = [[HMSegmentedControl alloc]init];
        _seg.frame = CGRectMake(0, kNavBarOffset, kScreenWidth, 44);
        _seg.backgroundColor = [UIColor whiteColor];
        _seg.selectionIndicatorColor = kMainTone;
        _seg.selectionIndicatorHeight = 1.0;
        _seg.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _seg.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _seg.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _seg.sectionTitles = @[@"推荐",@"热播",@"新书"];
        _seg.selectedTitleTextAttributes = @{NSFontAttributeName:kFontSystem(14),
                                             NSForegroundColorAttributeName:kMainTone};
        _seg.titleTextAttributes = @{NSFontAttributeName:kFontSystem(14),
                                     NSForegroundColorAttributeName:kColorValue(0x9b9b9b)};
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
        _pageVC.view.frame = CGRectMake(0, kNavBarOffset+44, kScreenWidth, self.view.bounds.size.height-kNavBarOffset-44);
        UIScreenEdgePanGestureRecognizer *edgePan = [[ZXTools shareTools]screenEdgePanGestureRecognizerWithViewController:self.navigationController];
        for (UIView *subview in _pageVC.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scrollView = (UIScrollView *)subview;
                [scrollView.panGestureRecognizer requireGestureRecognizerToFail:edgePan];
                break;
            }
        }
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
