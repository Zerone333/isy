//
//  ISYSettingTableViewCell.h
//  iShuYin
//
//  Created by ND on 2018/11/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISYSettingModel.h"

@interface ISYSettingTableViewCell : UITableViewCell
@property (nonatomic, strong) ISYSettingModel *model;
+(NSString *)cellId;
@end

