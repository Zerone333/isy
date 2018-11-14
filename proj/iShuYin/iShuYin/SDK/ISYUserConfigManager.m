//
//  ISYUserConfigManager.m
//  iShuYin
//
//  Created by ND on 2018/11/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYUserConfigManager.h"

@interface ISYUserConfigManager ()
@property (nonatomic, strong) ISYSettingConfgModel *settingConfig;
@end

@implementation ISYUserConfigManager


+ (nonnull instancetype)shareInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (nonnull instancetype)init {
    if (self = [super init]) {
        [self setupSettingConfig];
    }
    return self;
}

#pragma mark - private
//配置设置数据
- (void)setupSettingConfig {
    self.settingConfig = [[ISYSettingConfgModel alloc] init];
    NSNumber *allowTraffic = [[NSUserDefaults standardUserDefaults] valueForKey:@"isy_allowTraffic"];
    NSNumber *allowWifiDownload =  [[NSUserDefaults standardUserDefaults] valueForKey:@"isy_allowWifiDownload"];
    NSNumber *inputHeadsetPlay =  [[NSUserDefaults standardUserDefaults] valueForKey:@"isy_inputHeadsetPlay"];
    NSNumber *outputHeadsetPlay =  [[NSUserDefaults standardUserDefaults] valueForKey:@"isy_outputHeadsetPlay"];
    if (!allowTraffic) {
        allowTraffic = @(1);
        [[NSUserDefaults standardUserDefaults] setObject:allowTraffic forKey:@"isy_allowTraffic"];
    }
    if (!allowWifiDownload) {
        allowWifiDownload = @(1);
        [[NSUserDefaults standardUserDefaults] setObject:allowWifiDownload forKey:@"isy_inputHeadsetPlay"];
    }
    if (!inputHeadsetPlay) {
        inputHeadsetPlay = @(1);
        [[NSUserDefaults standardUserDefaults] setObject:inputHeadsetPlay forKey:@"isy_inputHeadsetPlay"];
    }
    if (!outputHeadsetPlay) {
        outputHeadsetPlay = @(1);
        [[NSUserDefaults standardUserDefaults] setObject:outputHeadsetPlay forKey:@"isy_outputHeadsetPlay"];
    }
    self.settingConfig.allowTraffic = allowTraffic.integerValue;
    self.settingConfig.allowWifiDownload = allowWifiDownload.integerValue;
    self.settingConfig.inputHeadsetPlay = inputHeadsetPlay.integerValue;
    self.settingConfig.outputHeadsetPlay = outputHeadsetPlay.integerValue;
}
#pragma mark - public

- (ISYSettingConfgModel *)currentSettingConfig {
    ISYSettingConfgModel *model = [[ISYSettingConfgModel alloc] init];
    model.allowTraffic = self.settingConfig.allowTraffic;
    model.allowWifiDownload = self.settingConfig.allowWifiDownload;
    model.inputHeadsetPlay = self.settingConfig.inputHeadsetPlay;
    model.outputHeadsetPlay = self.settingConfig.outputHeadsetPlay;
    return model;
}

- (void)updateSettingConfig:(ISYSettingConfgModel *)settingConfig {
    self.settingConfig.allowTraffic = settingConfig.allowTraffic;
    self.settingConfig.allowWifiDownload = settingConfig.allowWifiDownload;
    self.settingConfig.inputHeadsetPlay = settingConfig.inputHeadsetPlay;
    self.settingConfig.outputHeadsetPlay = settingConfig.outputHeadsetPlay;
    
    [[NSUserDefaults standardUserDefaults] setObject:settingConfig.allowTraffic? @(1) : @(0) forKey:@"isy_allowTraffic"];
    [[NSUserDefaults standardUserDefaults] setObject:settingConfig.allowWifiDownload? @(1) : @(0) forKey:@"isy_inputHeadsetPlay"];
    [[NSUserDefaults standardUserDefaults] setObject:settingConfig.inputHeadsetPlay? @(1) : @(0) forKey:@"isy_inputHeadsetPlay"];
    [[NSUserDefaults standardUserDefaults] setObject:settingConfig.outputHeadsetPlay? @(1) : @(0) forKey:@"isy_outputHeadsetPlay"];
}
@end
