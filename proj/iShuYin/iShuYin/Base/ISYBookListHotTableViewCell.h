//
//  ISYBookListHotTableViewCell.h
//  iShuYin
//
//  Created by ND on 2018/11/10.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYBookListTableViewCell.h"

// 热播
@interface ISYBookListHotTableViewCell : ISYBookListTableViewCell
- (void)setModel:(HomeBookModel *)model type:(NSString *)type;
//作者作品更多
- (void)setModel:(HomeBookModel *)model isAuthorMore:(BOOL)isAuthorMore;
@end
