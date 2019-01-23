//
//  ISYChaperListView.h
//  iShuYin
//
//  Created by 李艺真 on 2019/1/13.
//  Copyright © 2019年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDetailModel.h"

typedef NS_ENUM(NSUInteger, ISYPalySort) {
    ISYPalySortshunxu,
    ISYPalySortSingle,
    ISYPalySortRandam,
};

typedef void(^ISYChaperListViewPlaySortCallBack)(ISYPalySort sort);
typedef void(^ISYChaperListViewSelectChaper)(NSInteger charpetIndex);

@interface ISYChaperListView : UIView
+ (instancetype)showWithBook:(BookDetailModel *)book;
@property (nonatomic, assign) ISYPalySort playSort;
@property (nonatomic, assign) BOOL sortNormal;   //正序显示
@property (nonatomic, copy) ISYChaperListViewPlaySortCallBack sortCallBack;
@property (nonatomic, copy) ISYChaperListViewSelectChaper selectChaperCB;
@end

