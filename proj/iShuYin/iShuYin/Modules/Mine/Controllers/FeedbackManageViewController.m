//
//  FeedbackManageViewController.m
//  iShuYin
//
//  Created by Apple on 2017/9/19.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "FeedbackManageViewController.h"
#import "FeedbackListViewController.h"

@interface FeedbackManageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong) HMSegmentedControl *seg;
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) NSMutableArray *vcArray;
@end

@implementation FeedbackManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
    [self configPageVC];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"我的留言"];
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.seg];
}

- (void)configPageVC {
    _vcArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        FeedbackListViewController *vc = [[FeedbackListViewController alloc]init];
        vc.type = i;
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
        _seg.frame = CGRectMake(0, kNavBarOffset, kScreenWidth, 39);
        _seg.backgroundColor = [UIColor whiteColor];
        _seg.selectionIndicatorColor = kMainTone;
        _seg.selectionIndicatorHeight = 1.0;
        _seg.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _seg.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _seg.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _seg.sectionTitles = @[@"留言",@"咨询",@"报错",@"求书"];
        _seg.selectedTitleTextAttributes = @{NSFontAttributeName:kFontSystem(13),
                                             NSForegroundColorAttributeName:kMainTone};
        _seg.titleTextAttributes = @{NSFontAttributeName:kFontSystem(13),
                                     NSForegroundColorAttributeName:kColorValue(0x4a4a4a)};
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 39, kScreenWidth, 1);
        layer.backgroundColor = kColorValue(0xe4e4e4).CGColor;
        [_seg.layer addSublayer:layer];
        
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
        _pageVC.view.frame = CGRectMake(0, kNavBarOffset+40, kScreenWidth, self.view.bounds.size.height-kNavBarOffset-40);
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
