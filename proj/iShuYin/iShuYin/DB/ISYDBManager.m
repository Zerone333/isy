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
#import "ISYHistoryListenModel.h"


// 数据库表名称表
struct ISYTable_Book {
    __unsafe_unretained NSString *tableName;
    __unsafe_unretained NSString *bookId;
    __unsafe_unretained NSString *bookDesJson;
};

struct ISYTable_ReadHistory {
    __unsafe_unretained NSString *tableName;
    __unsafe_unretained NSString *bookId;
    __unsafe_unretained NSString *readtime;
};

struct ISYTable_Search_Keyword {
    __unsafe_unretained NSString *tableName;
    __unsafe_unretained NSString *keyWord;
};

struct ISYTable_History_Listen {
    __unsafe_unretained NSString *tableName;
    __unsafe_unretained NSString *bookId;
    __unsafe_unretained NSString *time;     ///< 收听的进度
    __unsafe_unretained NSString *listenTime;     ///< 收听时间
    __unsafe_unretained NSString *chaperNumber;  ///< 收听的集数
};

struct ISYTable_Download {
    __unsafe_unretained NSString *tableName;
    __unsafe_unretained NSString *bookId;
    __unsafe_unretained NSString *chaperId;
    __unsafe_unretained NSString *status;
    __unsafe_unretained NSString *chaperTitle;
    __unsafe_unretained NSString *chaperUrl;
    __unsafe_unretained NSString *size;
};

struct ISY_ShareBook {
    __unsafe_unretained NSString *tableName;
    __unsafe_unretained NSString *bookId;
    __unsafe_unretained NSString *date;
};

const struct ISYTable_Download ISYTable_DownloadTable = {
    .tableName = @"ISYTable_DownloadTable",
    .bookId = @"bookId",
    .chaperId = @"chaperId",
    .status = @"status",
    .chaperTitle = @"chaperTitle",
    .chaperUrl = @"chaperUrl",
    .size = @"size",
};

const struct ISYTable_History_Listen ISYTable_HistoryListenTable = {
    .tableName = @"ISYTable_HistoryListenTable",
    .bookId = @"bookId",
    .time = @"time",
    .chaperNumber = @"chaperNumber",
    .listenTime = @"listenTime",
};

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

const struct ISY_ShareBook ISY_ShareBookTable = {
    .tableName = @"ISY_ShareBookTable",
    .bookId = @"bookId",
    .date = @"date",
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

#pragma mark - private
- (void)setupDB {
    [self createBookTable];
    [self createHistoryTable];
    [self createHistorySearchTable];
    [self createHistoryListenTable];
    [self createDownloadTable];
    [self createShareTable];
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

//收听记录
- (void)createHistoryListenTable {
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        // Book_Table
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@\
                         ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,\
                         '%@' TEXT NOT NULL,\
                         '%@' INTERGE NOT NULL,\
                         '%@' INTERGE NOT NULL,\
                         '%@' INTERGE NOT NULL)",
                         ISYTable_HistoryListenTable.tableName,
                         ISYTable_HistoryListenTable.bookId,
                         ISYTable_HistoryListenTable.time,
                         ISYTable_HistoryListenTable.chaperNumber,
                         ISYTable_HistoryListenTable.listenTime];
        result = [db executeUpdate:sql];
        [db commit];
    }];
    
    if (result) {
        NSLog(@"create table success");
    }
}

//下载记录表
- (void)createDownloadTable {
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        // Book_Table
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@\
                         ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,\
                         '%@' TEXT NOT NULL,\
                         '%@' TEXT NOT NULL,\
                         '%@' INTERGE NOT NULL,\
                         '%@' TEXT,\
                         '%@' TEXT,\
                         '%@' INTERGE)",
                         ISYTable_DownloadTable.tableName,
                         ISYTable_DownloadTable.bookId,
                         ISYTable_DownloadTable.chaperId,
                         ISYTable_DownloadTable.status,
                         ISYTable_DownloadTable.chaperUrl,
                         ISYTable_DownloadTable.chaperTitle,
                         ISYTable_DownloadTable.size];
        result = [db executeUpdate:sql];
        [db commit];
    }];
    
    if (result) {
        NSLog(@"create table success");
    }
    
}

