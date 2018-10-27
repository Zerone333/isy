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

- (void)playWithBook:(BookDetailModel *)detailModel index:(NSInteger)idx;

- (void)pause;

- (void)playPrevious;

- (void)playNext;

- (BOOL)hasBook;

@end
