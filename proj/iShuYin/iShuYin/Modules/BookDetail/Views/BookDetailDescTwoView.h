//
//  BookDetailDescTwoView.h
//  iShuYin
//
//  Created by Apple on 2017/8/15.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookDetailDescTwoView : UIView

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, assign) CGFloat unfoldHeight;//展开时的字符串高度

@property (nonatomic, strong) void (^chapterBlock)();

@property (nonatomic, strong) void (^downloadBlock)();

@end
