//
//  HomeTableCell.h
//  iShuYin
//
//  Created by Apple on 2017/8/6.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HomeTableCellType) {
    HomeTableCellTypeRecommend = 0,
    HomeTableCellTypeHot = 1,
    HomeTableCellTypeNew = 2,
};

typedef enum : NSUInteger {
    HomeTableCellViewType_Collection,
    HomeTableCellViewType_Table,
} HomeTableCellViewType;

@interface HomeTableCell : UITableViewCell

//@property (nonatomic, assign) HomeTableCellType type;

@property (nonatomic, strong) void (^bookBlock)(NSString *book_id);

@property (nonatomic, strong) void (^moreBlock)(HomeTableCellType);

@property (nonatomic, strong) void (^refreshBlock)(void);

@property (nonatomic, assign) HomeTableCellViewType cellType;

- (void)updateDataSource:(NSArray *)dataSource cellType:(HomeTableCellViewType)cellType;
+(CGFloat)cellHeight:(HomeTableCellViewType)cellType;
- (void)refreshCategoryTitle:(NSString *)categoryTitle;
@end
