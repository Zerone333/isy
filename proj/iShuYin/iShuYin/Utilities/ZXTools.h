//
//  ZXTools.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXTools : NSObject

//单例
+ (instancetype)shareTools;

- (UIViewController *)appVisibleContainingViewController;

- (UIViewController *)appVisibleViewController;

- (UIViewController *)getVisibleViewControllerFromViewController:(UIViewController*)viewController;

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizerWithViewController:(UIViewController *)viewController;

//删除文件
- (void)removeFileAtPath:(NSString *)path;

- (BOOL)iphoneX;

@end
