//
//  ZXCountDownButton.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountDownButtonDelegate <NSObject>
@required
- (void)countDownButtonDidClick:(UIButton *)btn;
@end

@interface ZXCountDownButton : UIButton

/*!
 @brief control the status of countdown.
 */
@property(nonatomic,assign)BOOL pause;

/*!
 @brief the duration of countdown.
 */
@property(nonatomic,assign)NSInteger clockNum;

/*!
 @brief default is 60.
 */
@property(nonatomic,assign)NSInteger frameInterval;

/*!
 @brief default is white.
 */
@property(nonatomic,strong)UIColor *enabledTitleColor;

/*!
 @brief default is red.
 */
@property(nonatomic,strong)UIColor *enabledBackgroundColor;

/*!
 @biref default is gray.
 */
@property(nonatomic,strong)UIColor *disabledTitleColor;

/*!
 @brief default is light gray.
 */
@property(nonatomic,strong)UIColor *disabledBackgroundColor;

/*!
 @brief the priority is greater than delegate.
 */
@property(nonatomic,strong)void (^targetBlock)();

/*!
 @brief the priority is less than block.
 */
@property(nonatomic,weak)id <CountDownButtonDelegate> delegate;

/*!
 @brief creation method.
 */
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
