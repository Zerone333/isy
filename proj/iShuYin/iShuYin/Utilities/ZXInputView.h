//
//  ZXInputView.h
//  JWXUserClient
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 angxun. All rights reserved.
//

#import "ZXTextView.h"

typedef void(^ChangeHeightBlock)(CGFloat height);

@interface ZXInputView : ZXTextView

@property (nonatomic, assign) NSUInteger maxNumberOfLines;//最大行数(需要先设置font。如果行间距有要求，需要先设置lineSpace）

@property (nonatomic, strong) ChangeHeightBlock changeHeightBlock;

@end
