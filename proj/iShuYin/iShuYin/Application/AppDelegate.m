//
//  AppDelegate.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "AppDelegate.h"
#import "ZXPlayButton.h"
#import "ZXMainViewController.h"
#import "BaiduMobStat.h"
#import "MCDownloader.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()
@property (nonatomic, strong) NSTimer *sleepTimer;
@property (nonatomic, assign, readwrite) NSInteger sleepInterval;//睡眠剩余时间(单位秒)
@end

@implementation AppDelegate

- (void)startSleepTimerWithInterval:(NSInteger)interval {
    [self stopSleepTimer];
    if (interval == 0) {
        self.sleepInterval = 0;
    }else {
        self.sleepInterval = interval;
        self.sleepTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sleepAction) userInfo:nil repeats:YES];
    }
}

- (void)stopSleepTimer {
    if (self.sleepTimer) {
        [self.sleepTimer invalidate];
        self.sleepTimer = nil;
    }
}

- (void)sleepAction {
    DLog(@"%li", self.sleepInterval);
    self.sleepInterval -= 1;
    if (self.sleepInterval < 0) {
        [self stopSleepTimer];
        if (self.playVC) {
            [self.playVC pause];
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [ZXPlayButton registerPlusButton];
    _playVC = SBVC(@"PlayVC");
    Float32 bufferLength = 0.1;
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    [[AVAudioSession sharedInstance]setPreferredIOBufferDuration:bufferLength error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    
    //初始化
    self.isOnline = YES;
    self.hasShowVersionRemindAlert = NO;
    self.keyWrapper = [KeychainItemWrapper shareKeychainItemWrapperIdentifier:kKeyWrapper accessGroup:nil];
    APPLICATION.statusBarStyle = UIStatusBarStyleLightContent;

    //接口前缀
#if DEBUG
    self.base_url = @"http://47.52.110.104/service.php?action=";
    self.base_url_2 = @"http://app.aikeu.com/service.php?action=";
#else
    self.base_url = @"http://caiji.ishuyin.com/service.php?action=";
    self.base_url_2 = @"http://app.aikeu.com/service.php?action=";
#endif
    
    //窗口处理
    [self handleWindow];
    
    //自动登录
    [self autoLogin];
    
    //SVProgressHUD
    [self setProgressHUD];
    
    //键盘处理
    [self handleKeyboard];
    
    //友盟分享
    [self configUMSocial];
    
    //畅言SDK
    [self configChangYan];
    
    //百度统计
    BaiduMobStat *mobStat = [BaiduMobStat defaultStat];
    mobStat.enableGps = NO;
    [mobStat startWithAppId:kBaiduMTJAppKey];
    
    return YES;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)handleWindow {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ZXMainViewController alloc]init];
    [self.window makeKeyAndVisible];
    //文字
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kColorValue(0x666666)} forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kMainTone} forState:UIControlStateSelected];
    //图片
}

- (void)autoLogin {
    if (![USERDEFAULTS objectForKey:kAutoLogin]) {
        return;
    }
    [USERDEFAULTS setObject:[[NSBundle mainBundle]infoDictionary][@"CFBundleShortVersionString"] forKey:kVersion];
    [USERDEFAULTS synchronize];
    
    NSString *mobile = [self.keyWrapper objectForKey:(__bridge id)kSecAttrAccount];
    NSString *passwd = [self.keyWrapper objectForKey:(__bridge id)kSecValueData];
    if (![mobile isKindOfClass:[NSString class]] || mobile.length == 0 ||
        ![passwd isKindOfClass:[NSString class]] || passwd.length == 0) {
        return;
    }
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryLogin];
    NSDictionary *params = @{@"username":mobile,
                             @"password":passwd,
                             };
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager POSTWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            //登录信息
            LoginModel *model = [LoginModel yy_modelWithJSON:responseObject[@"data"]];
            strongSelf.loginModel = model;
            [strongSelf.keyWrapper setObject:mobile forKey:(__bridge id)kSecAttrAccount];
            [strongSelf.keyWrapper setObject:passwd forKey:(__bridge id)kSecValueData];
            
            //登录畅言
            [ChangyanSDK loginSSO:model.user_id userName:[NSString isEmpty:model.user_name]?@"游客":model.user_name profileUrl:nil imgUrl:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
                DLog(@"%@", responseStr);
            }];
            
        }else {
            ZXNetworkManager *manager = [ZXNetworkManager shareManager];
            [manager clearCache];
            NSString *url = [manager URLStringWithQuery:QueryLogout];
            [manager GETWithURLString:url parameters:nil progress:nil success:nil failure:nil];
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

- (void)setProgressHUD {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.9]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setMinimumSize:CGSizeMake(80, 80)];
    [SVProgressHUD setMinimumDismissTimeInterval:1.6f];
}

