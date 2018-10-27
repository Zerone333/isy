//
//  BookChapterIntervalView.h
//  iShuYin
//
//  Created by 李艺真 on 2018/10/21.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookChapterIntervalView : UIView
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) void (^itemBlock)(NSInteger index);
- (void)updatesCrollDirection:(UICollectionViewScrollDirection)type;
@end
