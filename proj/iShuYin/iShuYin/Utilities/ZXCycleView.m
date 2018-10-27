//
//  ZXCycleView.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "ZXCycleView.h"
#import <UIImageView+WebCache.h>

#define kDuration (2.0)
#define kTagValue (100)
#define kPageCtrlMargin (10)

@interface ZXCycleView () <UIScrollViewDelegate>
{
    BOOL _tempCircularly;
    ZXImageType _imageType;
    NSInteger _currentIndex;
    NSInteger _flag;
    
    UIImageView *_lastImgView;
    UIImageView *_currentImgView;
    UIImageView *_nextImgView;
    UILabel *_titleLabel;
}
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageCtrl;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSTimer *timer;
@end

@implementation ZXCycleView

#pragma mark - ****************************Public API****************************
#pragma mark + Creation Methods
///=============================================================================
/// @name Creation Methods
///=============================================================================
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame
                 pageCtrlStyle:ZXPageCtrlStyleNone
                  timeInterval:0.0];
}

- (instancetype)initWithFrame:(CGRect)frame
                pageCtrlStyle:(ZXPageCtrlStyle)pageCtrlStyle
                 timeInterval:(double)timeInterval {
    return [self initWithFrame:frame
                 pageCtrlStyle:pageCtrlStyle
                  timeInterval:timeInterval
                    circularly:YES
                    userCanTap:YES
               scrollDirection:ZXScrollDirectionLeft];
}

- (instancetype)initWithFrame:(CGRect)frame
                pageCtrlStyle:(ZXPageCtrlStyle)pageCtrlStyle
                 timeInterval:(double)timeInterval
                   circularly:(BOOL)circularly
                   userCanTap:(BOOL)userCanTap
              scrollDirection:(ZXScrollDirection)scrollDirection {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initialization];
        [self addSubview:self.scrollView];
        self.pageCtrlStyle = pageCtrlStyle;
        self.timeInterval = timeInterval;
        self.circularly = circularly;
        self.userCanTap = userCanTap;
        self.scrollDirection = scrollDirection;
    }
    return self;
}

+ (instancetype)cycleView {
    return [[[self class]alloc] init];
}

+ (instancetype)cycleViewWithFrame:(CGRect)frame {
    return [[[self class]alloc] initWithFrame:frame];
}

+ (instancetype)cycleViewWithFrame:(CGRect)frame
                     pageCtrlStyle:(ZXPageCtrlStyle)pageCtrlStyle
                      timeInterval:(double)timeInterval {
    return [[[self class]alloc] initWithFrame:frame
                                pageCtrlStyle:pageCtrlStyle
                                 timeInterval:timeInterval];
}

+ (instancetype)cycleViewWithFrame:(CGRect)frame
                     pageCtrlStyle:(ZXPageCtrlStyle)pageCtrlStyle
                      timeInterval:(double)timeInterval
                        circularly:(BOOL)circularly
                        userCanTap:(BOOL)userCanTap
                   scrollDirection:(ZXScrollDirection)scrollDirection {
    return [[[self class]alloc] initWithFrame:frame
                                pageCtrlStyle:pageCtrlStyle
                                 timeInterval:timeInterval
                                   circularly:circularly
                                   userCanTap:userCanTap
                              scrollDirection:scrollDirection];
}

#pragma mark + Helper Methods
///=============================================================================
/// @name Helper Methods
///=============================================================================
- (void)configPageCtrlWithColor:(UIColor *)color
                   currentColor:(UIColor *)currentColor
                      alignment:(ZXPageCtrlAlignment)alignment {
    self.pageIndicatorTintColor = color;
    self.currentPageIndicatorTintColor = currentColor;
    self.pageCtrlAlignment = alignment;
}

- (void)configTitleLabelWithFont:(UIFont *)font
                       textColor:(UIColor *)textColor
                 backgroundColor:(UIColor *)backgroundColor {
    self.titleFont = font;
    self.titleColor = textColor;
    self.titleBackgroundColor = backgroundColor;
}

