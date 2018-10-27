//
//  UILabel+ZXAdd.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "UILabel+ZXAdd.h"

@implementation UILabel (ZXAdd)

+ (instancetype)labelWithFont:(UIFont *)font text:(NSString *)text textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc]init];
    if (font) {
        label.font = font;
    }
    if (text.length && [text isKindOfClass:[NSString class]]) {
        label.text = text;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    [label sizeToFit];
    return label;
}

+ (instancetype)labelWithFont:(UIFont *)font text:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)number lineBreakMode:(NSLineBreakMode)mode backgroundColor:(UIColor *)backgroundColor adjustsFontSizeToFitWidth:(BOOL)adjusts {
    UILabel *label = [[UILabel alloc]init];
    if (font) {
        label.font = font;
    }
    if (text && [text isKindOfClass:[NSString class]]) {
        label.text = text;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (backgroundColor) {
        label.backgroundColor = backgroundColor;
    }
    label.textAlignment = alignment;
    label.numberOfLines = number;
    label.lineBreakMode = mode;
    label.adjustsFontSizeToFitWidth = adjusts;
    return label;
}

+ (instancetype)navigationItemTitleViewWithText:(NSString *)text {
    return [self labelWithFont:kFontBold(16) text:text textColor:[UIColor whiteColor]];
}

@end
