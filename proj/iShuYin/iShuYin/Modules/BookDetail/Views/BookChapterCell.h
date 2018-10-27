//
//  BookChapterCell.h
//  iShuYin
//
//  Created by Apple on 2017/8/22.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookDetailModel;

@class BookChapterModel;

@interface BookChapterCell : UITableViewCell

@property (nonatomic, strong) BookDetailModel *detailModel;

@property (nonatomic, strong) BookChapterModel *chapterModel;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) void (^chooseBlock)(BookChapterModel *);

@end