- (void)configAnimationWithAnimationRandom:(BOOL)random
                   animationWhenAutoScroll:(BOOL)animationWhenAutoScroll
                     animationWhenDragging:(BOOL)animationWhenDragging {
    self.animationRandom = random;
    self.animationWhenAutoScroll = animationWhenAutoScroll;
    self.animationWhenDragging = animationWhenDragging;
}

#pragma mark - ****************************Private API****************************
#pragma mark + Initialization
///=============================================================================
/// @name Initialization
///=============================================================================
- (void)initialization {
    //Public:
    _delegate = nil;
    _selectBlock = nil;
    
    _imageNames = nil;
    _imagePaths = nil;
    _imageURLs = nil;
    _titleArray = nil;
    _placeholder = nil;
    
    _circularly = YES;
    _tempCircularly = YES;
    _userCanTap = YES;
    _scrollDirection = ZXScrollDirectionLeft;
    _timeInterval = 0.0;
    
    _pageCtrlStyle = ZXPageCtrlStyleNone;
    _showPageCtrl = YES;
    _pageIndicatorTintColor = [UIColor lightGrayColor];
    _currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageCtrlAlignment = ZXPageCtrlAlignmentHorizontalCenter;
    
    _titleMode = ZXCycleViewTitleModeChange;
    _titleFont = kFontSystem(14);
    _titleColor = [UIColor whiteColor];
    _titleBackgroundColor = [UIColor clearColor];
    
    _animationWhenAutoScroll = YES;
    _animationWhenDragging = NO;
    _animationRandom = NO;
    _animationTypes = nil;
    
    //Private:
    _imageType = ZXImageTypeName;
    _currentIndex = 0;
    _flag = 0;
    _lastImgView = nil;
    _currentImgView = nil;
    _nextImgView = nil;
    _titleLabel = nil;
    _scrollView = nil;
    _pageCtrl = nil;
    _dataArray = nil;
    _timer = nil;
}

#pragma mark + Getter
///=============================================================================
/// @name Getter
///=============================================================================
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        scrollView.delegate = self;
        scrollView.bounces = NO;
        scrollView.pagingEnabled = YES;
        scrollView.userInteractionEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.canCancelContentTouches = YES;
        scrollView.scrollsToTop = NO;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|
        UIViewAutoresizingFlexibleHeight;
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIPageControl *)pageCtrl {
    if (!_pageCtrl) {
        UIPageControl *pageCtrl = [[UIPageControl alloc]init];
        pageCtrl.frame = [self getPageCtrlFrame:pageCtrl];//要把pageCtrl传过去,因为此时_pageCtrl为nil
        pageCtrl.hidden = !_showPageCtrl;
        pageCtrl.hidesForSinglePage = YES;
        pageCtrl.pageIndicatorTintColor = _pageIndicatorTintColor;
        pageCtrl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
        pageCtrl.clipsToBounds = NO;
        pageCtrl.numberOfPages = _dataArray.count;
        pageCtrl.currentPage = 0;
        _pageCtrl = pageCtrl;
    }
    return _pageCtrl;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [UILabel labelWithFont:_titleFont
                                           text:_titleArray[0]
                                      textColor:_titleColor
                                  textAlignment:NSTextAlignmentLeft
                                  numberOfLines:1
                                  lineBreakMode:NSLineBreakByTruncatingTail
                                backgroundColor:_titleBackgroundColor
                      adjustsFontSizeToFitWidth:YES];
        label.frame = CGRectMake(10, self.bounds.size.height-30, self.bounds.size.width-20, 30);
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        _titleLabel = label;
    }
    return _titleLabel;
}

