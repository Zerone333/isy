//
//  CommentTableViewCell.h
//  iShuYin
//
//  Created by 李艺真 on 2018/10/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeBookModel.h"

@interface CommentTableViewCell : UITableViewCell
@property (nonatomic, strong) HomeBookModel *model;
+ (CGFloat)cellHeight;
+ (NSString *)cellID;
@end

