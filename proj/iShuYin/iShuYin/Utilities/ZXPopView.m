//
//  ZXPopView.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXPopView.h"
#import "UpdateForceView.h"
#import "UpdateRemindView.h"
#import "FeedbackTypeView.h"
#import "SharePlatformView.h"
#import "SleepView.h"

@interface ZXPopView ()

@property (nonatomic, readwrite, assign)ZXPopViewStyle style;

@end

@implementation ZXPopView

//版本强制更新弹窗(只一个按钮：立即更新)
- (instancetype)initWithVersionInfoForce:(NSDictionary *)info {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.style = ZXPopViewStyleVersionForce;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        UpdateForceView *view = [UpdateForceView loadFromNib];
        view.frame = self.bounds;
        view.content = @"已发布新版本，请前往更新。";
        view.link_url = kAppDownloadURL;
        __weak __typeof(self)weakSelf = self;
        view.dismissBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dismissWithAnimated:ZXPopViewAnimatedScale];
        };
        [self addSubview:view];
    }
    return self;
}

//首页版本更新检测(有两个按钮：以后再说，立即更新)
- (instancetype)initWithVersionInfoRemind:(NSDictionary *)info {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.style = ZXPopViewStyleVersionRemind;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        UpdateRemindView *view = [UpdateRemindView loadFromNib];
        view.frame = self.bounds;
        view.content = @"已发布新版本，请前往更新。";
        view.link_url = kAppDownloadURL;
        __weak __typeof(self)weakSelf = self;
        view.dismissBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dismissWithAnimated:ZXPopViewAnimatedScale];
        };
        [self addSubview:view];
    }
    return self;
}

- (instancetype)initWithFeedbackTypeSelectBlock:(void (^)(NSDictionary *dict))selectBlock {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.style = ZXPopViewStyleFeedbackType;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        FeedbackTypeView *view = [FeedbackTypeView loadFromNib];
        view.frame = CGRectMake(0, kScreenHeight-200, kScreenWidth, 200);
        view.selectBlock = selectBlock;
        __weak __typeof(self)weakSelf = self;
        view.dismissBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dismissWithAnimated:ZXPopViewAnimatedSlip];
        };
        [self addSubview:view];
        
        UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-200)];
        tapView.backgroundColor = [UIColor clearColor];
        tapView.tag = 1003;
        [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewDismiss:)]];
        [self addSubview:tapView];
    }
    return self;
}

- (instancetype)initWithShareBlock:(void (^)(NSInteger))shareBlock {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.style = ZXPopViewStyleSharePlatform;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        SharePlatformView *view = [SharePlatformView loadFromNib];
        view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 188);
        __weak __typeof(self)weakSelf = self;
        view.shareBlock = shareBlock;
        view.dismissBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dismissWithAnimated:ZXPopViewAnimatedSlip];
        };
        [self addSubview:view];
        
        UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-188)];
        tapView.backgroundColor = [UIColor clearColor];
        tapView.tag = 1003;
        [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewDismiss:)]];
        [self addSubview:tapView];
    }
    return self;
}

- (instancetype)initSleepCountDownView {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.style = ZXPopViewStyleSleepSheet;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        SleepView *view= [SleepView loadFromNib];
        view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44*6+1);
        __weak __typeof(self)weakSelf = self;
        view.dismissBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dismissWithAnimated:ZXPopViewAnimatedSlip];
        };
        [self addSubview:view];
    }
    return self;
}

#pragma mark - Methods
- (void)showInView:(UIView *)view animated:(ZXPopViewAnimated)animated {
    [view addSubview:self];
    UIView *subView = self.subviews.firstObject;
    if (!subView) return;
    switch (animated) {
        case ZXPopViewAnimatedNone:break;
        case ZXPopViewAnimatedDrop:{
            CGFloat y = subView.frame.origin.y;
            subView.alpha = 0.0;
            subView.top = -subView.height;
            [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                subView.alpha = 1.0;
                subView.top = y;
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case ZXPopViewAnimatedSlip:{
            subView.top = kScreenHeight;
            [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                subView.top = kScreenHeight - subView.height;
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case ZXPopViewAnimatedScale:{
            [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                subView.transform = CGAffineTransformScale(subView.transform, 1.5, 1.5);
                subView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                subView.transform = CGAffineTransformIdentity;
            }];
        }
            break;
        default:
            break;
    }
}

- (void)dismissWithAnimated:(ZXPopViewAnimated)animated {
    UIView *subView = self.subviews.firstObject;
    if (!subView) {
        [self removeFromSuperview];
        return;
    }
    switch (animated) {
        case ZXPopViewAnimatedNone:{
            [self removeFromSuperview];
        }
            break;
        case ZXPopViewAnimatedDrop:{
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                subView.alpha = 0.8;
                subView.top += 20;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.alpha = 0.0;
                    subView.alpha = 0.3;
                    subView.top = -subView.height;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                    self.alpha = 1.0;
                }];
            }];
        }
            break;
        case ZXPopViewAnimatedSlip:{
            [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.alpha = 0.0;
                subView.top = kScreenHeight;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                self.alpha = 1.0;
            }];
        }
            break;
        case ZXPopViewAnimatedScale:{
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.alpha = 0.0;
                subView.alpha = 0.0;
                subView.transform = CGAffineTransformScale(subView.transform, 0.2, 0.2);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                self.alpha = 1.0;
            }];
        }
            break;
        default:{
            [self removeFromSuperview];
        }
            break;
    }
}

- (void)tapViewDismiss:(UITapGestureRecognizer *)tap {
    UIView *tapView = tap.view;
    [self dismissWithAnimated:tapView.tag-1000];
}

@end
