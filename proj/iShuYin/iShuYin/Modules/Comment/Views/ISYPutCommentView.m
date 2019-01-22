//
//  ISYPutCommentView.m
//  iShuYin
//
//  Created by ND on 2018/11/10.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYPutCommentView.h"

@interface ISYPutCommentView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) ISYPutCommentViewCallBack callback;
@end

@implementation ISYPutCommentView

- (instancetype)initWithFrame:(CGRect)frame  {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        [IQKeyboardManager sharedManager].enable = NO;
        [self setupUI];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap:(UIGestureRecognizer *)gestureRecognizer {
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self removeFromSuperview];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.contentView.frame, point)) {
        return NO;
    } else {
       
        return YES;
    }
}

#pragma mark keyboardNotification
-(void)keyboardShow:(NSNotification *)note
{
    [self layoutIfNeeded];
    NSDictionary *userInfo = [note userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
   
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).mas_offset(kScreenHeight-keyboardRect.size.height- 230);
        make.height.mas_equalTo(230);
    }];
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [self layoutIfNeeded];
    }];
}

-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(230);
            [self layoutIfNeeded];
        }];
    } completion:^(BOOL finished) {
    }];
}
    

+ (void)showWithCallBack:(ISYPutCommentViewCallBack)callback {
    ISYPutCommentView *view = [[ISYPutCommentView alloc] init];
    view.callback = callback;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(window);
    }];
    [view.textView becomeFirstResponder];
    
}
- (void)putCommentBtnClick{
    if (self.callback != nil) {
        self.callback(self.textView.text);
    }
    [self tap:nil];
}

#pragma mark - private
- (void)setupUI {
    [self addSubview:self.contentView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(12);
        make.top.equalTo(self.contentView).mas_offset(12);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(17);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"评论";
    titleLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(lineView.mas_right).mas_offset(40);
    }];
  
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"发表评论" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(putCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(160, 30));
        make.bottom.equalTo(self.contentView).mas_offset(-10);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).mas_offset(10);
        make.left.equalTo(self.contentView).mas_offset(12);
        make.right.equalTo(self.contentView).mas_offset(-12);
        make.bottom.equalTo(button.mas_top).mas_offset(-10);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.mas_equalTo(230);
    }];
}

#pragma mark -getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 4;
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.layer.borderWidth = 0.5;
        [_textView setInputAccessoryView:nil];
        
        _textView.inputView = nil;
    }
    return _textView;
}
@end
