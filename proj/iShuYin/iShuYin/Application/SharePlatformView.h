//
//  SharePlatformView.h
//  iShuYin
//
//  Created by Apple on 2017/8/27.
//  Copyright © 2017年 angxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharePlatformView : UIView

@property (nonatomic, strong)void(^dismissBlock)(void);

@property (nonatomic, strong) void(^shareBlock)(NSInteger);

@end
