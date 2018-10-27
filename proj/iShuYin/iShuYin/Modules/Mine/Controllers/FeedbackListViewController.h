//
//  FeedbackListViewController.h
//  iShuYin
//
//  Created by Apple on 2017/9/19.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FeedbackType) {
    FeedbackTypeMessage = 0,//留言
    FeedbackTypeConsult = 1,//咨询
    FeedbackTypeReportError = 2,//报错
    FeedbackTypeRequestBook = 3,//求书
};

@interface FeedbackListViewController : UIViewController

@property (nonatomic, assign) FeedbackType type;//留言类型

@end
