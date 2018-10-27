//
//  HomeFoundItemModel.m
//  iShuYin
//
//  Created by 李艺真 on 2018/10/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "HomeFoundItemModel.h"

@implementation HomeFoundItemModel


- (void)refreshDataWithCount:(NSInteger)count {
    self.randarDataSource = [self makeRandomItems:self.dataSource count:count];
}

/**
 随机抽取3个item
 */
- (NSArray *)makeRandomItems:(NSArray *)array count:(NSInteger)count{
    if (array.count < count) {
        return array;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    NSInteger inedx = 0;
    while (inedx != count) {
        int y = 0 + (arc4random() % array.count);
        [tempArray addObject:array[y]];
        ++inedx;
    }
    return tempArray;
}
@end
