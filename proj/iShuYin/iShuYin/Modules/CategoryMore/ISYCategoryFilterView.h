//
//  ISYCategoryFilterView.h
//  iShuYin
//
//  Created by 李艺真 on 2018/12/15.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ISYCategoryFilterViewDismissBlock)(NSInteger selectIndex);

@interface ISYCategoryFilterView : UIView
@property (nonatomic, copy) ISYCategoryFilterViewDismissBlock dismissBlock;
+ (instancetype)viewWithArray:(NSArray *)arrar selectIndex:(NSInteger)selectIndex title:(NSString *)title icon:(NSString *)icon;
@end
