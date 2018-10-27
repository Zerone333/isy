//
//  UILabel+ZXAdd.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZXAdd)

+ (instancetype)labelWithFont:(UIFont *)font text:(NSString *)text textColor:(UIColor *)textColor;

+ (instancetype)labelWithFont:(UIFont *)font text:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)number lineBreakMode:(NSLineBreakMode)mode backgroundColor:(UIColor *)backgroundColor adjustsFontSizeToFitWidth:(BOOL)adjusts;

+ (instancetype)navigationItemTitleViewWithText:(NSString *)text;

@end
