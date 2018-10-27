//
//  UIImage+ZXAdd.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "UIImage+ZXAdd.h"

@implementation UIImage (ZXAdd)

+ (instancetype)imageNamed:(NSString *)name placeholder:(NSString *)placeholder {
    UIImage *image = nil;
    if (name && name.length > 0) {
        image = [UIImage imageNamed:name];
    }
    if (!image && placeholder && placeholder.length > 0) {
        image = [UIImage imageNamed:placeholder];
    }
    return image;
}

+ (instancetype)imageWithContentsOfFile:(NSString *)path placeholder:(NSString *)placeholder {
    UIImage *image = nil;
    if (path && path.length > 0) {
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (!image && placeholder && placeholder.length > 0) {
        image = [UIImage imageNamed:placeholder];
    }
    return image;
}

+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