#pragma mark - **************Setter**************
#pragma mark + Setter Data Source
///=============================================================================
/// @name Setter Data Source
///=============================================================================
- (void)setImageNames:(NSArray *)imageNames {
    _imageType = ZXImageTypeName;
    _imageNames = imageNames;
    self.dataArray = _imageNames;
}

- (void)setImagePaths:(NSArray *)imagePaths {
    _imageType = ZXImageTypePath;
    _imagePaths = imagePaths;
    self.dataArray = _imagePaths;
}

- (void)setImageURLs:(NSArray *)imageURLs {
    _imageType = ZXImageTypeURL;
    _imageURLs = imageURLs;
    self.dataArray = _imageURLs;
}

- (void)setImageObjects:(NSArray *)imageObjects {
    _imageType = ZXImageTypeObject;
    _imageObjects = imageObjects;
    self.dataArray = _imageObjects;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = [dataArray copy];
    if (_dataArray.count == 0 && _placeholder.length > 0) {
        _imageType = ZXImageTypeName;
        _dataArray = @[_placeholder];
    }
    [self reloadData];
    [self timerSwitch];
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [self addTitleLabel];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    //    [self handleImageView:^(UIImageView *imageView) {
    //        if (!imageView.image) {//如果设置两次 placeholder ,那第二次的仍然不可用。
    //            imageView.image = [UIImage imageNamed:_placeholder];
    //        }
    //    }];
    [self reloadData];
}

#pragma mark + Setter ScrollView
///=============================================================================
/// @name Setter ScrollView
///=============================================================================
- (void)setCircularly:(BOOL)circularly {
    _circularly = circularly;
    _tempCircularly = _circularly;
    _scrollView.bounces = !_circularly;
    [self reloadData];
    [self timerSwitch];
}

- (void)setUserCanTap:(BOOL)userCanTap {
    _userCanTap = userCanTap;
    [self handleImageView:^(UIImageView *imgView) {
        imgView.userInteractionEnabled = _userCanTap;
    }];
}

- (void)setScrollDirection:(ZXScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    if (!_circularly) {
        [self handleImageView:^(UIImageView *imgView) {
            imgView.frame = [self getImageViewFrameWithIndex:imgView.tag-kTagValue];
        }];
    }else {
        _lastImgView.frame = [self getImageViewFrameWithIndex:0];
        _currentImgView.frame = [self getImageViewFrameWithIndex:1];
        _nextImgView.frame = [self getImageViewFrameWithIndex:2];
    }
    [self configScrollView];
}

- (void)setTimeInterval:(double)timeInterval {
    _timeInterval = timeInterval;
    [self timerSwitch];
}

#pragma mark + Setter PageCtrl
///=============================================================================
/// @name Setter PageCtrl
///=============================================================================
- (void)setPageCtrlStyle:(ZXPageCtrlStyle)pageCtrlStyle {
    _pageCtrlStyle = pageCtrlStyle;
    [self addPageCtrlWithStyle:pageCtrlStyle];
}

- (void)setShowPageCtrl:(BOOL)showPageCtrl {
    _showPageCtrl = showPageCtrl;
    if (_pageCtrl) {
        _pageCtrl.hidden = !_showPageCtrl;
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    if (_pageCtrl) {
        _pageCtrl.pageIndicatorTintColor = _pageIndicatorTintColor;
    }
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    if (_pageCtrl) {
        _pageCtrl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
    }
}

- (void)setPageCtrlAlignment:(ZXPageCtrlAlignment)pageCtrlAlignment {
    _pageCtrlAlignment = pageCtrlAlignment;
    if (_pageCtrl) {
        _pageCtrl.frame = [self getPageCtrlFrame:_pageCtrl];
    }
}

#pragma mark + Setter TitleLabel
///=============================================================================
/// @name Setter TitleLabel
///=============================================================================
- (void)setTitleMode:(ZXCycleViewTitleMode)titleMode {
    _titleMode = titleMode;
    [self addTitleLabel];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self handleLabel:^(UILabel *label) {
        label.font = _titleFont;
    }];
    if (_titleLabel) {
        _titleLabel.font = _titleFont;
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self handleLabel:^(UILabel *label) {
        label.textColor = _titleColor;
    }];
    if (_titleLabel) {
        _titleLabel.textColor = _titleColor;
    }
}

