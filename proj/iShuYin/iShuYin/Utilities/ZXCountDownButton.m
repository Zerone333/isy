//
//  ZXCountDownButton.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXCountDownButton.h"

@interface ZXCountDownButton ()
@property(nonatomic,strong)CADisplayLink *link;
@property(nonatomic,strong)NSString *originTitle;
@property(nonatomic,assign)NSInteger originNum;
@end

@implementation ZXCountDownButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.originTitle = self.currentTitle;
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [[super class]buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.frame = frame;
        self.enabled = NO;
        self.originTitle = title;
        self.layer.cornerRadius = 6.0;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitle:title forState:UIControlStateNormal];
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Actions
- (void)btnClick:(UIButton *)btn {
    //
    self.enabled = NO;
    [self setTitle:[NSString stringWithFormat:@"%li秒后重发",(long)_clockNum]
          forState:UIControlStateNormal];
    //
    self.link = [CADisplayLink displayLinkWithTarget:self
                                            selector:@selector(countdown:)];
    self.link.frameInterval = 60;
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //
    if (_targetBlock)
        _targetBlock();
    else if (_delegate && [_delegate respondsToSelector:@selector(countDownButtonDidClick:)])
        [_delegate countDownButtonDidClick:self];
}

- (void)countdown:(CADisplayLink *)link {
    --_clockNum;
    if (!_clockNum) {
        self.enabled = YES;
        [self setTitle:_originTitle forState:UIControlStateNormal];
        [link invalidate];
        [link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        link = nil;
        self.clockNum = _originNum;
        return;
    }
    NSString *title = [NSString stringWithFormat:@"%li秒后重发",(long)_clockNum];
    [self setTitle:title forState:UIControlStateNormal];
}

#pragma mark - setter
- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled) {
        self.backgroundColor = _enabledBackgroundColor?_enabledBackgroundColor:[UIColor redColor];
        [self setTitleColor:_enabledTitleColor?_enabledTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
    }else {
        self.backgroundColor = _disabledBackgroundColor?_disabledBackgroundColor:[UIColor lightGrayColor];
        [self setTitleColor:_disabledTitleColor?_disabledTitleColor:[UIColor grayColor]
                   forState:UIControlStateNormal];
    }
}

- (void)setPause:(BOOL)pause {
    _pause = pause;
    self.link.paused = pause;
}

- (void)setClockNum:(NSInteger)clockNum {
    _clockNum = clockNum;
    _originNum = clockNum;
}

- (void)setFrameInterval:(NSInteger)frameInterval {
    _frameInterval = frameInterval;
    self.link.frameInterval = frameInterval;
}

- (void)setEnabledTitleColor:(UIColor *)enabledTitleColor {
    if (_enabledTitleColor != enabledTitleColor) {
        _enabledTitleColor = nil;
        _enabledTitleColor = enabledTitleColor;
        if (self.enabled)
            [self setTitleColor:enabledTitleColor forState:UIControlStateNormal];
    }
}

- (void)setEnabledBackgroundColor:(UIColor *)enabledBackgroundColor {
    if (_enabledBackgroundColor != enabledBackgroundColor) {
        _enabledBackgroundColor = nil;
        _enabledBackgroundColor = enabledBackgroundColor;
        if (self.enabled)
            self.backgroundColor = enabledBackgroundColor;
    }
}

- (void)setDisabledTitleColor:(UIColor *)disabledTitleColor {
    if (_disabledTitleColor != disabledTitleColor) {
        _disabledTitleColor = nil;
        _disabledTitleColor = disabledTitleColor;
        if (!self.enabled)
            [self setTitleColor:disabledTitleColor forState:UIControlStateNormal];
    }
}

- (void)setDisabledBackgroundColor:(UIColor *)disabledBackgroundColor {
    if (_disabledBackgroundColor != disabledBackgroundColor) {
        _disabledBackgroundColor = nil;
        _disabledBackgroundColor = disabledBackgroundColor;
        if (!self.enabled)
            self.backgroundColor = disabledBackgroundColor;
    }
}

@end
