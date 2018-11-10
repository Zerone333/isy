//
//  ISYBookRefreshFooterView.h
//  iShuYin
//
//  Created by ND on 2018/11/10.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ISYBookFooterViewRefreshBlock)(void);
@interface ISYBookRefreshFooterView : UITableViewHeaderFooterView
@property (nonatomic, copy) ISYBookFooterViewRefreshBlock refreshBlock;
+(CGFloat)height;
@end
