//
//  ZXCycleView.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXCycleView;

typedef NS_ENUM(NSInteger,ZXImageType) {
    ZXImageTypeName   = 0,
    ZXImageTypePath   = 1,
    ZXImageTypeURL    = 2,
    ZXImageTypeObject = 3,
};

typedef NS_ENUM(NSInteger,ZXScrollDirection) {
    ZXScrollDirectionLeft   = 1 << 0,
    ZXScrollDirectionRight  = 1 << 1,
    ZXScrollDirectionTop    = 1 << 2,
    ZXScrollDirectionBottom = 1 << 3,
};
typedef NS_ENUM(NSInteger,ZXPageCtrlStyle) {
    ZXPageCtrlStyleNone    = 0,
    ZXPageCtrlStyleDefault = 1,
    ZXPageCtrlStyleCustom  = 2,
};
typedef NS_ENUM(NSInteger,ZXPageCtrlAlignment) {
    ZXPageCtrlAlignmentHorizontalLeft   = 0,
    ZXPageCtrlAlignmentHorizontalCenter = 1,
    ZXPageCtrlAlignmentHorizontalRight  = 2,
    ZXPageCtrlAlignmentVerticalLeft     = 3,
    ZXPageCtrlAlignmentVerticalCenter   = 4,
    ZXPageCtrlAlignmentVerticalRight    = 5,
};
typedef NS_ENUM(NSInteger,ZXCycleViewTitleMode) {
    ZXCycleViewTitleModeChange = 0,
    ZXCycleViewTitleModeScroll = 1,
};

typedef void (^SelectBlock) (ZXCycleView *,NSInteger);

@protocol ZXCycleViewDelegate <NSObject>

@required

- (void)cycleView:(ZXCycleView *)cycleView didSelectItemAtIndex:(NSInteger)index;

@end


@interface ZXCycleView : UIView

#pragma mark - ****************************Property****************************
#pragma mark + delegate & block
///=============================================================================
/// @name delegate & block
///=============================================================================
/*!
 @brief
 *default is nil.
 */
@property (nonatomic,weak)id <ZXCycleViewDelegate>delegate;

/*!
 @brief
 *default is nil.c
 *block will be call back when clicked the imageView.
 *if set,the priority is greater than the delegate.
 */
@property (nonatomic,strong)SelectBlock selectBlock;

#pragma mark + dataSource
///=============================================================================
/// @name dataSource
///=============================================================================
/*!
 @brief
 *default is nil.the array contains strings of image name.
 */
@property (nonatomic,strong)NSArray *imageNames;
/*!
 @brief
 *default is nil.the array contains strings of image path.
 */
@property (nonatomic,strong)NSArray *imagePaths;
/*!
 @brief
 *default is nil.the array contains strings of image url.
 */
@property (nonatomic,strong)NSArray *imageURLs;
/*!
 @brief
 *default is nil.the array contains objects of image.
 */
@property (nonatomic,strong)NSArray *imageObjects;
/*!
 @brief
 *default is nil.the array contains strings of image title.
 */
@property (nonatomic,strong)NSArray *titleArray;
/*!
 @brief
 *default is nil.the placeholder image name.
 */
@property (nonatomic,copy)NSString *placeholder;

#pragma mark + scrollView
///=============================================================================
/// @name scrollView
///=============================================================================
/*!
 @brief
 *default is YES.
 *Generally,be used to pause or resume the function of auto scroll.
 *In order to the visual effect,the time interval can't be 0.0 and image count can't be less than 2.
 */
@property (nonatomic,assign)BOOL circularly;

/*!
 @brief
 *default is YES.
 *Pay attention to the difference between "userCanTap" and "userInteractionEnabled".
 *if userCanTap is NO,imageViews unable to respond to events,but scrollView can be dragged.
 *if userInteractionEnabled is NO,will turn off all.
 */
@property (nonatomic,assign)BOOL userCanTap;

/*!
 @brief
 *default is ZXScrollDirectionLeft.
 */
@property (nonatomic,assign)ZXScrollDirection scrollDirection;

/*!
 @brief
 *default is 0.0 .
 *if set,will auto scroll by timeInterval repeatedly.
 *if circularly is NO,setting is invalid.
 *if the image count is less than 2,setting is invalid.
 *if you want to set an animationType or some animationTypes,the advice is set to 5.0 at least
 *for the better visual effect.
 */
@property (nonatomic,assign)double timeInterval;

#pragma mark + pageCtrl
///=============================================================================
/// @name pageCtrl
///=============================================================================
/*!
 @brief
 *default is ZXPageCtrlStyleNone.
 *if set,will init a page control at the specified position.
 */
@property (nonatomic,assign)ZXPageCtrlStyle pageCtrlStyle;

