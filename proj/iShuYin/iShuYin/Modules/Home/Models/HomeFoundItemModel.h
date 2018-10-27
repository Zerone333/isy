//
//  HomeFoundItemModel.h
//  iShuYin
//
//  Created by 李艺真 on 2018/10/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTableCell.h"

@interface HomeFoundItemModel : NSObject
@property (nonatomic, copy) NSString *keyType;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) NSArray *randarDataSource;
@property (nonatomic, assign) HomeTableCellViewType cellType;
- (void)refreshDataWithCount:(NSInteger)count;
@end

