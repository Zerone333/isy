//
//  BookDetailDescOneView.h
//  iShuYin
//
//  Created by Apple on 2017/8/15.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookDetailDescOneView : UIView

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) void (^chapterBlock)();

@property (nonatomic, strong) void (^downloadBlock)();

@end
