//
//  ISYSettingModel.m
//  iShuYin
//
//  Created by ND on 2018/11/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYSettingModel.h"

@implementation ISYSettingModel

+(instancetype)modelTitle:(NSString *)title imageName:(NSString *)imageName settingType:(ISYSettingModelSettingType)settingType block:(ISYSettingModelBlock)block {
    ISYSettingModel *model = [[ISYSettingModel alloc] init];
    model.title = title;
    model.imageName = imageName;
    model.settingType = settingType;
    model.switchValueChagneBlock = block;
    return model;
}
@end
