//
//  BookDetailSubDownLoadViewController.h
//  iShuYin
//
//  Created by 李艺真 on 2018/10/21.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ZXBaseViewController.h"

@class BookDetailModel;

/**
 详情节目
 */
@interface BookDetailSubDownLoadViewController : ZXBaseViewController
@property (nonatomic, strong) BookDetailModel *detailModel;
@property (nonatomic, assign) BOOL zhengxu; //排序方式，正序
@end
