//
//  SubscribeHeader.m
//  iShuYin
//
//  Created by Apple on 2017/9/6.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "SubscribeHeader.h"

@interface SubscribeHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation SubscribeHeader

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)reloadHeader {
    _nameLabel.text = APPDELEGATE.loginModel.user_name;
    NSString *config = [USERDEFAULTS objectForKey:kUserConfigHeader];
    if (![NSString isEmpty:config] && config.integerValue == 1) {
        _imgView.image = [UIImage imageNamed:@"ph_women"];
    }else {
        _imgView.image = [UIImage imageNamed:@"ph_man"];
    }
}

@end
