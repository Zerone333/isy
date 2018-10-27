//
//  SubscribeListViewController.h
//  iShuYin
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SubscribeType) {
    SubscribeTypeDownload = 0,//我的下载
    SubscribeTypeCollect = 1,//我的收藏
    SubscribeTypeRecent = 2,//最近收听
};

@interface SubscribeListViewController : UIViewController

@property (nonatomic, assign) SubscribeType listType;

@end
