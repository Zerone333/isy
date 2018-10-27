//
//  FinishListViewController.h
//  iShuYin
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FinishListType) {
    FinishListTypeRecommend = 1,//推荐
    FinishListTypeHot = 2,//热播
    FinishListTypeNew = 3,//新书
};

@interface FinishListViewController : UIViewController

@property (nonatomic, assign) FinishListType type;

@end
