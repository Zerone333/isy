//
//  AppDelegate.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"
#import "KeychainItemWrapper.h"
#import "PlayViewController.h"
#import "SleepModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, assign) BOOL hasShowVersionRemindAlert;//版本更新提示的弹窗是否弹出过

@property (nonatomic, strong) NSString *base_url;//接口
@property (nonatomic, strong) NSString *base_url_2;//接口2.0
@property (nonatomic, strong) LoginModel *loginModel;
@property (nonatomic, strong) KeychainItemWrapper *keyWrapper;
@property (nonatomic, strong) PlayViewController *playVC;
@property (nonatomic, strong) NSURL *currentCoverImageURL;

@property (nonatomic, strong) UIWindow *window;

//定时关闭
@property (nonatomic, assign) SleepType sleepType;

@property (nonatomic, assign, readonly) NSInteger sleepInterval;//睡眠剩余时间(单位秒)

- (void)startSleepTimerWithInterval:(NSInteger)interval;

- (void)stopSleepTimer;

@end