//分享记录
- (void)createShareTable {
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        // Book_Table
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@\
                         ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,\
                         '%@' TEXT NOT NULL,\
                         '%@' INTERGE)",
                         ISY_ShareBookTable.tableName,
                         ISY_ShareBookTable.bookId,
                         ISY_ShareBookTable.date];
        result = [db executeUpdate:sql];
        [db commit];
    }];
    
    if (result) {
        NSLog(@"create table success");
    }
    
}


#pragma mark - public

/**
 更新书本章节下载情况

 @param status status
 @param urlString urlString
 @param bookId bookId
 @param chaperNumber chaperNumber
 @return BOOL
 */
- (BOOL)updateDownLoadStatus:(NSInteger)status bookId:(NSString *)bookId chaperModel:(BookChapterModel *)chaperModel expectedSize:(long long)expectedSize{
    NSString *deleteSqlString = [NSString stringWithFormat:@"delete from %@ where %@ = ? and %@ = ?",
                                 ISYTable_DownloadTable.tableName,
                                 ISYTable_DownloadTable.bookId,
                                 ISYTable_DownloadTable.chaperId];
    
    NSString *insertSqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@) VALUES ( ?, ?, ?, ?, ?, ?)",
                                 ISYTable_DownloadTable.tableName,
                                 ISYTable_DownloadTable.bookId,
                                 ISYTable_DownloadTable.status,
                                 ISYTable_DownloadTable.chaperTitle,
                                 ISYTable_DownloadTable.chaperId,
                                 ISYTable_DownloadTable.chaperUrl,
                                 ISYTable_DownloadTable.size];
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        result = [db executeUpdate:deleteSqlString,
                  bookId,
                  chaperModel.l_id];
        result = result & [db executeUpdate:insertSqlString,
                           bookId,
                           @(status),
                           chaperModel.l_title,
                           chaperModel.l_id,
                           chaperModel.l_url,
                           @(expectedSize)];
        [db commit];
    }];
    return result;
}

//删除下载的书
- (BOOL)deleteDownloadBookId:(NSString *)bookId chaperModel:(BookChapterModel *)chaperModel {
    NSString *deleteSqlString = [NSString stringWithFormat:@"delete from %@ where %@ = ? and %@ = ?",
                                 ISYTable_DownloadTable.tableName,
                                 ISYTable_DownloadTable.bookId,
                                 ISYTable_DownloadTable.chaperId];
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        result = [db executeUpdate:deleteSqlString,
                  bookId,
                  chaperModel.l_id];
        [db commit];
    }];
    return result;
}

- (NSArray *)queryDownloadBooks:(NSInteger)status {
//    NSString *sqlString = [NSString stringWithFormat:@"SELECT *, sum(%@) / 4 as total,sum(%@) as totalSize FROM %@, %@ WHERE %@ = %@ GROUP by %@.%@",
    NSString *sqlString = @"SELECT * , sum(status) / 4 as total,sum(size) as totalSize FROM ISYTable_DownloadTable join ISY_BookTable WHERE status = 4 and ISYTable_DownloadTable.bookId = ISY_BookTable.bookId GROUP by ISYTable_DownloadTable.bookId";
//                           ISYTable_DownloadTable.status,
//                           ISYTable_DownloadTable.size,
//                           ISYTable_DownloadTable.tableName,
//                           ISY_BookTable.tableName,
//                           ISYTable_DownloadTable.status,
//                           status == 4 ? @(4) : @(2),
//                           ISYTable_DownloadTable.tableName,
//                           ISYTable_DownloadTable.status];
    __block NSMutableArray  *list = [ NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        FMResultSet *rs = [db executeQuery:sqlString];
        while ([rs next]) {
//            NSString *bookId =  [rs stringForColumn:ISYTable_DownloadTable.bookId];
            NSInteger total =  [rs intForColumn:@"total"];
            NSString *jsonString =  [rs stringForColumn:ISY_BookTable.bookDesJson];
            long long totalSize =  [rs intForColumn:@"totalSize"];
            
            BookDetailModel *model = [BookDetailModel yy_modelWithJSON:jsonString];
            model.downloadfinishCount = total;
            model.totaldownloadSize = totalSize;
            [list addObject:model];
        }
        [rs close];
        rs = nil;
    }];
    return [list copy];
}

