//
//  ISYHistoryListenModel.h
//  iShuYin
//
//  Created by ND on 2018/11/13.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookDetailModel.h"

@interface ISYHistoryListenModel : NSObject
@property (nonatomic, strong) BookDetailModel *bookModel;
@property (nonatomic, assign) NSInteger chaperNumber;
@property (nonatomic, assign) NSInteger listenTime;
@property (nonatomic, assign) NSInteger time;
@end
