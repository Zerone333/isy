//
//  CommentListCell.h
//  iShuYin
//
//  Created by Apple on 2017/10/23.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentListModel;

@interface CommentListCell : UITableViewCell

@property (nonatomic, strong) CommentListModel *listModel;

@property (nonatomic, strong) void (^commentLikeBlock)(CommentListModel *m);

@end
