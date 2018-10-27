//
//  UIButton+ZXAdd.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "UIButton+ZXAdd.h"

@implementation UIButton (ZXAdd)

+ (instancetype)buttonWithFrame:(CGRect)frame font:(UIFont *)font title:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (font) {
        btn.titleLabel.font = font;
    }
    if (title.length) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if ([NSStringFromCGRect(frame) isEqualToString:NSStringFromCGRect(CGRectZero)]) {
        [btn sizeToFit];
    }else {
        btn.frame = frame;
    }
    return btn;
}

+ (instancetype)buttonWithFrame:(CGRect)frame image:(NSString *)imgName target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imgName.length) {
        [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    }
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if ([NSStringFromCGRect(frame) isEqualToString:NSStringFromCGRect(CGRectZero)]) {
        [btn sizeToFit];
    }else {
        btn.frame = frame;
    }
    return btn;
}

@end