/*!
 @brief
 *default is YES.if NO,will hide the page control.
 *if pageCtrlStyle is ZXPageCtrlStyleNone,setting is invalid.
 */
@property (nonatomic,assign)BOOL showPageCtrl;

/*!
 @brief
 *default is light gray color.
 *if pageCtrlStyle is ZXPageCtrlStyleNone,setting is invalid.
 */
@property (nonatomic,strong)UIColor *pageIndicatorTintColor;

/*!
 @brief
 *default is white color.
 *if pageCtrlStyle is ZXPageCtrlStyleNone,setting is invalid.
 */
@property (nonatomic,strong)UIColor *currentPageIndicatorTintColor;

/*!
 @brief
 *default is ZXPageCtrlAlignmentHorizontalCenter.
 *if pageCtrlStyle is ZXPageCtrlStyleNone,setting is invalid.
 *if the title Array is not nil,the advice is set to ZXPageCtrlAlignmentHorizontalRight.
 *because the titleLabel will be created at left bottom.
 */
@property (nonatomic,assign)ZXPageCtrlAlignment pageCtrlAlignment;

#pragma mark + label
///=============================================================================
/// @name label
///=============================================================================
/*!
 @brief
 *default is ZXCycleViewTitleModeChange.
 *if you want to present the visual effect,you must have a titleArray.
 */
@property (nonatomic,assign)ZXCycleViewTitleMode titleMode;

/*!
 @brief
 *default is system font of size 14.
 */
@property (nonatomic,strong)UIFont *titleFont;

/*!
 @brief
 *default is white color.
 */
@property (nonatomic,strong)UIColor *titleColor;

/*!
 @brief
 *default is clear color.
 */
@property (nonatomic,strong)UIColor *titleBackgroundColor;

#pragma mark + animation
///=============================================================================
/// @name animation
///=============================================================================
/*!
 @brief
 *default is YES.
 *if animationTypes is nil,setting is invalid.
 *Generally,be used to pause or resume the animation when auto scroll.
 */
@property (nonatomic,assign)BOOL animationWhenAutoScroll;

/*!
 @brief
 *default is NO.
 *if animationTypes is nil,setting is invalid.
 *Generally,be used to pause or resume the animation when dragging.
 */
@property (nonatomic,assign)BOOL animationWhenDragging;

/*!
 @brief
 *default is NO.
 *if the animationTypes is nil,setting is invalid.
 *if the count of animationTypes is less than 2,setting is invalid.
 */
@property (nonatomic,assign)BOOL animationRandom;

/*!
 @brief
 *default is nil.the array contains string of animation type.
 */
@property (nonatomic,strong)NSArray *animationTypes;



#pragma mark - ****************************Public API****************************
#pragma mark + Creation Methods
///=============================================================================
/// @name Creation Methods
///=============================================================================

- (instancetype)initWithFrame:(CGRect)frame
                pageCtrlStyle:(ZXPageCtrlStyle)pageCtrlStyle
                 timeInterval:(double)timeInterval;

- (instancetype)initWithFrame:(CGRect)frame
                pageCtrlStyle:(ZXPageCtrlStyle)pageCtrlStyle
                 timeInterval:(double)timeInterval
                   circularly:(BOOL)circularly
                   userCanTap:(BOOL)userCanTap
              scrollDirection:(ZXScrollDirection)scrollDirection;

+ (instancetype)cycleView;

+ (instancetype)cycleViewWithFrame:(CGRect)frame;

+ (instancetype)cycleViewWithFrame:(CGRect)frame
                     pageCtrlStyle:(ZXPageCtrlStyle)pageCtrlStyle
                      timeInterval:(double)timeInterval;

+ (instancetype)cycleViewWithFrame:(CGRect)frame
                     pageCtrlStyle:(ZXPageCtrlStyle)pageCtrlStyle
                      timeInterval:(double)timeInterval
                        circularly:(BOOL)circularly
                        userCanTap:(BOOL)userCanTap
                   scrollDirection:(ZXScrollDirection)scrollDirection;

#pragma mark + Helper Methods
///=============================================================================
/// @name Helper Methods
///=============================================================================

- (void)configPageCtrlWithColor:(UIColor *)color
                   currentColor:(UIColor *)currentColor
                      alignment:(ZXPageCtrlAlignment)alignment;

- (void)configTitleLabelWithFont:(UIFont *)font
                       textColor:(UIColor *)textColor
                 backgroundColor:(UIColor *)backgroundColor;

- (void)configAnimationWithAnimationRandom:(BOOL)random
                   animationWhenAutoScroll:(BOOL)animationWhenAutoScroll
                     animationWhenDragging:(BOOL)animationWhenDragging;

@end