- (NSArray *)queryDownloadingBooks {
//    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@, %@ WHERE %@ != %@ GROUP by %@.%@",
//                           ISYTable_DownloadTable.tableName,
//                           ISY_BookTable.tableName,
//                           ISYTable_DownloadTable.status,
//                           @(4),
//                           ISYTable_DownloadTable.tableName,
//                           ISYTable_DownloadTable.bookId];
    NSString *sqlString = @"SELECT * FROM ISYTable_DownloadTable join ISY_BookTable WHERE status != 4 and ISYTable_DownloadTable.bookId = ISY_BookTable.bookId GROUP by ISYTable_DownloadTable.bookId";
    __block NSMutableArray  *list = [ NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        FMResultSet *rs = [db executeQuery:sqlString];
        while ([rs next]) {
            NSString *bookid =  [rs stringForColumn:ISYTable_DownloadTable.bookId];
            NSLog(@"%@", bookid);
            NSString *jsonString =  [rs stringForColumn:ISY_BookTable.bookDesJson];
            
            BookDetailModel *model = [BookDetailModel yy_modelWithJSON:jsonString];
            //状态为3时，为暂停态
            model.suspend = [rs intForColumn:@"status"] != 2;
            [list addObject:model];
        }
        [rs close];
        rs = nil;
    }];
    return [list copy];
}

- (NSArray *)queryDownloadChapers:(NSInteger)status bookId:(NSString *)bookId {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM  %@ WHERE %@ = %@ AND %@ = %@",
                           ISYTable_DownloadTable.tableName,
                           ISYTable_DownloadTable.status,
                           @(status),
                           ISY_BookTable.bookId,
                           bookId];
    __block NSMutableArray  *list = [ NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        FMResultSet *rs = [db executeQuery:sqlString];
        while ([rs next]) {
            NSString *chaperId =  [rs stringForColumn:ISYTable_DownloadTable.chaperId];
            NSString *chaperUrl =  [rs stringForColumn:ISYTable_DownloadTable.chaperUrl];
            NSString *chaperTitle =  [rs stringForColumn:ISYTable_DownloadTable.chaperTitle];
            BookChapterModel *model = [[BookChapterModel alloc] init];
            model.l_id = chaperId;
            model.l_url = chaperUrl;
            model.l_title = chaperTitle;
            [list addObject:model];
        }
        [rs close];
        rs = nil;
    }];
    return [list copy];
}

- (NSArray *)queryDownloadingChapersBookId:(NSString *)bookId {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM  %@ WHERE %@ != %@ AND %@ = %@",
                           ISYTable_DownloadTable.tableName,
                           ISYTable_DownloadTable.status,
                           @(4),
                           ISY_BookTable.bookId,
                           bookId];
    __block NSMutableArray  *list = [ NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        FMResultSet *rs = [db executeQuery:sqlString];
        while ([rs next]) {
            NSString *chaperId =  [rs stringForColumn:ISYTable_DownloadTable.chaperId];
            NSString *chaperUrl =  [rs stringForColumn:ISYTable_DownloadTable.chaperUrl];
            NSString *chaperTitle =  [rs stringForColumn:ISYTable_DownloadTable.chaperTitle];
            BookChapterModel *model = [[BookChapterModel alloc] init];
            model.l_id = chaperId;
            model.l_url = chaperUrl;
            model.l_title = chaperTitle;
            [list addObject:model];
        }
        [rs close];
        rs = nil;
    }];
    return [list copy];
}

/**
 历史收听
 
 @param book BookDetailModel
 @return 插入结果
 */
- (BOOL)insertHistoryListenBook:(BookDetailModel *)book chaperNumber:(NSInteger)chaperNumber time:(NSInteger)time listentime:(NSInteger)listentime {
    NSString *bookId = book.show_id;
    
    NSString *deleteSqlString = [NSString stringWithFormat:@"delete from %@ where %@ = ?",
                                 ISYTable_HistoryListenTable.tableName,
                                 ISYTable_HistoryListenTable.bookId];
     NSString *insertSqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@) VALUES ( ?, ?, ?, ?)",
                                  ISYTable_HistoryListenTable.tableName,
                                  ISYTable_HistoryListenTable.bookId,
                                  ISYTable_HistoryListenTable.time,
                                  ISYTable_HistoryListenTable.chaperNumber,
                                  ISYTable_HistoryListenTable.listenTime];
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        result = [db executeUpdate:deleteSqlString,
                  bookId];
        result = result & [db executeUpdate:insertSqlString,
                           bookId,
                           @(time),
                           @(chaperNumber),
                           @(listentime)];
        [db commit];
    }];
    return result;
}

