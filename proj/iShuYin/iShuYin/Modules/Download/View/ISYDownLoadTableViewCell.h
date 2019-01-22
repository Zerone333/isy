//
//  DownLoadTableViewCell.h
//  iShuYin
//
//  Created by ND on 2018/10/28.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYBookListTableViewCell.h"
#import "BookDetailModel.h"

typedef void(^ISYDownLoadTableViewCellCB)(BookDetailModel *bookDetailModel);

@interface ISYDownLoadTableViewCell : ISYBookListTableViewCell
@property (nonatomic, strong) BookDetailModel *bookDetailModel;
@property (nonatomic, assign) NSInteger type;   ///< 1 已下载/ 2 下载中
@property (nonatomic, copy) ISYDownLoadTableViewCellCB editCb;
@end