- (void)setTitleBackgroundColor:(UIColor *)titleBackgroundColor {
    _titleBackgroundColor = titleBackgroundColor;
    [self handleLabel:^(UILabel *label) {
        label.backgroundColor = _titleBackgroundColor;
    }];
    if (_titleLabel) {
        _titleLabel.backgroundColor = _titleBackgroundColor;
    }
}

#pragma mark + Setter Animation
///=============================================================================
/// @name Setter Animation
///=============================================================================
- (void)setAnimationWhenAutoScroll:(BOOL)animationWhenAutoScroll {
    _animationWhenAutoScroll = animationWhenAutoScroll;
}

- (void)setAnimationWhenDragging:(BOOL)animationWhenDragging {
    _animationWhenDragging = animationWhenDragging;
}

- (void)setAnimationRandom:(BOOL)animationRandom {
    _animationRandom = animationRandom;
}

- (void)setAnimationTypes:(NSArray *)animationTypes {
    _animationTypes = [animationTypes copy];
}

#pragma mark - **************Methods**************
#pragma mark + Methods ScrollView
///=============================================================================
/// @name Methods ScrollView
///=============================================================================
- (void)reloadData {
    [self addImageViews];
    [self addTitleLabel];
    [self configScrollView];
    [self configPageCtrl];
}

