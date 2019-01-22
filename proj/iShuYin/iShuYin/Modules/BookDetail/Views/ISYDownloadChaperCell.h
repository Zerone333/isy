//
//  ISYDownloadChaperCell.h
//  iShuYin
//
//  Created by 李艺真 on 2018/12/8.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookDetailModel;

@class BookChapterModel;
NS_ASSUME_NONNULL_BEGIN

@interface ISYDownloadChaperCell : UITableViewCell
@property (nonatomic, strong) BookDetailModel *detailModel;

@property (nonatomic, strong) BookChapterModel *chapterModel;

@property (nonatomic, strong) NSString *url;
@end

NS_ASSUME_NONNULL_END
