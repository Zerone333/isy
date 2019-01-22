//
//  ISYCommentTableViewCell.h
//  iShuYin
//
//  Created by ND on 2018/11/10.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListModel.h"

typedef void(^ISYCommentTableViewCellZanCB)(CommentListModel *model);
@interface ISYCommentTableViewCell : UITableViewCell
@property (nonatomic, copy) ISYCommentTableViewCellZanCB zanCb;
@property (nonatomic, weak) CommentListModel *model;

@end

