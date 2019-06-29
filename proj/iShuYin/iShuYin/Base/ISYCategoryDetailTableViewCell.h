//
//  ISYCategoryDetailTableViewCell.h
//  iShuYin
//
//  Created by ND on 2018/11/11.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYBookListTableViewCell.h"

@interface ISYCategoryDetailTableViewCell : ISYBookListTableViewCell
+ (NSString *)cellID;

/**
 <#Description#>

 @param model <#model description#>
 @param type type = 1 分类页面cell
 */
- (void)updateModel:(NSObject *)model type:(NSInteger)type;
@end

