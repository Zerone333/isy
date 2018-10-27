//
//  ZXProgressHUD.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger, ZXProgressHUDStatus) {
    ZXProgressHUDStatusInfo,
    ZXProgressHUDStatusError,
    ZXProgressHUDStatusSuccess,
    ZXProgressHUDStatusWaitting
};

@interface ZXProgressHUD : MBProgressHUD

@property (nonatomic, assign, getter=isShowNow) BOOL showNow;//是否正在显示

+ (instancetype)sharedHUD;//返回一个 HUD 的单例

+ (void)showMessage:(NSString *)text timeInterval:(NSTimeInterval)timeInterval;//在 window 上添加一个只显示文字的 HUD

+ (void)showInfoMsg:(NSString *)text;//在 window 上添加一个提示`信息`的 HUD

+ (void)showFailure:(NSString *)text;//在 window 上添加一个提示`失败`的 HUD

+ (void)showSuccess:(NSString *)text;//在 window 上添加一个提示`成功`的 HUD

+ (void)showLoading:(NSString *)text;//在 window 上添加一个提示`等待`的 HUD, 需要手动关闭

+ (void)hide;//手动隐藏 HUD

@end
