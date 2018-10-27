//
//  MineFooter.m
//  iShuYin
//
//  Created by Apple on 2017/9/6.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "MineFooter.h"

@implementation MineFooter

- (IBAction)logoutBtnClick:(id)sender {
    !_logoutBlock?:_logoutBlock();
}

@end
