//
//  ISYDBManager.h
//  iShuYin
//
//  Created by ND on 2018/10/28.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookDetailModel.h"


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
@end
