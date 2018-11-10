//
//  ISYPutCommentView.h
//  iShuYin
//
//  Created by ND on 2018/11/10.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ISYPutCommentViewCallBack)(NSString *des);
@interface ISYPutCommentView : UIView

+ (void)showWithCallBack:(ISYPutCommentViewCallBack)callback;
@end
