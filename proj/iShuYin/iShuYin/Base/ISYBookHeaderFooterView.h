//
//  ISYBookHeaderFooterView.h
//  iShuYin
//
//  Created by ND on 2018/10/27.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ISYBookHeaderFooterViewMoreBlock)(void);
@interface ISYBookHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *catogryTitleLabel;
@property (nonatomic, copy) ISYBookHeaderFooterViewMoreBlock moreBlock;
@end
