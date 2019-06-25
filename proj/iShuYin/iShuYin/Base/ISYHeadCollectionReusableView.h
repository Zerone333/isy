//
//  ISYHeadCollectionReusableView.h
//  iShuYin
//
//  Created by ND on 2018/11/13.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ISYHeadCollectionReusableViewClearHistoryCompletion)();

@interface ISYHeadCollectionReusableView : UICollectionReusableView
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong) UIButton *clearHistoryBtn;
@property (nonatomic, copy) ISYHeadCollectionReusableViewClearHistoryCompletion completion;
@end
