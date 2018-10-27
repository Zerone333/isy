//
//  CommentListViewController.h
//  iShuYin
//
//  Created by Apple on 2017/10/23.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXBaseViewController.h"

@class BookDetailModel;

@interface CommentListViewController : ZXBaseViewController

@property (nonatomic, strong) NSString *topic_id;

@property (nonatomic, strong) BookDetailModel *bookModel;

@end
