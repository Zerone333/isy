//
//  HomeFoundViewController.h
//  iShuYin
//
//  Created by 李艺真 on 2018/10/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "HomeViewController.h"


typedef void(^HomeFoundViewControllerMoreBlock)(NSInteger index);

@interface HomeFoundViewController : ZXBaseViewController
@property (nonatomic, copy) HomeViewControllerBookBlock bookBlock;
@property (nonatomic, copy) HomeFoundViewControllerMoreBlock moreBlock;
@property (nonatomic, strong) NSArray *slide;//轮播图
@property (nonatomic, weak) HomeViewController *parentVC;
@end
