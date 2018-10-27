//
//  UIButton+ZXAdd.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZXAdd)

+ (instancetype)buttonWithFrame:(CGRect)frame font:(UIFont *)font title:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

+ (instancetype)buttonWithFrame:(CGRect)frame image:(NSString *)imgName target:(id)target action:(SEL)action;

@end
