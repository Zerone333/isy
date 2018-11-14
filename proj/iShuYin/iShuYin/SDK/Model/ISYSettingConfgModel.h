//
//  ISYSettingConfgModel.h
//  iShuYin
//
//  Created by ND on 2018/11/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISYSettingConfgModel : NSObject
@property (nonatomic, assign) BOOL allowTraffic;  ///< 流量收听
@property (nonatomic, assign) BOOL allowWifiDownload;   ///< WiFi下载
@property (nonatomic, assign) BOOL inputHeadsetPlay;    ///< 拔出耳机暂停播放
@property (nonatomic, assign) BOOL outputHeadsetPlay;   ///< 插入耳机自动播放
@end

