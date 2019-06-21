//
//  ZXTools.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXTools.h"

@implementation ZXTools

+ (instancetype)shareTools {
    static ZXTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tools == nil) {
            tools = [[ZXTools alloc]init];
        }
    });
    return tools;
}

- (UIViewController *)appVisibleContainingViewController {
    return [self appVisibleViewController].parentViewController;
}

- (UIViewController *)appVisibleViewController {
    return [self getVisibleViewControllerFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)getVisibleViewControllerFromViewController:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFromViewController:[((UITabBarController*) viewController) selectedViewController]];
    }
    else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFromViewController:[((UINavigationController*) viewController) visibleViewController]];
    }
    else {
        if (viewController.presentedViewController) {
            return [self getVisibleViewControllerFromViewController:viewController.presentedViewController];
        }else {
            return viewController;
        }
    }
}

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizerWithViewController:(UIViewController *)viewController {
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (viewController.view.gestureRecognizers.count > 0) {
        for (UIGestureRecognizer *recognizer in viewController.view.gestureRecognizers) {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}

- (void)removeFileAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL ret = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (ret && !isDir) {
        NSError *error = nil;
        [fileManager removeItemAtPath:path error:&error];
        if (error) {
            DLog(@"删除失败%@", error.localizedDescription);
        }
    }
}

- (BOOL)iphoneX {
    return [UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812;
}

- (double)systemAvailableMemory{
    double totalFreeSpace=0.f;
    NSError *error = nil;
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary) {
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalFreeSpace = [freeFileSystemSizeInBytes doubleValue] / 1024.0 / 1024.0;
    }
    return totalFreeSpace;
}

@end