- (void)addImageViews{
    if (_dataArray.count == 0) {
        return;
    }
    _circularly = _tempCircularly;//_circularly先恢复初值
    _circularly = (_dataArray.count == 1)?NO:_circularly;//若只有1张图片则不循环滚动
    [self removeLabelAndImageView];
    NSInteger imageCount = _circularly ? 3:_dataArray.count;
    for (NSInteger i = 0; i < imageCount; i++) {
        CGRect frame = [self getImageViewFrameWithIndex:i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
        //imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.userInteractionEnabled = _userCanTap;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)]];
        if (_circularly) {
            [self createThreeImgView:imageView index:i];
        }else {
            imageView.tag = kTagValue+i; // tag值
            [self configImageView:imageView imageInfo:_dataArray[i]];
            [_scrollView addSubview:imageView];
        }
    }
}

- (CGRect)getImageViewFrameWithIndex:(NSInteger)index {
    if (_scrollDirection == ZXScrollDirectionLeft||
        _scrollDirection == ZXScrollDirectionRight) {
        return CGRectMake(index*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    }else if (_scrollDirection == ZXScrollDirectionTop||
              _scrollDirection == ZXScrollDirectionBottom) {
        return CGRectMake(0, index*self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    }
    return CGRectZero;
}

- (void)configImageView:(UIImageView *)imageView imageInfo:(id)info {
    switch (_imageType) {
        case ZXImageTypeName: {
            if ([info isKindOfClass:[NSString class]]) {
                imageView.image = [UIImage imageNamed:info placeholder:_placeholder];
            }else {
                imageView.image = [UIImage imageNamed:_placeholder];
            }
            break;
        }
        case ZXImageTypePath: {
            if ([info isKindOfClass:[NSString class]]) {
                imageView.image = [UIImage imageWithContentsOfFile:info placeholder:_placeholder];
            }else {
                imageView.image = [UIImage imageNamed:_placeholder];
            }
            break;
        }
        case ZXImageTypeURL: {
            if ([info isKindOfClass:[NSString class]]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:info]
                             placeholderImage:[UIImage imageNamed:_placeholder]];
            }else {
                imageView.image = [UIImage imageNamed:_placeholder];
            }
            break;
        }
        case ZXImageTypeObject: {
            if ([info isKindOfClass:[UIImage class]]) {
                imageView.image = info;
            }else {
                imageView.image = [UIImage imageNamed:_placeholder];
            }
            break;
        }
        default: break;
    }
}

- (void)createThreeImgView:(UIImageView *)imageView index:(NSInteger)index {
    if (index == 0) {
        _lastImgView = imageView;
        [self configImageView:_lastImgView imageInfo:_dataArray[_dataArray.count-1]];
        [_scrollView addSubview:_lastImgView];
    }else if (index == 1) {
        _currentImgView = imageView;
        _currentImgView.tag = kTagValue+_currentIndex; // tag值
        [self configImageView:_currentImgView imageInfo:_dataArray[0]];
        [_scrollView addSubview:_currentImgView];
    }else if (index == 2) {
        _nextImgView = imageView;
        [self configImageView:_nextImgView imageInfo:_dataArray[1]];
        [_scrollView addSubview:_nextImgView];
    }
}

- (void)addTitleLabel {
    [self removeLabel];
    if (_titleArray.count > 0 && _titleArray.count == _dataArray.count) {
        if (_titleMode == ZXCycleViewTitleModeChange) { //只创建一个label
            [self addSubview:self.titleLabel];
        }else if (_titleMode == ZXCycleViewTitleModeScroll) {//每个图片创建一个label
            [self imageViewAddTitleLabel];
        }
    }
}

- (void)imageViewAddTitleLabel {
    NSInteger labelCount = _circularly ? 3:_titleArray.count;
    for (NSInteger i = 0; i < labelCount; i++) {
        UILabel *label = [UILabel labelWithFont:_titleFont
                                           text:nil
                                      textColor:_titleColor
                                  textAlignment:NSTextAlignmentLeft
                                  numberOfLines:1
                                  lineBreakMode:NSLineBreakByTruncatingTail
                                backgroundColor:_titleBackgroundColor
                      adjustsFontSizeToFitWidth:YES];
        label.frame = CGRectMake(10, self.bounds.size.height-30, self.bounds.size.width-20, 30);
        if (!_circularly) { //创建多个label
            UIImageView *imageView = [self viewWithTag:kTagValue+i];
            label.text = _titleArray[i];
            [imageView addSubview:label];
        }else { //创建3个label
            if (i == 0) {
                label.text = _titleArray[_titleArray.count-1];
                [_lastImgView addSubview:label];
            }else if (i == 1) {
                label.text = _titleArray[0];
                [_currentImgView addSubview:label];
            }else if (i == 2) {
                label.text = _titleArray[1];
                [_nextImgView addSubview:label];
            }
        }
    }
}

- (void)configScrollView {
    if (_scrollDirection == ZXScrollDirectionLeft||
        _scrollDirection == ZXScrollDirectionRight) {
        if (_circularly) {
            _scrollView.contentSize = CGSizeMake(self.bounds.size.width*3, self.bounds.size.height);
            _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        }else {
            _scrollView.contentSize = CGSizeMake(self.bounds.size.width*_dataArray.count, self.bounds.size.height);
            _scrollView.contentOffset = CGPointMake(0, 0);
        }
    }else if (_scrollDirection == ZXScrollDirectionTop||
              _scrollDirection == ZXScrollDirectionBottom) {
        if (_circularly) {
            _scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height*3);
            _scrollView.contentOffset = CGPointMake(0, self.bounds.size.height);
        }else {
            _scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height*_dataArray.count);
            _scrollView.contentOffset = CGPointMake(0, 0);
        }
    }
}

#pragma mark + Methods PageCtrl
///=============================================================================
/// @name Methods PageCtrl
///=============================================================================
- (void)addPageCtrlWithStyle:(ZXPageCtrlStyle)style {
    switch (style) {
        case ZXPageCtrlStyleNone: {
            [self addPageCtrlNone];
            break;
        }
        case ZXPageCtrlStyleDefault: {
            [self addPageCtrlDefault];
            break;
        }
        case ZXPageCtrlStyleCustom: {
            [self addPageCtrlCustom];
            break;
        }
        default:break;
    }
}

