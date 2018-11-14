//
//  ISYUserConfigManager.h
//  iShuYin
//
//  Created by ND on 2018/11/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISYSettingConfgModel.h"

@interface ISYUserConfigManager : NSObject
+ (nonnull instancetype)shareInstance;
- (void)updateSettingConfig:(ISYSettingConfgModel *)settingConfig;
- (ISYSettingConfgModel *)currentSettingConfig;
@end

