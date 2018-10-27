//
//  HomeModel.m
//  iShuYin
//
//  Created by Apple on 2017/8/6.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "HomeModel.h"
#import "HomeSlideModel.h"
#import "HomeBookModel.h"

@implementation HomeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newest":@"new"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"slide":[HomeSlideModel class],
             @"recommend":[HomeBookModel class],
             @"hot":[HomeBookModel class],
             @"newest":[HomeBookModel class],
             @"xiaoshuo":[HomeBookModel class],
             @"entertain":[HomeBookModel class],
             @"comment":[HomeBookModel class],
             @"child":[HomeBookModel class],
             @"opera":[HomeBookModel class],
             @"today":[HomeBookModel class],
             @"week":[HomeBookModel class],
             @"month":[HomeBookModel class]
             };
}
@end
