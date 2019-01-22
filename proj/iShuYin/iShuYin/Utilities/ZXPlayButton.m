//
//  ZXPlayButton.m
//  iShuYin
//
//  Created by Apple on 2017/10/31.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXPlayButton.h"
#import "BookDetailModel.h"
#import "ISYDBManager.h"
#import "ISYHistoryListenModel.h"

@implementation ZXPlayButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addAnimation) name:kNotiNameAnimationAdd object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(delAnimation) name:kNotiNameAnimationDel object:nil];
    }
    return self;
}

- (void)addAnimation {
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    rotateAnimation.autoreverses = NO;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.repeatCount = MAXFLOAT;
    rotateAnimation.duration = 20.0;
    UIButton *btn = [ZXPlayButton plusButton];
    UIImageView *bgImageView = [btn valueForKey:@"_backgroundView"];
    if ([bgImageView isKindOfClass:[UIImageView class]]) {
        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:APPDELEGATE.currentCoverImageURL options:SDWebImageDownloaderScaleDownLargeImages progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            UIButton *btn = [ZXPlayButton plusButton];
            if (image) {
                [btn setBackgroundImage:image forState:UIControlStateNormal];
                [btn setBackgroundImage:image forState:UIControlStateHighlighted];
            }else {
                UIImage *placeholder = [UIImage imageNamed:@"AppIcon"];
                [btn setBackgroundImage:placeholder forState:UIControlStateNormal];
                [btn setBackgroundImage:placeholder forState:UIControlStateHighlighted];
            }
        }];
        [bgImageView.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    }
    
    [self setImage:nil forState:UIControlStateNormal];
}

- (void)delAnimation {
    UIButton *btn = [ZXPlayButton plusButton];
    UIImageView *bgImageView = [btn valueForKey:@"_backgroundView"];
    [bgImageView.layer removeAllAnimations];
    
    [self setImage:[UIImage imageNamed:@"tabbar_btn"] forState:UIControlStateNormal];
}

+ (id)plusButton {
    static ZXPlayButton *btn = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!btn) {
            UIImage *buttonImage = [UIImage imageNamed:@"AppIcon"];
            UIImage *highlightImage = [UIImage imageNamed:@"AppIcon"];
            btn = [ZXPlayButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 52,52);
            btn.layer.cornerRadius = 26;
            btn.layer.masksToBounds = YES;
            btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
            //btn.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
            [btn setImage:[UIImage imageNamed:@"tabbar_btn"] forState:UIControlStateNormal];
            [btn setBackgroundImage:buttonImage forState:UIControlStateNormal];
            [btn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
            [btn addTarget:btn action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
        }
    });
    return btn;
    
    
    /*
    UIImage *buttonImage = [UIImage imageNamed:@"tabbar_play"];
    UIImage *highlightImage = [UIImage imageNamed:@"tabbar_play"];
    ZXPlayButton *button = [ZXPlayButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    button.frame = CGRectMake(0, 0, 52,52);
    [button setImage:[UIImage imageNamed:@"tabbar_btn"] forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    return button;
     */
}

- (void)clickPublish {
    if ([APPDELEGATE.playVC hasBook] == NO) {
        NSArray *list = [[ISYDBManager shareInstance] queryBookHistoryListen];
        ISYHistoryListenModel *model = [list firstObject];
        
        [APPDELEGATE.playVC playWithBook:model.bookModel index:model.chaperNumber duration:model.time];
        UITabBarController *tab = (UITabBarController *)APPDELEGATE.window.rootViewController;
        UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
        APPDELEGATE.playVC.hidesBottomBarWhenPushed = YES;
        if ([nav.viewControllers containsObject:APPDELEGATE.playVC]) {
            [nav popToViewController:APPDELEGATE.playVC animated:YES];
        }else {
            [nav pushViewController:APPDELEGATE.playVC animated:YES];
        }
//        NSString *lastBook = [USERDEFAULTS objectForKey:kLastBook];
//        if ([NSString isEmpty:lastBook]) {
//            return;
//        }
//        BookDetailModel *m = [BookDetailModel yy_modelWithJSON:lastBook];
//        NSNumber *index = [USERDEFAULTS objectForKey:kLastIndex];
//        if (index.integerValue >= m.chapters.count) {
//            return;
//        }
//        [APPDELEGATE.playVC playWithBook:m index:index.integerValue];
//        UITabBarController *tab = (UITabBarController *)APPDELEGATE.window.rootViewController;
//        UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
//        APPDELEGATE.playVC.hidesBottomBarWhenPushed = YES;
//        if ([nav.viewControllers containsObject:APPDELEGATE.playVC]) {
//            [nav popToViewController:APPDELEGATE.playVC animated:YES];
//        }else {
//            [nav pushViewController:APPDELEGATE.playVC animated:YES];
//        }
    }else {
        UITabBarController *tab = (UITabBarController *)APPDELEGATE.window.rootViewController;
        UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
        APPDELEGATE.playVC.hidesBottomBarWhenPushed = YES;
        if ([nav.viewControllers containsObject:APPDELEGATE.playVC]) {
            [nav popToViewController:APPDELEGATE.playVC animated:YES];
        }else {
            [nav pushViewController:APPDELEGATE.playVC animated:YES];
        }
    }
}

+ (NSUInteger)indexOfPlusButtonInTabBar {
    return 2;
}

+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
    return  0.4;
}

+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight {
    return  0;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotiNameAnimationAdd object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotiNameAnimationDel object:nil];
}

@end
