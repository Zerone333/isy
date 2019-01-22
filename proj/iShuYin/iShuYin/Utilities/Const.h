//
//  Const.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#ifndef Const_h
#define Const_h


//宽高
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kNavBarOffset ([[ZXTools shareTools]iphoneX] ? 88 : 64)
#define kTabBarOffset ([[ZXTools shareTools]iphoneX] ? 83 : 49)
#define kCoverProportion (105.0 / 80.0)

//颜色
#define kColorRGBA(r,g,b,l) ([UIColor colorWithRed:r/255.0\
                                                   green:g/255.0\
                                                   blue:b/255.0\
                                                   alpha:l/1.0])
#define kColorRGB(r,g,b) (kColorRGBA(r,g,b,1))

#define kColorRandom (kColorRGB(arc4random()%255,arc4random()%255,arc4random()%255))

#define kColorValue(value) kColorRGB(((value & 0xFF0000) >> 16),\
                                        ((value & 0xFF00) >> 8),\
                                                (value & 0xFF))
#define kMainTone (kColorValue(0xD63931)) //主色调
#define kBackgroundColor (kColorValue(0xf1f1f1)) //界面背景

//字体
#define kFontSystem(size) ([UIFont systemFontOfSize:size])
#define kFontBold(size)   ([UIFont boldSystemFontOfSize:size])
#define kFontItalic(size) ([UIFont italicSystemFontOfSize:size])

//方法
#if DEBUG
#ifndef DLog
#define DLog(format, args...) NSLog(@"[%s %d]: " format "\n", strrchr(__FILE__, '/') + 1, __LINE__, ## args);
#endif
#else
#ifndef DLog
#define DLog(format, args...) do {} while(0)
#endif
#endif

#define SBVC(identity) ([[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identity])


//单例
#define APPLICATION  ([UIApplication sharedApplication])
#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define USERDEFAULTS ([NSUserDefaults standardUserDefaults])
#define NOTIFICATIONCENTER ([NSNotificationCenter defaultCenter])

//路径
#define kPrefixImageSlide   @"http://www.ishuyin.com/"
#define kPrefixImageDefault @"http://mp3-45.oss-cn-hangzhou.aliyuncs.com/"

#define kAppDownloadURL @"https://itunes.apple.com/cn/app/id1297411170"


//登录信息
#define kKeyWrapper @"iShuYin_KeyWarpper"
#define kRememberPswd @"RememberPswd"
#define kAutoLogin @"AutoLogin"
#define kVersion @"Version"


//链接
#if DEBUG
#else
#endif

//======================================= 用户配置 =======================================
#define kUserConfigHeader @"UserConfigHeader" //1.女
#define kDownloadBooks @"DownloadBooks"//我的下载
#define kRecentBooks @"RecentBooks"//最近播放

#define kLastBook @"LastBook"//上一次播放的书本
#define kLastIndex @"LastIndex"//上一次播放的位置(章节)


//======================================= SDK =======================================
//银联环境
#define kUPPay_Mode @"00" //01测试环境，00 正式环境
#define kUPPay_Scheme @"iShuYin"
#define kUPPay_Result_Notification @"uppay_result_notification"//银联支付结果通知

//百度统计
#define kBaiduMTJAppKey @"562f017a74"

//添加动画通知
#define kNotiNameAnimationAdd @"NotiNameAnimationAdd"

//移除动画通知
#define kNotiNameAnimationDel @"NotiNameAnimationDel"

//微信支付结果
#define kWXPay_Result_Notification @"wxpay_result_notification"


//支付宝支付结果
#define kAliPay_Result_Notification @"alipay_result_notification"

//播放变化
#define kNotiNamePlayChange @"kNotiNamePlayChange"

//定时开始
#define kNotiTimerChange @"kNotiTimerChange"

//分享key
#define kUMengKey @"59e62554c62dca32ce0000c5"
#define kWXAppkey @"wx1f1f821a0fdced03"
#define kWXSecret @"368d55225d8540ad53a3bb55f110af0a"
//#define kWXSecret @"c3b8693e3f8bc704d5de27e5aedbcc86"
#define kQQAppID @"1105026508"
#define kQQAppKey @"O51DyMDctIQ36brV"
#define kChangYanAppID @"cyrAl7Qso"
#define kChangYanAppKey @"1643d1beffe25d4dd9ca3f9ecc9f6262"


#endif /* Const_h */
