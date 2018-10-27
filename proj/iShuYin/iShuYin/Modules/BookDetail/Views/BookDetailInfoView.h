//
//  BookDetailInfoView.h
//  iShuYin
//
//  Created by Apple on 2017/8/14.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookDetailModel;

@interface BookDetailInfoView : UIView

@property (nonatomic, strong) BookDetailModel *model;

@property (nonatomic, strong) void (^collectionBlock)();

@property (nonatomic, strong) void (^shareBlock)();

@end
