//
//  UpdateForceView.m
//  JWXUserClient
//
//  Created by Apple on 16/11/1.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "UpdateForceView.h"
#import "ZXInputView.h"

@interface UpdateForceView ()
@property (weak, nonatomic) IBOutlet ZXInputView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;//立即更新
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consH;
@end

@implementation UpdateForceView

- (void)awakeFromNib {
    [super awakeFromNib];
    _contentView.width = kScreenWidth-134;
    _contentView.lineSpace = 4;
    _contentView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    _contentView.maxNumberOfLines = 4;
    __weak __typeof(self)weakSelf = self;
    _contentView.changeHeightBlock = ^(CGFloat height){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.consH.constant = height;
    };
}

#pragma mark - Setter
- (void)setContent:(NSString *)content {
    _content = content;
    _contentView.text = content;
    [_contentView scrollRectToVisible:CGRectMake(0, 0, _contentView.width, _contentView.height) animated:NO];
}

#pragma mark - Actions
//立即更新
- (IBAction)confirmBtnClick:(id)sender {
    !_dismissBlock?:_dismissBlock();
    if (_link_url.length) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_link_url]];
    }
}

@end
