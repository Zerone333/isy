//
//  MoreListViewController.h
//  iShuYin
//
//  Created by Apple on 2017/8/10.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXBaseViewController.h"

typedef NS_ENUM(NSInteger,MoreListType) {
    MoreListTypeRecommend = 1,//推荐
    MoreListTypeHot = 2,//热播
    MoreListTypeNew = 3,//新书
};

@class CategoryModel;

@interface MoreListViewController : ZXBaseViewController

@property (nonatomic, assign) MoreListType type;//首页更多进来

@property (nonatomic, strong) NSString *keyword;//搜索进来 或 详情页更多进来

@property (nonatomic, strong) CategoryModel *category;//分类进来

@end
