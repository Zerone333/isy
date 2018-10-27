//
//  ZXTextView.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXTextView.h"

@interface ZXTextView ()
@property (nonatomic, readwrite, strong) UITextView *placeView;//展示placeholder
@end

@implementation ZXTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _lineSpace = 0;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        _lineSpace = 0;
    }
    return self;
}

- (void)setup {
    [NOTIFICATIONCENTER addObserver:self
                           selector:@selector(zxTextChange)
                               name:UITextViewTextDidChangeNotification
                             object:nil];
    _placeView = [[UITextView alloc]initWithFrame:self.bounds];
    _placeView.font = kFontSystem(13);
    _placeView.textColor = kColorValue(0x9c9c9c);
    _placeView.backgroundColor = [UIColor clearColor];
    _placeView.editable = NO;
    _placeView.scrollEnabled = NO;
    _placeView.userInteractionEnabled = NO;
    _placeView.showsVerticalScrollIndicator = NO;
    _placeView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_placeView];
}

#pragma mark - OverWrite
- (void)layoutSubviews {
    _placeView.frame = self.bounds;
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
    [_placeView setTextContainerInset:textContainerInset];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    _placeView.hidden = text.length;
    if (_lineSpace) {
        [self configTextLineSpace];
    }
}

#pragma mark - Setter & Getter
- (void)setLineSpace:(CGFloat)lineSpace {
    _lineSpace = lineSpace;
    [self configTextLineSpace];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeView.text = placeholder;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    _placeView.font = placeholderFont;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    _placeView.textColor = placeholderColor;
}

#pragma mark - Notification
- (void)zxTextChange {
    _placeView.hidden = self.text.length;
    if (_lineSpace) {
        [self configTextLineSpace];
    }
}

- (void)configTextLineSpace {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = _lineSpace;
    NSDictionary *attr = @{NSFontAttributeName:self.font?self.font:kFontSystem(13),
                           NSParagraphStyleAttributeName:style};
    self.attributedText = [[NSAttributedString alloc]initWithString:self.text attributes:attr];
}

- (void)dealloc {
    [NOTIFICATIONCENTER removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    _placeView = nil;
}

@end
