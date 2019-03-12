//
//  ISYDownloadChaperStatusCell.h
//  iShuYin
//
//  Created by 李艺真 on 2018/12/8.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ISYDownloadChaperStatusCellDeleteCB)(BookChapterModel *chaper);
typedef void(^ISYDownloadChaperStatusCellDeleteCB)(BookChapterModel *chaper);

@interface ISYDownloadChaperStatusCell : UITableViewCell
@property (nonatomic, copy) ISYDownloadChaperStatusCellDeleteCB deleteCb;
@property (nonatomic, copy) ISYDownloadChaperStatusCellDeleteCB downLoadFinishCb;
@property (nonatomic, strong) BookChapterModel *chaper;
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL isLoading; //default no 下载中的数据
@end

NS_ASSUME_NONNULL_END
