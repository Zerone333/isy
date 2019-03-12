//
//  BookChapterViewController.h
//  iShuYin
//
//  Created by Apple on 2017/8/22.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXBaseViewController.h"


@class BookDetailModel;

/**
 批量下载
 */
@interface BookChapterViewController : ZXBaseViewController
@property (nonatomic, assign) bool isDelete;    // default NO
@property (nonatomic, strong) BookDetailModel *detailModel;

@end
