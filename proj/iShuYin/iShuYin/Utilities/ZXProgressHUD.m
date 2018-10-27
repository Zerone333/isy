//
//  ZXProgressHUD.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXProgressHUD.h"

@implementation ZXProgressHUD

+ (instancetype)sharedHUD {
    static ZXProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[ZXProgressHUD alloc]initWithView:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

+ (void)showStatus:(ZXProgressHUDStatus)status text:(NSString *)text {
    ZXProgressHUD *hud = [ZXProgressHUD sharedHUD];
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15.0f];
    [hud showAnimated:YES];
    [hud setShowNow:YES];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setMinSize:CGSizeMake(100.f, 100.f)];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    switch (status) {
        case ZXProgressHUDStatusSuccess: {
            UIImage *sucImage = [UIImage imageNamed:@"mbhud_success"];
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            hud.customView = sucView;
            [hud hideAnimated:YES afterDelay:1.6f];
        }
            break;
        case ZXProgressHUDStatusError: {
            UIImage *errImage = [UIImage imageNamed:@"mbhud_error"];
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            hud.customView = errView;
            [hud hideAnimated:YES afterDelay:1.6f];
        }
            break;
        case ZXProgressHUDStatusWaitting: {
            
            hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;
        case ZXProgressHUDStatusInfo: {
            UIImage *infoImage = [UIImage imageNamed:@"mbhud_info"];
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            hud.customView = infoView;
            [hud hideAnimated:YES afterDelay:1.6f];
        }
            break;
        default:
            break;
    }
}

+ (void)showMessage:(NSString *)text timeInterval:(NSTimeInterval)timeInterval {
    ZXProgressHUD *hud = [ZXProgressHUD sharedHUD];
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15.0f];
    [hud showAnimated:YES];
    [hud setShowNow:YES];
    [hud setMinSize:CGSizeZero];
    [hud setMode:MBProgressHUDModeText];
    [hud setRemoveFromSuperViewOnHide:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(hide) userInfo:nil repeats:NO];
}

+ (void)showInfoMsg:(NSString *)text {
    
    [self showStatus:ZXProgressHUDStatusInfo text:text];
}

+ (void)showFailure:(NSString *)text {
    
    [self showStatus:ZXProgressHUDStatusError text:text];
}

+ (void)showSuccess:(NSString *)text {
    
    [self showStatus:ZXProgressHUDStatusSuccess text:text];
}

+ (void)showLoading:(NSString *)text {
    
    [self showStatus:ZXProgressHUDStatusWaitting text:text];
}

+ (void)hide {
    [[ZXProgressHUD sharedHUD] setShowNow:NO];
    [[ZXProgressHUD sharedHUD] hideAnimated:YES];
}

@end
