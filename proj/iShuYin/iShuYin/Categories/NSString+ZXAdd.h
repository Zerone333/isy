//
//  NSString+ZXAdd.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZXAdd)

//字符串判空
+ (BOOL)isEmpty:(NSString *)string;

//邮箱正则
+ (BOOL)validateEmail:(NSString *)email;

//base64加密
- (NSString *)Base64String;

//base64解密
- (NSString *)Base64StringDecode;

//年月日
+ (NSString *)dateStringWithTimeIntervalSince1970:(NSString *)timeInterval;

//url转换
- (NSURL *)url;

//json字符串解析
- (id)jsonParse;

//解密播放链接
- (NSString *)decodePlayURL;

@end
