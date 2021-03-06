//
//  ISYDownLoadListViewController.h
//  iShuYin
//
//  Created by ND on 2018/10/28.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ZXBaseViewController.h"

typedef void(^DownloadedSizeChangeBlock)(long long size);

NS_ASSUME_NONNULL_BEGIN

@interface ISYDownLoadListViewController : ZXBaseViewController
@property (nonatomic, assign) NSInteger dowmloadType;   ///< 1 已下载/ 2 下载中
@property (nonatomic, copy) DownloadedSizeChangeBlock sizeChangeBlock;
@end

NS_ASSUME_NONNULL_END
