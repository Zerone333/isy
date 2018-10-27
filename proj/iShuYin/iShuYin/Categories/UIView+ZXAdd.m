//
//  UIView+ZXAdd.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "UIView+ZXAdd.h"

@implementation UIView (ZXAdd)

-(CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect r = self.frame;
    [self setFrame:CGRectMake(left,r.origin.y, r.size.width, r.size.height)];
}

-(CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setRight:(CGFloat)right {
    CGRect r = self.frame;
    [self setFrame:CGRectMake(right-r.size.width,r.origin.y, r.size.width, r.size.height)];
}

-(CGFloat)top {
    return self.frame.origin.y;
}

-(void)setTop:(CGFloat)top {
    CGRect r = self.frame;
    [self setFrame:CGRectMake(r.origin.x, top, r.size.width, r.size.height)];
}

-(CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

-(void)setBottom:(CGFloat)bottom {
    CGRect r = self.frame;
    [self setFrame:CGRectMake(r.origin.x, bottom-r.size.height, r.size.width, r.size.height)];
}

-(CGFloat)width {
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width {
    CGRect r = self.frame;
    [self setFrame:CGRectMake(r.origin.x, r.origin.y, width, r.size.height)];
}

-(CGFloat)height {
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height {
    CGRect r = self.frame;
    [self setFrame:CGRectMake(r.origin.x, r.origin.y, r.size.width, height)];
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)removeAllSubviews {
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
}

- (UIViewController *)containerViewController {
    UIViewController *vc = nil;
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    }
    return vc;
}

+ (instancetype)loadFromNib {
    NSArray *elements = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class])
                                                     owner:nil
                                                   options:nil];
    for (id obj in elements) {
        if ([obj isKindOfClass:[self class]]) {
            return obj;
        }
    }
    return nil;
}

@end
