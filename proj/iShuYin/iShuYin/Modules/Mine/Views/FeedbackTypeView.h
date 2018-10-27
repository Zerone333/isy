//
//  FeedbackTypeView.h
//  iShuYin
//
//  Created by Apple on 2017/6/13.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackTypeView : UIView

@property (nonatomic, copy) void (^dismissBlock)();

@property (nonatomic, copy) void (^selectBlock)(NSDictionary *dict);

@end
