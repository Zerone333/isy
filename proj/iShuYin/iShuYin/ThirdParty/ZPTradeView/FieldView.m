//
//  FieldView.m
//  PasswordInputView
//
//  Created by 融通汇信 on 15/9/25.
//  Copyright (c) 2015年 融通汇信. All rights reserved.
//

#import "FieldView.h"

@interface FieldView ()
@property (assign, nonatomic) NSInteger num;
@end

@implementation FieldView

- (void)layoutSubviews {
    CGFloat pointW = 1;
    CGFloat pointH = self.frame.size.height;
    CGFloat pointY = 0;
    CGFloat pointX;
    CGFloat margin = self.frame.size.width / 6;
    
    for (int i = 0; i < 5; i++) {
        pointX = i * margin + margin;
        UIView *line = [[UIView alloc]init];
        line.frame = CGRectMake(pointX, pointY, pointW, pointH);
        line.backgroundColor = kColorValue(0xe4e4e4);
        [self addSubview:line];
    }
}

- (void)drawRect:(CGRect)rect {
    UIImage *pointImage = [UIImage imageNamed:@"ph_pswd"];
    CGFloat pointW = self.width * 0.067;
    CGFloat pointH = pointW;
    CGFloat pointY = self.width * 0.033;
    CGFloat pointX;
    CGFloat padding = self.width * 0.05;
    for (int i = 0; i < _num; i++) {
        pointX = padding + i * (pointW + 2 * padding);
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }
}

- (void)drawRect:(CGRect)rect number:(NSInteger)num {
    _num = num;
    [self setNeedsDisplay];
}

@end