- (void)addPageCtrlNone {
    [self removePageControl];
}

- (void)addPageCtrlDefault {
    if (_dataArray.count > 1) {
        [self removePageControl];
        [self addSubview:self.pageCtrl];
    }
}

- (void)addPageCtrlCustom {
    if (_dataArray.count > 1) {
        [self removePageControl];
        DLog(@"PageCtrlCustom功能未实现");
    }
}

- (CGRect)getPageCtrlFrame:(UIPageControl *)pageCtrl {
    CGSize size = [pageCtrl sizeForNumberOfPages:_dataArray.count];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    switch (_pageCtrlAlignment) {
        case 0: {
            frame.origin.x = kPageCtrlMargin;
            frame.origin.y = self.bounds.size.height-size.height;
            break;
        }
        case 1: {
            frame.origin.x = (self.bounds.size.width-size.width)/2.0;
            frame.origin.y = self.bounds.size.height-size.height;
            break;
        }
        case 2: {
            frame.origin.x = self.bounds.size.width-size.width-kPageCtrlMargin;
            frame.origin.y = self.bounds.size.height-size.height;
            break;
        }
        case 3: {
            frame.origin.y = (self.bounds.size.height-size.height)/2.0;
            pageCtrl.transform = CGAffineTransformMakeRotation(90*M_PI/180);
            break;
        }
        case 4: {
            frame.origin.x = (self.bounds.size.width-size.width)/2.0;
            frame.origin.y = (self.bounds.size.height-size.height)/2.0;
            pageCtrl.transform = CGAffineTransformMakeRotation(90*M_PI/180);
            break;
        }
        case 5: {
            frame.origin.x = self.bounds.size.width-size.width;
            frame.origin.y = (self.bounds.size.height-size.height)/2.0;
            pageCtrl.transform = CGAffineTransformMakeRotation(90*M_PI/180);
            break;
        }
        default:
            break;
    }
    return frame;
}

- (void)configPageCtrl {
    if (!_pageCtrl) {//在数据源为空时创建pageCtrl将不会成功,所以在reloadData时应该再判断。
        [self addPageCtrlWithStyle:_pageCtrlStyle];
    }else if (_showPageCtrl) {
        _pageCtrl.frame = [self getPageCtrlFrame:_pageCtrl];
        _pageCtrl.numberOfPages = _dataArray.count;
        _pageCtrl.currentPage = 0;
    }
}

#pragma mark + Methods Timer
///=============================================================================
/// @name Methods Timer
///=============================================================================
- (void)timerSwitch {
    if (_circularly && _timeInterval > 0 && _dataArray.count >= 2) {
        [self startTimer];
    }else {
        [self stopTimer];
    }
}

