//
//  ISYHisotyLisenBookListTableViewCell.h
//  iShuYin
//
//  Created by ND on 2018/11/13.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYBookListTableViewCell.h"
#import "ISYHistoryListenModel.h"

typedef void(^ISYHisotyLisenBookListTableViewCellBlock)(ISYHistoryListenModel *model);

@interface ISYHisotyLisenBookListTableViewCell : ISYBookListTableViewCell
@property (nonatomic, strong) ISYHistoryListenModel * historyListenModel;
@property (nonatomic, copy) ISYHisotyLisenBookListTableViewCellBlock playBlock;
@end
