//
//  ZXStarRatingView.h
//  JWXShopClient
//
//  Created by Apple on 2016/12/20.
//  Copyright © 2016年 angxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(ZXStarRatingView *)view score:(NSInteger)score;

@end

@interface ZXStarRatingView : UIView

@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                     backStar:(NSString *)backStar
                     foreStar:(NSString *)foreStar
                       number:(NSInteger)number
                        width:(CGFloat)width
                       height:(CGFloat)height
                        space:(CGFloat)space;

- (void)setScore:(float)score withAnimation:(bool)isAnimate;

- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;

@end