- (void)startTimer {
    if (_timer && _timer.timeInterval == _timeInterval) {
        return;
    }else if (_timer){
        [self stopTimer];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval
                                              target:self
                                            selector:@selector(autoScroll)
                                            userInfo:nil
                                             repeats:YES];
    //[[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark + Methods Animation
///=============================================================================
/// @name Methods Animation
///=============================================================================
- (void)addAnimation {
    [self removeAnimation];
    if (_animationTypes.count > 0) {
        if (_animationRandom) {
            [self addAnimationWithAnimationType:[_animationTypes randomObject]];
        }else {
            if (_flag == _animationTypes.count) {
                _flag = 0;
            }
            [self addAnimationWithAnimationType:_animationTypes[_flag++]];
        }
    }
}

- (void)addAnimationWithAnimationType:(NSString *)animationType {
    CATransition *transition = [[CATransition alloc]init];
    transition.type = animationType;
    
    if (_scrollView.isTracking) { //将要手动拖拽
        transition.duration = kDuration;
        
    }else { //自动滚动
        transition.duration = (_timeInterval-kDuration > 0)?(_timeInterval-kDuration):_timeInterval;
        switch (_scrollDirection) {
            case ZXScrollDirectionLeft: {
                transition.subtype = kCATransitionFromRight;
                break;
            }
            case ZXScrollDirectionRight: {
                transition.subtype = kCATransitionFromLeft;
                break;
            }
            case ZXScrollDirectionTop: {
                transition.subtype = kCATransitionFromTop;
                break;
            }
            case ZXScrollDirectionBottom: {
                transition.subtype = kCATransitionFromBottom;
                break;
            }
            default:break;
        }
    }
    [_scrollView.layer addAnimation:transition forKey:animationType];
}

#pragma mark + Methods Offset
///=============================================================================
/// @name Methods Offset
///=============================================================================
- (void)reloadDataCyclic {
    if (_dataArray.count == 0) return;
    CGPoint offset = _scrollView.contentOffset;
    if (_scrollDirection == ZXScrollDirectionLeft||
        _scrollDirection == ZXScrollDirectionRight) {
        if (offset.x > self.bounds.size.width) {
            _currentIndex = (_currentIndex+1)%_dataArray.count;
        }else if (offset.x < self.bounds.size.width) {
            _currentIndex = (_currentIndex-1+_dataArray.count)%_dataArray.count;
        }
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0); //更新 contentOffset
    }else if (_scrollDirection == ZXScrollDirectionTop||
              _scrollDirection == ZXScrollDirectionBottom) {
        if (offset.y > self.bounds.size.height) {
            _currentIndex = (_currentIndex+1)%_dataArray.count;
        }else if (offset.y < self.bounds.size.height) {
            _currentIndex = (_currentIndex-1+_dataArray.count)%_dataArray.count;
        }
        _scrollView.contentOffset = CGPointMake(0, self.bounds.size.height);//更新 contentOffset
    }
    _currentImgView.tag = kTagValue+_currentIndex; //更新 tag 值
    NSInteger lastIndex = (_currentIndex-1+_dataArray.count)%_dataArray.count;
    NSInteger nextIndex = (_currentIndex+1)%_dataArray.count;
    [self configImageView:_currentImgView imageInfo:_dataArray[_currentIndex]];//更新 image
    [self configImageView:_lastImgView imageInfo:_dataArray[lastIndex]];
    [self configImageView:_nextImgView imageInfo:_dataArray[nextIndex]];
    if (_pageCtrl) {
        _pageCtrl.currentPage = _currentIndex; //更新 currentPage
    }
    if (_titleMode == ZXCycleViewTitleModeChange) {
        if (_titleLabel && _titleArray.count > _currentIndex) {
            _titleLabel.text = _titleArray[_currentIndex]; //更新 title
        }
    }else if (_titleMode == ZXCycleViewTitleModeScroll) { //更新 title
        ((UILabel *)_lastImgView.subviews.firstObject).text = _titleArray[lastIndex];
        ((UILabel *)_currentImgView.subviews.firstObject).text = _titleArray[_currentIndex];
        ((UILabel *)_nextImgView.subviews.firstObject).text = _titleArray[nextIndex];
    }
}

- (void)reloadDataNoncyclic {
    NSInteger index = 0;
    if (_scrollDirection == ZXScrollDirectionLeft||
        _scrollDirection == ZXScrollDirectionRight) {
        index = _scrollView.contentOffset.x/self.bounds.size.width;
    }else if (_scrollDirection == ZXScrollDirectionTop||
              _scrollDirection == ZXScrollDirectionBottom) {
        index = _scrollView.contentOffset.y/self.bounds.size.height;
    }
    if (_pageCtrl && _showPageCtrl) {
        _pageCtrl.currentPage = index; // 更新 currentPage
    }
    if (_titleMode == ZXCycleViewTitleModeChange) {
        if (_titleLabel && _titleArray.count > index) {
            _titleLabel.text = _titleArray[index]; //更新 title
        }
    }
}

