//
//  BookDetailOthersView.h
//  iShuYin
//
//  Created by Apple on 2017/8/14.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookDetailOthersView : UIView

@property (nonatomic, assign) NSString *title;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) void (^bookBlock)(NSString *book_id);

@property (nonatomic, strong) void (^moreBlock)();

@end
