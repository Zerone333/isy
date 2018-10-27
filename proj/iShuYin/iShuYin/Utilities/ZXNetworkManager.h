//
//  ZXNetworkManager.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger,Query) {
    //账号
    QueryLogin,//登录
    QueryLogout,//登出
    QueryRegister,//注册
    QueryFindPassword,//找回密码
    QueryModifyPassword,//修改密码
    //首页
    QueryHomeList,//首页-榜单
    QueryHomeMore,//首页-更多
    QueryHomeSerial,//首页-连载
    QueryHomeFinish,//首页-完结
    //分类
    QueryCategory,//分类
    
    //详情
    QueryBookDetail,//详情

    //收藏
    QueryCollectionList,//收藏列表
    QueryCollectionOperate,//收藏操作
    
    //留言
    QueryFeedBackList,//留言列表
    QueryFeedBackAdd,//添加留言
    QueryFeedBackDel,//删除留言
    
    //播放记录
    QueryPlayRecordList,//播放记录
    
    
    //操作
    QueryCuiGeng,//催更
};

typedef NS_ENUM(NSInteger,Query2) {
    //启动
    Query2AppVersion,//系统-获取APP版本号
    Query2HomeList,//首页
    Query2Category,//分类
    Query2IndexRecom,//首页-推荐
    Query2IndexHot,//首页-热播
};

@interface ZXNetworkManager : NSObject

+ (instancetype)shareManager;

- (void)checkNetwork;

- (void)clearCache;

/*!
 @brief
 *GET
 */
- (void)GETWithURLString:(NSString *)urlstring
              parameters:(NSDictionary *)parameters
                progress:(void (^)(NSProgress *))uploadProgress
                 success:(void (^)(NSURLSessionDataTask *,id))success
                 failure:(void (^)(NSURLSessionDataTask *,NSError *))failure;
/*!
 @brief
 *POST
 */
- (void)POSTWithURLString:(NSString *)urlstring
               parameters:(NSDictionary *)parameters
                 progress:(void (^)(NSProgress *progress))uploadProgress
                  success:(void (^)(NSURLSessionDataTask *task,id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;
/*!
 @brief
 *Download
 */
- (NSURLSessionTask *)downloadWithRequest:(NSURLRequest *)request
                                 progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                              destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                        completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

- (NSString *)URLStringWithQuery:(Query)query;

- (NSString *)URLStringWithQuery2:(Query2)query2;

@end
