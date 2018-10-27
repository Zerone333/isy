//
//  UIImage+ZXAdd.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZXAdd)

+ (instancetype)imageNamed:(NSString *)name placeholder:(NSString *)placeholder;

+ (instancetype)imageWithContentsOfFile:(NSString *)path placeholder:(NSString *)placeholder;

+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
