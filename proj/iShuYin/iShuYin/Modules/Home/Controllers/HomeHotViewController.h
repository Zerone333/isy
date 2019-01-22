//
//  HomeHotViewController.h
//  iShuYin
//
//  Created by 李艺真 on 2018/10/15.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "HomeViewController.h"

@interface HomeHotViewController : ZXBaseViewController
@property (nonatomic, copy) HomeViewControllerBookBlock bookBlock;
@property (nonatomic, strong) NSArray *slide;//轮播图
@property (nonatomic, copy) NSString *adString ;
@property (nonatomic, weak) HomeViewController *parentVC;
@end
