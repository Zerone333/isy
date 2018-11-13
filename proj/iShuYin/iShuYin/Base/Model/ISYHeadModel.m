//
//  ISYHeadModel.m
//  iShuYin
//
//  Created by ND on 2018/11/13.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYHeadModel.h"

@implementation ISYHeadModel

+(instancetype)itemWithTitleString:(NSString *)titleString imageName:(NSString *)imageName {
    ISYHeadModel *item = [[ISYHeadModel alloc]init];
    item.titleString = titleString;
    item.imageName = imageName;
    return item;
}
@end
