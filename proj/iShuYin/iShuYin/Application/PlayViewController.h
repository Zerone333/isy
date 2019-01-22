//
//  PlayViewController.h
//  iShuYin
//
//  Created by Apple on 2017/8/27.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXBaseViewController.h"

@class BookDetailModel;

@interface PlayViewController : ZXBaseViewController

@property (nonatomic, strong, readonly) BookDetailModel *detailModel;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
- (void)playWithBook:(BookDetailModel *)detailModel index:(NSInteger)idx;
- (void)playWithBook:(BookDetailModel *)detailModel index:(NSInteger)idx duration:(NSInteger)duration;
- (void)pause;

- (void)playPrevious;

- (void)playNext;

- (BOOL)hasBook;

@end
