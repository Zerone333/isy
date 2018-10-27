//
//  BookDownloadBottomView.h
//  iShuYin
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookDetailModel;

@interface BookDownloadBottomView : UIView

@property (nonatomic, strong) BookDetailModel *detailModel;

@property (nonatomic, strong) void (^itemBlock)(NSInteger index);

@property (nonatomic, strong) void (^allBlock)(BOOL isAll);

@property (nonatomic, strong) void (^downloadBlock)(void);

@property (nonatomic, assign) BOOL isChooseAll;//一个个选是否全选了

@end
