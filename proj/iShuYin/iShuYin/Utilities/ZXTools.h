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

//系统可用存储空间，单位MB，0为错误
- (double)systemAvailableMemory;

@end
