//
//  ZXInputView.m
//  JWXUserClient
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 angxun. All rights reserved.
//

#import "ZXInputView.h"

@interface ZXInputView ()
{
    NSInteger _maxH;
    NSInteger _textH;
}
@end

@implementation ZXInputView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [NOTIFICATIONCENTER addObserver:self selector:@selector(inputViewTextChange) name:UITextViewTextDidChangeNotification object:nil];
        self.scrollsToTop = NO;
        self.scrollEnabled = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [NOTIFICATIONCENTER addObserver:self selector:@selector(inputViewTextChange) name:UITextViewTextDidChangeNotification object:nil];
        self.scrollsToTop = NO;
        self.scrollEnabled = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines {
    _maxNumberOfLines = maxNumberOfLines;
    _maxH = ceil(self.textContainerInset.top +
                 self.textContainerInset.bottom +
                 self.lineSpace * (maxNumberOfLines - 1) +
                 self.font.lineHeight * maxNumberOfLines);
}

- (void)inputViewTextChange {
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.width, MAXFLOAT)].height);
    if (_textH != height) {
        self.scrollEnabled = height > _maxH && _maxH > 0;
        _textH = height;
        
        __weak __typeof(self)weakSelf = self;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        !_changeHeightBlock?:_changeHeightBlock(strongSelf->_maxH);
        self.placeView.frame = self.bounds;
        [self.superview layoutIfNeeded];
        
        if (!self.scrollEnabled) {
            !_changeHeightBlock?:_changeHeightBlock(height);
            self.placeView.frame = self.bounds;
            [self.superview layoutIfNeeded];
        }
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self inputViewTextChange];
}

- (void)dealloc {
    [NOTIFICATIONCENTER removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

@end
