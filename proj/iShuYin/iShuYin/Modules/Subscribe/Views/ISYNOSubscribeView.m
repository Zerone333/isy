//
//  ISYNOSubscribeView.m
//  iShuYin
//
//  Created by ND on 2018/11/15.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYNOSubscribeView.h"
#import "ISYSearchViewController.h"

@implementation ISYNOSubscribeView
- (void)awakeFromNib {
    self.searchBtn.layer.masksToBounds = YES;
    self.searchBtn.layer.cornerRadius = 15;
    self.topBtn.layer.borderWidth = 0.5;
    self.topBtn.layer.borderColor = [UIColor grayColor].CGColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)searchClick:(id)sender {
    ISYSearchViewController *vc = [[ISYSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.nav pushViewController:vc animated:YES];
}

@end
