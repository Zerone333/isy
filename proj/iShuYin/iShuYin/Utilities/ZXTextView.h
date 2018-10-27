//
//  ZXTextView.h
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXTextView : UITextView

@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIFont   *placeholderFont;
@property (nonatomic, strong) UIColor  *placeholderColor;
@property (nonatomic, readonly, strong) UITextView *placeView;

@end
