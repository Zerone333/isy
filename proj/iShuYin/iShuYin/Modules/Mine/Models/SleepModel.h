//
//  SleepModel.h
//  iShuYin
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SleepType) {
    SleepType0 = -1,
    SleepType20 = 20,
    SleepType30 = 30,
    SleepType45 = 45,
    SleepType60 = 60,
};

@interface SleepModel : NSObject

@property (nonatomic, assign) SleepType sleepType;

@property (nonatomic, assign) BOOL isSelected;

@end
