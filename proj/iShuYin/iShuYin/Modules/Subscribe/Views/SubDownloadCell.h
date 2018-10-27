//
//  SubDownloadCell.h
//  iShuYin
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookDetailModel;

@interface SubDownloadCell : UITableViewCell

@property (nonatomic, strong) BookDetailModel *detailModel;

@property (nonatomic, strong) void (^deleteBlock)(BookDetailModel *m);

@end
