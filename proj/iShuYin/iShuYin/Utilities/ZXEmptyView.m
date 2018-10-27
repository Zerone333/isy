//
//  ZXEmptyView.m
//  JWXUserClient
//
//  Created by Apple on 2017/6/14.
//  Copyright © 2017年 angxun. All rights reserved.
//

#import "ZXEmptyView.h"

@interface ZXEmptyView()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation ZXEmptyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setTip:(NSString *)tip {
    _tip = tip;
    _tipLabel.text = tip;
}

@end
