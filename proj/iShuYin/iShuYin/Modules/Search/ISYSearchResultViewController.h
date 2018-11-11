//
//  ISYSearchResultViewController.h
//  iShuYin
//
//  Created by ND on 2018/11/11.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ZXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ISYSearchResultViewController : ZXBaseViewController
@property (nonatomic, copy) NSArray *firstDataSource;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSArray *hotKeyWords;
@end

NS_ASSUME_NONNULL_END
