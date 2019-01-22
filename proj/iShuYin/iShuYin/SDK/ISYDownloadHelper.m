//
//  ISYDownloadHelper.m
//  iShuYin
//
//  Created by 李艺真 on 2018/12/8.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYDownloadHelper.h"
#import "NSString+ZXAdd.h"

@implementation ISYDownloadHelper

+ (nonnull instancetype)shareInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (nonnull instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (nullable MCDownloadReceipt *)downloadChaper:(BookChapterModel *)chaper
                                        bookId:(NSString *)bookId
                                      progress:(nullable MCDownloaderProgressBlock)progressBlock
                                     completed:(nullable MCDownloaderCompletedBlock)completedBlock {

//    MCDownloadStateNone,           /** default */
//    MCDownloadStateWillResume,     /** waiting */
//    MCDownloadStateDownloading,    /** downloading */
//    MCDownloadStateSuspened,       /** suspened */
//    MCDownloadStateCompleted,      /** download completed */
//    MCDownloadStateFailed          /** download failed */
    //判断下载状态
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:[chaper.l_url decodePlayURL]];
    if (receipt.state == MCDownloadStateCompleted) {
        completedBlock(receipt, nil, YES);
        //下载完成
        return receipt;
    } else {
        // 添加到下载列表数据库中
        [[ISYDBManager shareInstance] updateDownLoadStatus:MCDownloadStateDownloading bookId:bookId chaperModel:chaper expectedSize:receipt.totalBytesExpectedToWrite];
        
        return [[MCDownloader sharedDownloader] downloadDataWithURL:[NSURL URLWithString:[chaper.l_url decodePlayURL]] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
            progressBlock(receivedSize, expectedSize, speed, targetURL);
        } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
            // 更新数据库操作
            [[ISYDBManager shareInstance] updateDownLoadStatus:receipt.state bookId:bookId chaperModel:chaper expectedSize:receipt.totalBytesExpectedToWrite];
            completedBlock(receipt, error, finished);
        }];
    }
//    if (receipt.progress.fractionCompleted == 1.0) {
//        //已下载
//    }else {
//        receipt.state = MCDownloadStateNone;
//        receipt.customFilePathBlock = ^NSString * _Nullable(MCDownloadReceipt * _Nullable receipt) {
//            NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//            NSString *bookPath = [NSString stringWithFormat:@"%@/downloads/%@_%@/",document,_detailModel.show_id,_detailModel.title];
//            return [bookPath stringByAppendingString:[NSString stringWithFormat:@"%@_%@",m.l_id,urlString.lastPathComponent]];
//        };
//    }
}

- (BOOL)deleteDownloadBookId:(NSString *)bookId chaper:(BookChapterModel *)chaper {
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:[chaper.l_url decodePlayURL]];
    [[MCDownloader sharedDownloader]remove:receipt completed:^{
    }];
    
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *bookPath = [NSString stringWithFormat:@"%@/downloads/%@_%@/",document, bookId, chaper.l_title];
    NSString *path = [bookPath stringByAppendingString:[NSString stringWithFormat:@"%@_%@",chaper.l_id, [chaper.l_url decodePlayURL].lastPathComponent]];
    [[ZXTools shareTools] removeFileAtPath:path];
    
    [[ISYDBManager shareInstance] deleteDownloadBookId:bookId chaperModel:chaper];
    return YES;
}

- (BOOL)stopDownloadBookId:(NSString *)bookId chaper:(BookChapterModel *)chaper {
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:[chaper.l_url decodePlayURL]];
    [[MCDownloader sharedDownloader]cancel:receipt completed:^{
    }];
    
    [[ISYDBManager shareInstance] updateDownLoadStatus:MCDownloadStateSuspened bookId:bookId chaperModel:chaper expectedSize:receipt.totalBytesExpectedToWrite];
    
    return YES;
}
@end