/**
 查询历史收听记录b

 @return NSArray
 */
- (NSArray  *)queryBookHistoryListen {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@, %@ WHERE %@.%@ = %@.%@ order by %@ desc LIMIT 50",
                           ISYTable_HistoryListenTable.tableName,
                           ISY_BookTable.tableName,
                           ISYTable_HistoryListenTable.tableName,
                           ISYTable_HistoryListenTable.bookId,
                           ISY_BookTable.tableName,
                           ISY_BookTable.bookId,
                           ISYTable_HistoryListenTable.listenTime];
    
    __block NSMutableArray  *list = [ NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        FMResultSet *rs = [db executeQuery:sqlString];
        while ([rs next]) {
            NSString *jsonString =  [rs stringForColumn:ISY_BookTable.bookDesJson];
            NSInteger chaperNumber =  [rs intForColumn:ISYTable_HistoryListenTable.chaperNumber];
            NSInteger time =  [rs intForColumn:ISYTable_HistoryListenTable.time];
            NSInteger listenTime =  [rs intForColumn:ISYTable_HistoryListenTable.listenTime];
            BookDetailModel *model = [BookDetailModel yy_modelWithJSON:jsonString];
            
            
            ISYHistoryListenModel *listenModel = [[ISYHistoryListenModel alloc] init];
            listenModel.bookModel = model;
            listenModel.chaperNumber = chaperNumber;
            listenModel.time = time;
            listenModel.listenTime = listenTime;
            [list addObject:listenModel];
        }
        [rs close];
        rs = nil;
    }];
    return [list copy];
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

/**
 本地搜索记录

 @param keyworkd keywordstring
 @return bool
 */
- (BOOL)insertSearchKeyword:(NSString *)keyworkd {
    NSString *deleteSqlString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?)",
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

/**
 查询历史搜索记录

 @return NSArray
 */
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


- (BOOL)deleteSearchKeywords {
    NSString *sqlString = [NSString stringWithFormat:@"delete from %@",
                           ISYTable_ReadSearchKeywordTable.tableName];
    __block BOOL res;
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db beginTransaction];
        res = [db executeUpdate:sqlString];
        [db commit];
    }];
    
    return res;
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

/**
 插入读书记录

 @param bookId bookid
 @param timeString 收听时间
 @return bool
 */
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

/**
 保存分享记录
 
 @param bookId bookId
 */
- (void)updateShareBookId:(NSString *)bookId {
    NSString *deleteSqlString = [NSString stringWithFormat:@"delete from %@ where %@ = ?",
                                 ISY_ShareBookTable.tableName,
                                 ISY_ShareBookTable.bookId];
    
    NSString *insertSqlString = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES ( ?, ?)",
                                 ISY_ShareBookTable.tableName,
                                 ISY_ShareBookTable.bookId,
                                 ISY_ShareBookTable.date];
    
    __block BOOL result = YES;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        result = [db executeUpdate:deleteSqlString,
                  bookId];
        result = [db executeUpdate:insertSqlString,
                  bookId,
                  @([[NSDate date] timeIntervalSince1970])];
        [db commit];
    }];
}

/**
 分享记录 24小时内
 
 @param bookId bookId
 @return BOOL
 */
- (BOOL)hasShareBook:(NSString *)bookId {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM  %@ WHERE %@ == %@",
                           ISY_ShareBookTable.tableName,
                           ISY_ShareBookTable.bookId,
                           bookId];
    __block long timeInterval = 0;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        FMResultSet *rs = [db executeQuery:sqlString];
        while ([rs next]) {
            timeInterval = [rs longForColumn:ISY_ShareBookTable.date];
        }
        [rs close];
        rs = nil;
    }];
    if (timeInterval == 0) {
        return NO;
    }
    return [[NSDate date] timeIntervalSince1970] - timeInterval <= 24 * 60 * 60;//
}
@end
