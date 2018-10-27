//
//  LaunchViewController.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "LaunchViewController.h"
#import "GuideViewController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [APPLICATION setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [APPLICATION setStatusBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleWindow];
}

- (void)handleWindow {
    NSString *currentVersion = [[NSBundle mainBundle]infoDictionary][@"CFBundleShortVersionString"];
    NSString *cacheVersion = [USERDEFAULTS objectForKey:kVersion];
    DLog(@"current:%@  cache:%@", currentVersion,cacheVersion);
    if ([cacheVersion isEqualToString:currentVersion]) {
        /*
        NSString *mobile = [APPDELEGATE.keyWrapper objectForKey:(__bridge id)kSecAttrAccount];
        NSString *api_token = [APPDELEGATE.keyWrapper objectForKey:(__bridge id)kSecValueData];
        NSString *last_login_time = [USERDEFAULTS objectForKey:kLastLoginTime];
        NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
        if ([last_login_time isKindOfClass:[NSString class]] && last_login_time.doubleValue > 0 &&
            now - last_login_time.doubleValue > 0 && now - last_login_time.doubleValue < 7*24*60*60 &&
            [mobile isKindOfClass:[NSString class]] && ![NSString isEmpty:mobile] &&
            [api_token isKindOfClass:[NSString class]] && ![NSString isEmpty:api_token]) {
            [APPDELEGATE autoLogin];
        }else {
            APPDELEGATE.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:SBVC(@"HomeVC")];
        }
         */
    }else {
        APPDELEGATE.window.rootViewController = [[GuideViewController alloc]init];
        [USERDEFAULTS setObject:currentVersion forKey:kVersion];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
