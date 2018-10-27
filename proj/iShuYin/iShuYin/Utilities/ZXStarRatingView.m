//
//  ZXStarRatingView.m
//  JWXShopClient
//
//  Created by Apple on 2016/12/20.
//  Copyright © 2016年 angxun. All rights reserved.
//

#import "ZXStarRatingView.h"
#define kBackgroundStar @"play_star_nor"
#define kForegroundStar @"play_star_sel"

@interface ZXStarRatingView ()
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;
@property (nonatomic, strong) NSString *backgroundStar;//背景星图
@property (nonatomic, strong) NSString *foregroundStar;//前景星图
@property (nonatomic, assign) NSInteger starNumber;//星星数量
@property (nonatomic, assign) CGFloat starWidth;//星星宽度
@property (nonatomic, assign) CGFloat starHeight;//星星高度
@property (nonatomic, assign) CGFloat starSpace;//星星间隔
@end

@implementation ZXStarRatingView

- (instancetype)initWithFrame:(CGRect)frame
                     backStar:(NSString *)backStar
                     foreStar:(NSString *)foreStar
                       number:(NSInteger)number
                        width:(CGFloat)width
                       height:(CGFloat)height
                        space:(CGFloat)space {
    self = [super initWithFrame:frame];
    if (self) {
        _starNumber = number;
        _starWidth = width;
        _starHeight = height;
        _starSpace = space;
        self.starBackgroundView = [self buidlStarViewWithImageName:backStar];
        self.starForegroundView = [self buidlStarViewWithImageName:foreStar];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
    }
    return self;
}

#pragma mark - Set Score
- (void)setScore:(float)score withAnimation:(bool)isAnimate {
    [self setScore:score withAnimation:isAnimate completion:^(BOOL finished){}];
}

- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion {
    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    if (score < 0){
        score = 0;
    }
    if (score > 1){
        score = 1;
    }
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    if(isAnimate){
        [UIView animateWithDuration:0.2 animations:^{
            [self changeStarForegroundViewWithPoint:point];
        } completion:^(BOOL finished){
            !completion?:completion(finished);
        }];
    } else {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark - Touche Event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point)){
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self changeStarForegroundViewWithPoint:point];
    }];
}

#pragma mark - Buidl Star View
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName {
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.starNumber; i ++){
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i*(self.starWidth+self.starSpace), 0, self.starWidth, self.starHeight);
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark - Change Star Foreground With Point
- (void)changeStarForegroundViewWithPoint:(CGPoint)point {
    CGPoint p = point;
    NSInteger score = 0;
    CGFloat length = self.starWidth + self.starSpace;
    
    if (p.x <= 0){
        p.x = 0;
        score = 0;
    }else if (p.x > 0 && p.x <= length) {//一颗星
        p.x = self.starWidth;
        score = 1;
    }else if (p.x > length && p.x <= 2*length) {//两颗星
        p.x = 2*self.starWidth + self.starSpace;
        score = 2;
    }else if (p.x > 2*length && p.x <= 3*length) {//三颗星
        p.x = 3*self.starWidth + 2*self.starSpace;
        score = 3;
    }else if (p.x > 3*length && p.x <= 4*length) {//四颗星
        p.x = 4*self.starWidth + 3*self.starSpace;
        score = 4;
    }else if (p.x > 4*length && p.x <= self.frame.size.width) {//五颗星
        p.x = self.frame.size.width;
        score = 5;
    }else {
        p.x = self.frame.size.width;
        score = 5;
    }
    
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)]){
        [self.delegate starRatingView:self score:score];
    }
}

@end
