//
//  ISYDownloadHelper.h
//  iShuYin
//
//  Created by 李艺真 on 2018/12/8.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCDownloader.h"
#import "ISYDBManager.h"
#import "BookDetailModel.h"

@interface ISYDownloadHelper : NSObject

+ (nonnull instancetype)shareInstance;

- (nullable MCDownloadReceipt *)downloadChaper:(BookChapterModel *)chaper
                                             bookId:(NSString *)bookId
                                           progress:(nullable MCDownloaderProgressBlock)progressBlock
                                          completed:(nullable MCDownloaderCompletedBlock)completedBlock;


/**
 删除下载的书
 
 @param bookId NSString
 @param chaper chaper
 @return BOOL
 */
- (BOOL)deleteDownloadBookId:(NSString *)bookId chaper:(BookChapterModel*)chaper;

/**
 暂停下载

 @param bookId NSString
 @param chaper chaper
 @return BOOL
 */
- (BOOL)stopDownloadBookId:(NSString *)bookId chaper:(BookChapterModel *)chaper;
@end


