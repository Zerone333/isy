//
//  CommentListHeader.m
//  iShuYin
//
//  Created by Apple on 2017/10/23.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "CommentListHeader.h"

@interface CommentListHeader ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation CommentListHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    _textField.delegate = self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    !_commentBlock?:_commentBlock();
    return NO;
}

@end
