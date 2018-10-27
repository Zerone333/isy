//
//  ZPTradeInputView.m
//  zp
//
//  Created by zp on 15/9/25.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "ZPTradeInputView.h"
#import "FieldView.h"

static const NSInteger ZPTradeInputViewNumCount = 6;

@interface ZPTradeInputView () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *sureBtn;//确定按钮
@property (nonatomic, strong) UIButton *cancleBtn;//取消按钮
@property (nonatomic, strong) FieldView *fieldView;
@property (nonatomic, strong) NSMutableArray *numsArray;//数字数组
@end

@implementation ZPTradeInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
        [self setupResponsder];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputViewTap:)]];
    }
    return self;
}

- (void)setupSubViews {
    CGFloat margin = self.width * 0.05;
    
    //取消按钮
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.layer.cornerRadius = 6.0;
    _cancleBtn.backgroundColor = kMainTone;
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancleBtn];
    _cancleBtn.frame = CGRectMake(margin,
                                  self.height-(self.width*0.05+_cancleBtn.height),
                                  (self.width-3*margin)*0.5,
                                  self.width*0.128125);
    
    //确定按钮
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.layer.cornerRadius = 6.0;
    _sureBtn.backgroundColor = [UIColor lightGrayColor];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(ensureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureBtn];
    _sureBtn.frame = CGRectMake(CGRectGetMaxX(_cancleBtn.frame)+margin,
                                _cancleBtn.top,
                                _cancleBtn.width,
                                _cancleBtn.height);

    //标题
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"请输入支付密码";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width * 0.043125];
    _titleLabel.textColor =  [UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1.0];
    [_titleLabel sizeToFit];
    [self addSubview:_titleLabel];
    _titleLabel.frame = CGRectMake(0, self.width * 0.03125, self.width, _titleLabel.height);
    
    //分割线
    UIView *line = [[UIView alloc]init];
    line.alpha = 0.9;
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self addSubview:line];
    line.frame = CGRectMake(15, CGRectGetMaxY(_titleLabel.frame) + _titleLabel.top, self.width - 30, 1);

    //
    CGFloat x = self.width * 0.06;
    CGFloat y = self.width * 0.40625 * 0.5;
    CGFloat w = (self.width - 2 * self.width * 0.06);
    CGFloat h = self.width * 0.121875;
    _fieldView = [[FieldView alloc]initWithFrame:CGRectMake(x, y, w, h)];
    _fieldView.alpha = 0.8;
    _fieldView.layer.cornerRadius = 2;
    _fieldView.layer.borderWidth = 1;
    _fieldView.layer.borderColor = [[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1] CGColor];
    _fieldView.layer.masksToBounds = YES;
    _fieldView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_fieldView];
}

//响应者
- (void)setupResponsder {
    UITextField *responsder = [[UITextField alloc] init];
    [self addSubview:responsder];
    responsder.delegate = self;
    responsder.keyboardType = UIKeyboardTypeNumberPad;
    self.responsder = responsder;
}

#pragma mark - Actions
- (void)inputViewTap:(UITapGestureRecognizer *)tap {
    [self.responsder becomeFirstResponder];
}

- (void)ensureButtonClicked:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(tradeInputView:okBtnClick:password:)]) {
        [self.delegate tradeInputView:self okBtnClick:btn password:[_numsArray componentsJoinedByString:@""]];
    }
}

- (void)cancelButtonClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(tradeInputView:cancleBtnClick:numsArr:)]) {
        [self.delegate tradeInputView:self cancleBtnClick:btn numsArr:_numsArray];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //此处判断点击的是否是删除按钮,当输入键盘类型为number pad(数字键盘时)准确,其他类型未可知
    if (![string isEqualToString:@""]) {
        if (_numsArray.count < ZPTradeInputViewNumCount) {
            [_numsArray addObject:string];
            [self drawRect:CGRectZero];
            return YES;
        }else{
            return NO;
        }
        
    }else{
        [self.numsArray removeLastObject];
        [self drawRect:CGRectZero];
        return YES;
    }
}

#pragma mark - Rewrite
- (void)drawRect:(CGRect)rect {
    [self.fieldView drawRect:CGRectZero number:self.numsArray.count];
    //确定按钮的状态
    BOOL statue = NO;
    if (self.numsArray.count == ZPTradeInputViewNumCount) {
        statue = YES;
        _sureBtn.backgroundColor = kMainTone;
    } else {
        _sureBtn.backgroundColor = [UIColor lightGrayColor];
        statue = NO;
    }
    _sureBtn.enabled = statue;
}

#pragma mark - Getter
- (NSMutableArray *)numsArray {
    if (!_numsArray) {
        _numsArray = [NSMutableArray array];
    }
    return _numsArray;
}

@end
