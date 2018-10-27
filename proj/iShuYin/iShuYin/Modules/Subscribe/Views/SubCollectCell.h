//
//  SubCollectCell.h
//  iShuYin
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeBookModel;

@interface SubCollectCell : UITableViewCell

@property (nonatomic, strong) HomeBookModel *bookModel;

@property (nonatomic, strong) void (^collectCancelBlock)(HomeBookModel *);

@end
