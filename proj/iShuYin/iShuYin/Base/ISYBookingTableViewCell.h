//
//  ISYBookingTableViewCell.h
//  iShuYin
//
//  Created by ND on 2018/11/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYBookListTableViewCell.h"
#import "ISYHistoryListenModel.h"

typedef void(^ISYBookListTableViewCellBlock)(ISYHistoryListenModel *model);

@interface ISYBookingTableViewCell : ISYBookListTableViewCell
@property (nonatomic, strong) ISYHistoryListenModel * historyListenModel;
@property (nonatomic, copy) ISYBookListTableViewCellBlock playBlock;
@end
