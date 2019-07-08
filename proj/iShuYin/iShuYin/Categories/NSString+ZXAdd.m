//
//  NSString+ZXAdd.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "NSString+ZXAdd.h"

@implementation NSString (ZXAdd)

//字符串判空
+ (BOOL)isEmpty:(NSString *)string {
    return ![string isKindOfClass:[NSString class]] || string == nil || string.length == 0;
}

//邮箱正则
+ (BOOL)validateEmail:(NSString *)email {
    NSString *reg = @"^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,})$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    BOOL isMatch = [predicate evaluateWithObject:email];
    return isMatch;
}

//base64加密
- (NSString *)Base64String {
    if ([NSString isEmpty:self]) {
        return nil;
    }
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

//base64解密
- (NSString *)Base64StringDecode {
    if ([NSString isEmpty:self]) {
        return nil;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//年月日
+ (NSString *)dateStringWithTimeIntervalSince1970:(NSString *)interval {
    NSDateComponents *comps = [[NSCalendar currentCalendar]components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSince1970:interval.doubleValue]];
    return [NSString stringWithFormat:@"%li-%02li-%02li",(long)comps.year,(long)comps.month,(long)comps.day];
}

//url转换
- (NSURL *)url {
    return [NSURL URLWithString:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL,kCFStringEncodingUTF8))];
}

//json字符串解析
- (id)jsonParse {
    if ([NSString isEmpty:self]) {
        return nil;
    }
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (obj && !error) {
        return obj;
    }
    return nil;
}

//解密播放链接
- (NSString *)decodePlayURL {
    if ([NSString isEmpty:self] || self.length < 2) {
        return nil;
    }
    //已经解密过了
    if ([self hasPrefix:@"http"]) {
        return self;
    }
    NSString *string = @"";
    NSRange pre_range = NSMakeRange(0, 1);
    NSString *pre_char = [self substringWithRange:pre_range];
    string = [self stringByAppendingString:pre_char];
    string = [string stringByReplacingCharactersInRange:pre_range withString:@""];
    return [[string Base64StringDecode]Base64StringDecode];
}

- (CGFloat)calculateWidth:(NSString *)str font:(UIFont *)font{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize size = [str sizeWithAttributes:dic];
    return size.width;
}

@end
