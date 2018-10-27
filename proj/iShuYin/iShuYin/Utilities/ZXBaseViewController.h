//
//  ZXBaseViewController.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXBaseViewController : UIViewController

- (void)addNavBtnWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;

- (void)addNavBtnWithImage:(NSString *)imgName target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;

- (void)addNavBtnsWithImages:(NSArray *)images target:(id)target actions:(NSArray *)actions isLeft:(BOOL)isLeft;

- (void)requestAppUpdate;

@end