#pragma mark + Methods Delegate
///=============================================================================
/// @name UIScrollViewDelegate
///=============================================================================
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
    if (_animationWhenDragging) {
        [self addAnimation];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self timerSwitch];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {//拖拽滚动
    if (_circularly) {
        [self reloadDataCyclic];
    }else {
        [self reloadDataNoncyclic];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {//自动滚动
    [self reloadDataCyclic];
}

#pragma mark + Methods Action
///=============================================================================
/// @name Methods Action
///=============================================================================
- (void)autoScroll {
    if (_animationWhenAutoScroll) {
        [self addAnimation];
    }
    CGPoint offset = _scrollView.contentOffset;
    switch (_scrollDirection) {
        case ZXScrollDirectionLeft: {
            offset.x += self.bounds.size.width;
            break;
        }
        case ZXScrollDirectionRight: {
            offset.x -= self.bounds.size.width;
            break;
        }
        case ZXScrollDirectionTop: {
            offset.y += self.bounds.size.height;
            break;
        }
        case ZXScrollDirectionBottom: {
            offset.y -= self.bounds.size.height;
            break;
        }
        default:break;
    }
    [_scrollView setContentOffset:offset animated:YES];
}

- (void)imageViewTap:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    if (_selectBlock) {
        __weak __typeof(self)weakSelf = self;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        _selectBlock(strongSelf,imageView.tag-kTagValue);
    }else if (_delegate && [_delegate respondsToSelector:@selector(cycleView:didSelectItemAtIndex:)]) {
        [_delegate cycleView:self didSelectItemAtIndex:imageView.tag-kTagValue];
    }
}

#pragma mark + Methods Enumerator Block
///=============================================================================
/// @name Methods Enumerator Block
///=============================================================================
- (void)handleImageView:(void (^)(UIImageView *imgView))block {
    for (UIImageView *imageView in _scrollView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            block(imageView);
        }
    }
}

- (void)handleLabel:(void (^)(UILabel *label))block {
    for (UIImageView *imageView in _scrollView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            for (UILabel *label in imageView.subviews) {
                if ([label isKindOfClass:[UILabel class]]) {
                    block(label);
                }
            }
        }
    }
}

- (void)handleImageView:(void (^)(UIImageView *imgView))block1 label:(void (^)(UILabel *label))block2 {
    for (UIImageView *imageView in _scrollView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            for (UILabel *label in imageView.subviews) {
                if ([label isKindOfClass:[UILabel class]]) {
                    block2(label);
                }
            }
            block1(imageView);
        }
    }
}

#pragma mark + Methods Dealloc
///=============================================================================
/// @name Methods Dealloc
///=============================================================================
- (void)removeAnimation {
    [_scrollView.layer removeAllAnimations];
}

- (void)removePageControl {
    if (_pageCtrl) {
        [_pageCtrl removeFromSuperview];
        _pageCtrl = nil;
    }
}

- (void)removeLabel {
    [self handleLabel:^(UILabel *label) {
        [label removeFromSuperview];
        label = nil;
    }];
    if (_titleLabel) {
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
}

- (void)removeLabelAndImageView {
    [self handleImageView:^(UIImageView *imageView) {
        [imageView removeFromSuperview];
        imageView = nil;
    } label:^(UILabel *label) {
        [label removeFromSuperview];
        label = nil;
    }];
    if (_titleLabel) {
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
}

- (void)removeScrollView {
    if (_scrollView) {
        [_scrollView removeFromSuperview];
        _scrollView.delegate = nil;
        _scrollView = nil;
    }
}

- (void)dealloc {
    [self stopTimer];
    [self removeAnimation];
    [self removePageControl];
    [self removeLabelAndImageView];
    [self removeScrollView];
    [self initialization];
}

@end
