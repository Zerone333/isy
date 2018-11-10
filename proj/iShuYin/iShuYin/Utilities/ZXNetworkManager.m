//
//  ZXNetworkManager.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXNetworkManager.h"
#import <Foundation/NSHTTPCookieStorage.h>
#define kTimeOut 5

@interface ZXNetworkManager ()
@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic,strong) AFNetworkReachabilityManager *reachabilityManager;
@end

@implementation ZXNetworkManager

- (void)clearCache {
    //删除cache
    [_sessionManager.session.configuration.URLCache removeAllCachedResponses];
    //删除cookie
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for(NSHTTPCookie *cookie in storage.cookies) {
        [storage deleteCookie:cookie];
    }
    [storage removeCookiesSinceDate:[NSDate date]];
}

+ (instancetype)shareManager {
    static ZXNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[ZXNetworkManager alloc]init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *array = @[@"application/json",@"application/text",
                           @"text/json",@"text/html",@"text/javascript"];
        
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = kTimeOut;
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:array];
        
        _reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [_reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown: {
                    APPDELEGATE.isOnline = NO;
                    DLog(@"未知");
                }break;
                case AFNetworkReachabilityStatusNotReachable: {
                    APPDELEGATE.isOnline = NO;
                    DLog(@"没有网络");
                }break;
                case AFNetworkReachabilityStatusReachableViaWWAN: {
                    APPDELEGATE.isOnline = YES;
                    DLog(@"3G|4G");
                }break;
                case AFNetworkReachabilityStatusReachableViaWiFi: {
                    APPDELEGATE.isOnline = YES;
                    DLog(@"WiFi");
                }break;
                default:
                    break;
            }
        }];
    }
    return self;
}

- (void)checkNetwork {
    [_reachabilityManager startMonitoring];
}

- (void)GETWithURLString:(NSString *)urlstring
               parameters:(NSDictionary *)parameters
                 progress:(void (^)(NSProgress *))uploadProgress
                  success:(void (^)(NSURLSessionDataTask *,id))success
                  failure:(void (^)(NSURLSessionDataTask *,NSError *))failure {
    if (!APPDELEGATE.isOnline) {
        [ZXProgressHUD hide];
        [SVProgressHUD showImage:nil status:@"请检查网络"];
        return;
    }
    NSMutableDictionary *dict;
    if (parameters) {
        dict = parameters.mutableCopy;
    }else {
        dict = [[NSMutableDictionary alloc]init];
    }
    [dict setObject:@"iOS" forKey:@"app_channel"];
    [dict setObject:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] forKey:@"app_version"];
    NSURLSessionDataTask *task = [_sessionManager GET:urlstring parameters:dict progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ZXProgressHUD hide];
        !success?:success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZXProgressHUD hide];
        !failure?:failure(task,error);
    }];
    DLog(@"%@", task.currentRequest.URL);
    DLog(@"%@", dict);
}

- (void)POSTWithURLString:(NSString *)urlstring
               parameters:(NSDictionary *)parameters
                 progress:(void (^)(NSProgress *))uploadProgress
                  success:(void (^)(NSURLSessionDataTask *,id))success
                  failure:(void (^)(NSURLSessionDataTask *,NSError *))failure {
    if (!APPDELEGATE.isOnline) {
        [ZXProgressHUD hide];
        [SVProgressHUD showImage:nil status:@"请检查网络"];
        return;
    }
    NSMutableDictionary *dict;
    if (parameters) {
        dict = parameters.mutableCopy;
    }else {
        dict = [[NSMutableDictionary alloc]init];
    }
    [dict setObject:@"iOS" forKey:@"app_channel"];
    [dict setObject:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] forKey:@"app_version"];
    NSURLSessionDataTask *task = [_sessionManager POST:urlstring parameters:dict progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ZXProgressHUD hide];
        !success?:success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZXProgressHUD hide];
        !failure?:failure(task,error);
    }];
    DLog(@"%@", task.currentRequest.URL);
    DLog(@"%@", dict);
}

- (NSURLSessionTask *)downloadWithRequest:(NSURLRequest *)request
                                 progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                              destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                        completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
    if (!APPDELEGATE.isOnline) {
        [ZXProgressHUD hide];
        [SVProgressHUD showImage:nil status:@"请检查网络"];
        return nil;
    }
    NSURLSessionTask *task = [_sessionManager downloadTaskWithRequest:request progress:downloadProgressBlock destination:destination completionHandler:completionHandler];
    return task;
}

- (NSString *)URLStringWithQuery:(Query)queryType {
    NSString *query = nil;
    switch (queryType) {
        //账号
        case QueryLogin:query = @"login";break;
        case QueryLogout:query = @"logout";break;
        case QueryRegister:query = @"register";break;
        case QueryFindPassword:query = @"findPassword";break;
        case QueryModifyPassword:query = @"modifyPassword";break;
        //首页
        case QueryHomeList:query = @"index";break;
        case QueryHomeMore:query = @"getBookList";break;
        case QueryHomeSerial:query = @"index_lian";break;
        case QueryHomeFinish:query = @"index_over";break;
        //分类
        case QueryCategory:query = @"getCategory";break;
        //详情
        case QueryBookDetail:query = @"getBookDetail";break;
        //收藏
        case QueryCollectionList:query = @"getCollectionList";break;
        case QueryCollectionOperate:query = @"operateCollection";break;
        //留言
        case QueryFeedBackList:query = @"getFeedBack";break;
        case QueryFeedBackAdd:query = @"addFeedBack";break;
        case QueryFeedBackDel:query = @"delFeedBack";break;
        //播放记录
        case QueryPlayRecordList:query = @"getPlayRecord";break;
        //操作
        case QueryCuiGeng:query = @"cuiGengN";break;

        default:break;
    }
    return [APPDELEGATE.base_url stringByAppendingString:query];
}

- (NSString *)URLStringWithQuery2:(Query2)queryType {
    NSString *query = nil;
    switch (queryType) {
        //启动
        case Query2AppVersion:query = @"getNewVersion";break;
            //首页
        case Query2HomeList:query = @"index";break;
            //首页
        case Query2Category:query = @"getCategory";break;
            //首页-推荐
        case Query2IndexRecom:query = @"index_recom";break;
            //首页-热播
        case Query2IndexHot:query = @"index_hot";break;
            //获取评论
        case Query2getCommentList:query = @"getCommentList";break;
            //发表评论
        case Query2AddComment:query = @"addComment";break;
        default:break;
    }
    return [APPDELEGATE.base_url_2 stringByAppendingString:query];
}

@end

