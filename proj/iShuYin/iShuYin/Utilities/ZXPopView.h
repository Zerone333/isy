//
//  ZXPopView.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZXPopViewStyle) {
    ZXPopViewStyleVersionForce = 0,
    ZXPopViewStyleVersionRemind,
    ZXPopViewStyleFeedbackType,
    ZXPopViewStyleSharePlatform,
    ZXPopViewStyleSleepSheet,
};

typedef NS_ENUM(NSInteger,ZXPopViewAnimated) {
    ZXPopViewAnimatedNone = 1,
    ZXPopViewAnimatedDrop = 2,
    ZXPopViewAnimatedSlip = 3,
    ZXPopViewAnimatedScale = 4,
};

@interface ZXPopView : UIView

@property (nonatomic, readonly, assign)ZXPopViewStyle style;

- (instancetype)initWithVersionInfoForce:(NSDictionary *)info;

- (instancetype)initWithVersionInfoRemind:(NSDictionary *)info;

- (instancetype)initWithFeedbackTypeSelectBlock:(void (^)(NSDictionary *dict))selectBlock;

- (instancetype)initWithShareBlock:(void (^)(NSInteger))shareBlock;

- (instancetype)initSleepCountDownView;

- (void)showInView:(UIView *)view animated:(ZXPopViewAnimated)animated;

@end
