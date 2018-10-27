//
//  SleepCell.h
//  iShuYin
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 angxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SleepModel;

@interface SleepCell : UITableViewCell

@property (nonatomic, strong) SleepModel *sleepModel;

- (void)stopTimer;

@end
