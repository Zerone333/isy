//
//  BookDetailModel.m
//  iShuYin
//
//  Created by Apple on 2017/8/14.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookDetailModel.h"
#import "HomeBookModel.h"

@implementation BookChapterModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _isSelected = NO;
    }
    return self;
}

- (NSString *)description {
    return self.l_id;
}

@end



@implementation BookDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc":@"description",
             @"chapters":@"data"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"chapters":[BookChapterModel class],
             @"actor_books":[HomeBookModel class],
             @"director_books":[HomeBookModel class],
             @"download_chapters":[BookChapterModel class],
             };
}

@end
