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
@end
