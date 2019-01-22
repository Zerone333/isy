//
//  ISYDBManager.h
//  iShuYin
//
//  Created by ND on 2018/10/28.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookDetailModel.h"
#import "ISYHistoryListenModel.h"


@interface ISYDBManager : NSObject

+ (instancetype)shareInstance;
/**
 插入书表
 
 @param book BookDetailModel
 @return 插入结果
 */
- (BOOL)insertBook:(BookDetailModel *)book;

/**
 查询书本详情
 
 @param bookId bookId
 @return BookDetailModel
 */
- (BookDetailModel *)queryBook:(NSString *)bookId;

//历史搜索记录
- (BOOL)insertSearchKeyword:(NSString *)keyworkd;

- (NSArray *)querySearchKewords;

//查询历史收听记录
- (NSArray <ISYHistoryListenModel *> *)queryBookHistoryListen;

//插入历史收听记录
- (BOOL)insertHistoryListenBook:(BookDetailModel *)book chaperNumber:(NSInteger)chaperNumber time:(NSInteger)time listentime:(NSInteger)listentime;

/**
 更新书本章节下载情况
 */
- (BOOL)updateDownLoadStatus:(NSInteger)status bookId:(NSString *)bookId chaperModel:(BookChapterModel *)chaperModel expectedSize:(long long)expectedSize;
/**
 删除下载的书

 @param bookId NSString
 @param chaperNumber NSInteger
 @return BOOL
 */
- (BOOL)deleteDownloadBookId:(NSString *)bookId chaperModel:(BookChapterModel *)chaperModel;

/**
 查询下载数据

 @param status 4-下载完成
 @return NSArray
 */
- (NSArray *)queryDownloadBooks:(NSInteger)status;

/**
 下载中的数据

 @return NSArray
 */
- (NSArray *)queryDownloadingBooks;

/**
 查询书本下载的章节

 @param status 4
 @param bookId bookid
 @return NSArray
 */
- (NSArray *)queryDownloadChapers:(NSInteger)status bookId:(NSString *)bookId;

/**
 下载中的书

 @param bookId bookid
 @return NSArray
 */
- (NSArray *)queryDownloadingChapersBookId:(NSString *)bookId;
@end
