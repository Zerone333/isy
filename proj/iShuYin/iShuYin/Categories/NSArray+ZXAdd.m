//
//  NSArray+ZXAdd.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "NSArray+ZXAdd.h"

@implementation NSArray (ZXAdd)

- (id)randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

//json数组解析
+ (instancetype)arrayWithJsonData:(NSData *)data {
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (array && !error) {
        return array;
    }
    return nil;
}

@end
