//
//  ISYSettingModel.h
//  iShuYin
//
//  Created by ND on 2018/11/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ISYSettingModelSettingType_Swich,
    ISYSettingModelSettingType_info,
} ISYSettingModelSettingType;

typedef void(^ISYSettingModelBlock)(BOOL switchValue);

@interface ISYSettingModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) ISYSettingModelSettingType settingType;
@property (nonatomic, copy) ISYSettingModelBlock switchValueChagneBlock;
@property (nonatomic, copy) NSString *valueString;

+(instancetype)modelTitle:(NSString *)title imageName:(NSString *)imageName settingType:(ISYSettingModelSettingType)settingType block:(ISYSettingModelBlock)block;
@end
