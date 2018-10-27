//
//  CategoryModel.m
//  iShuYin
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"son_cats":[CategoryModel class]};
}

+ (NSArray *)modelPropertyBlacklist {
    return @[@"sectionHeight"];
}

- (CGFloat)sectionHeight {
    CGFloat h = 40;
    NSInteger row = self.son_cats.count/3 + (self.son_cats.count%3 != 0);
    return 40 + 16 + 16 + row*h + (row-1)*16;
}

@end
