//
//  ISYDBManager.m
//  iShuYin
//
//  Created by ND on 2018/10/28.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYDBManager.h"
#import "FMDB.h"
#import <sqlite3.h>


// 数据库表名称表
const struct ISYTable_Book {
    __unsafe_unretained NSString *tableName;
    __unsafe_unretained NSString *bookId;
    __unsafe_unretained NSString *bookDesJson;
} TFSDKTableName;
const struct ISYTable_ReadHistory {
    __unsafe_unretained NSString *tableName;
    __unsafe_unretained NSString *bookId;
    __unsafe_unretained NSString *readtime;
} ISYTable_ReadHistory;
const struct ISYTable_Search_Keyword {
    __unsafe_unretained NSString *tableName;
    __unsafe_unretained NSString *keyWord;
} ISYTable_ReadSearch_Keyword;

const struct ISYTable_Book ISY_BookTable = {
    .tableName = @"ISY_BookTable",
    .bookId = @"bookId",
    .bookDesJson = @"bookDesJson",
};

const struct ISYTable_ReadHistory ISY_ReadHistoryTable = {
    .tableName = @"ISY_ReadHistoryTable",
    .bookId = @"bookId",
    .readtime = @"readtime",
};

const struct ISYTable_Search_Keyword ISYTable_ReadSearchKeywordTable = {
    .tableName = @"ISYTable_KeywordTable",
    .keyWord = @"keyWord",
};

@interface ISYDBManager ()
@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;
@end

@implementation ISYDBManager

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
        [self setupDB];
    }
    
    return self;
}

- (void)setupDB {
    [self createBookTable];
    [self createHistoryTable];
    [self createHistorySearchTable];
}


- (FMDatabaseQueue *)databaseQueue {
    if (!_databaseQueue) {
        //1.创建database路径
        NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [docuPath stringByAppendingPathComponent:@"isy.db"];
        NSLog(@"!!!dbPath = %@",dbPath);
        
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath flags:SQLITE_OPEN_WAL | SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE];
        [_databaseQueue inDatabase:^(FMDatabase *db) {
            [db setMaxBusyRetryTimeInterval:60.f];
        }];
    }
    return _databaseQueue;
}

//书表
- (void)createBookTable {
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        // Book_Table
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT NOT NULL, '%@' TEXT NOT NULL)",
                         ISY_BookTable.tableName,
                         ISY_BookTable.bookId,
                         ISY_BookTable.bookDesJson];
        result = [db executeUpdate:sql];
        [db commit];
    }];
   
    if (result) {
        NSLog(@"create table success");
    }
}

//历史阅读表
- (void)createHistoryTable {
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        // Book_Table
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT NOT NULL, '%@' TEXT NOT NULL)",
                         ISY_ReadHistoryTable.tableName,
                         ISY_ReadHistoryTable.bookId,
                         ISY_ReadHistoryTable.readtime];
        result = [db executeUpdate:sql];
        [db commit];
    }];
    
    if (result) {
        NSLog(@"create table success");
    }
}

//搜索记录
- (void)createHistorySearchTable {
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        // Book_Table
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT NOT NULL)",
                         ISYTable_ReadSearchKeywordTable.tableName,
                         ISYTable_ReadSearchKeywordTable.keyWord];
        result = [db executeUpdate:sql];
        [db commit];
    }];
    
    if (result) {
        NSLog(@"create table success");
    }
}

/**
 插入书表

 @param book BookDetailModel
 @return 插入结果
 */
- (BOOL)insertBook:(BookDetailModel *)book {
    NSString *bookId = book.show_id;
    
    // 1、判断数据库是否已经存了数据
    BookDetailModel *model = [self queryBook:bookId];
    if (model) {
        return YES;
    }
    
    // 2、执行插入数据库
    NSString *json = [book yy_modelToJSONString];
    NSString *insertSqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES ( ?, ?)",
                                 ISY_BookTable.tableName,
                                 ISY_BookTable.bookId,
                                 ISY_BookTable.bookDesJson];

    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        result = [db executeUpdate:insertSqlString,
        bookId,
        json];
        [db commit];
    }];
    return result;
}

- (BOOL)insertSearchKeyword:(NSString *)keyworkd {

    NSString *deleteSqlString = [NSString stringWithFormat:@"DELETE * FROM %@ WHERE %@ = ?)",
                                 ISYTable_ReadSearchKeywordTable.tableName,
                                 ISYTable_ReadSearchKeywordTable.keyWord];
    NSString *insertSqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (?)",
                                 ISYTable_ReadSearchKeywordTable.tableName,
                                 ISYTable_ReadSearchKeywordTable.keyWord];
    
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        result = [db executeUpdate:deleteSqlString,
                  keyworkd];
        result = result & [db executeUpdate:insertSqlString,
                  keyworkd];
        [db commit];
    }];
    return result;
}

- (NSArray *)querySearchKewords {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@",
                           ISYTable_ReadSearchKeywordTable.tableName];
    
    __block NSMutableArray *list = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        FMResultSet *rs = [db executeQuery:sqlString];
        while ([rs next]) {
            NSString *keyword =  [rs stringForColumn:ISYTable_ReadSearchKeywordTable.keyWord];
            [list addObject:keyword];
        }
        [rs close];
        rs = nil;
    }];
    return [list copy];
}

/**
 查询书本详情

 @param bookId bookId
 @return BookDetailModel
 */
- (BookDetailModel *)queryBook:(NSString *)bookId {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@=%@",
                                 ISY_BookTable.tableName,
                                 ISY_BookTable.bookId,
                                 bookId];
    
    __block BookDetailModel *model;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        FMResultSet *rs = [db executeQuery:sqlString];
        if ([rs next]) {
            NSString *jsonString =  [rs stringForColumn:ISY_BookTable.bookDesJson];
            model = [BookDetailModel yy_modelWithJSON:jsonString];
        }
        [rs close];
        rs = nil;
    }];
    return model;
}

- (BOOL)insertReadBook:(NSString *)bookId readTime:(NSString *)timeString{
    // 执行插入数据库
    NSString *insertSqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES ( ?, ?)",
                                 ISY_ReadHistoryTable.tableName,
                                 ISY_ReadHistoryTable.bookId,
                                 ISY_ReadHistoryTable.readtime];
    
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        result = [db executeUpdate:insertSqlString,
                  bookId,
                  timeString];
        [db commit];
    }];
    return result;
}
@end