- (void)handleKeyboard {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.enableAutoToolbar = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
}

//友盟分享
- (void)configUMSocial{
    //获取友盟social版本号
    DLog(@"umSocialSDKVersion %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMengKey];
    
    //QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppID appSecret:kQQAppKey redirectURL:@"http://www.ishuyin.com"];
    
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWXAppkey appSecret:kWXSecret redirectURL:@"http://www.ishuyin.com"];
    
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    //微信SDK
    BOOL ret = [WXApi registerApp:kWXAppkey];
    DLog(@"微信appkey注册%@", ret?@"成功":@"失败");
}

//畅言SDK
- (void)configChangYan {
    [ChangyanSDK registerApp:kChangYanAppID
                      appKey:kChangYanAppKey
                 redirectUrl:@"http://www.ishuyin.com"
        anonymousAccessToken:@""];
    
    [ChangyanSDK setAllowSelfLogin:NO];
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:SBVC(@"LoginVC")];
    [ChangyanSDK setLoginViewController:loginNav];
    
    [ChangyanSDK setAllowAnonymous:NO];
    [ChangyanSDK setAllowRate:NO];
    [ChangyanSDK setAllowUpload:YES];
    [ChangyanSDK setAllowWeiboLogin:NO];
    [ChangyanSDK setAllowQQLogin:NO];
    [ChangyanSDK setAllowSohuLogin:NO];
    
    [ChangyanSDK setNavigationBackgroundColor:[UIColor blackColor]];
    [ChangyanSDK setNavigationTintColor:kMainTone];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    /*
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self resignFirstResponder];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self logOut];
}

//退出登录
- (void)logOut {
    NSString *mobile = [self.keyWrapper objectForKey:(__bridge id)kSecAttrAccount];
    NSString *passwd = [self.keyWrapper objectForKey:(__bridge id)kSecValueData];
    if (![mobile isKindOfClass:[NSString class]] || [NSString isEmpty:mobile] ||
        ![passwd isKindOfClass:[NSString class]] || [NSString isEmpty:passwd]) {
        return;
    }
    NSString *url = [self.base_url stringByAppendingString:@"logout"];
    NSString *params = [NSString stringWithFormat:@"mobile=%@&api_token=%@",mobile,passwd];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        DLog(@"%@", error.localizedDescription);
    }else {
        NSString *obj = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"%@", obj);
    }
}

#pragma mark - 第三方sdk回调方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    //友盟
    if ([[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation]) {
        return YES;
    }
    //微信
    if ([url.absoluteString containsString:kWXAppkey] ||
             [sourceApplication isEqualToString:@"com.tencent.xin"]) {
        [WXApi handleOpenURL:url delegate:nil];
    }
    //QQ
    else if ([url.absoluteString containsString:@"QQ41dd5dcc"] ||
             [sourceApplication isEqualToString:@"com.tencent.mqq"]) {
        [QQApiInterface handleOpenURL:url delegate:nil];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    //友盟
    if ([[UMSocialManager defaultManager] handleOpenURL:url options:options]) {
        return YES;
    }
    //微信
    if ([url.absoluteString containsString:kWXAppkey] ||
             [options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]) {
        [WXApi handleOpenURL:url delegate:nil];
    }
    //QQ
    else if ([url.absoluteString containsString:@"QQ41dd5dcc"] ||
             [options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.mqq"]) {
        [QQApiInterface handleOpenURL:url delegate:nil];
    }
    return YES;
}

@end
