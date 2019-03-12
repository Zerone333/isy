//
//  ISYDownloadFinishViewController.h
//  iShuYin
//
//  Created by 李艺真 on 2018/12/8.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "BookDetailModel.h"

@interface ISYDownloadFinishViewController : ZXBaseViewController
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, strong) BookDetailModel *book;

@end
