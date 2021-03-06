//
//  ISYBookTableViewCell.h
//  iShuYin
//
//  Created by ND on 2018/10/27.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeBookModel;

typedef void(^ISYBookTableViewCellItemClickBlock)(HomeBookModel *book);

// 包含collectionView的cell
@interface ISYBookTableViewCell : UITableViewCell
@property (nonatomic, copy) ISYBookTableViewCellItemClickBlock itemClickBlock;
/**
 cell行高

 @param lineCount collectionview 有多少行
 @return CGFloat
 */
+ (CGFloat)cellHeightForLineCount:(NSInteger)lineCount;

/**
 更新数据

 @param dataSource <HomeBookModel>
 */
- (void)updateDataSource:(NSArray *)dataSource;

+ (NSString *)cellID;
@end

