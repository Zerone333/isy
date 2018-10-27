//
//  SharePlatformView.h
//  iShuYin
//
//  Created by Apple on 2017/8/27.
//  Copyright © 2017年 angxun. All rights reserved.
//

#import "SharePlatformView.h"

@interface SharePlatformView ()
@property (weak, nonatomic) IBOutlet UIView *weixinView;
@property (weak, nonatomic) IBOutlet UIView *friendsView;
@property (weak, nonatomic) IBOutlet UIView *qzoneView;
@property (weak, nonatomic) IBOutlet UIView *qqView;
@end

@implementation SharePlatformView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_weixinView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewTap:)]];
    [_friendsView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewTap:)]];
    [_qzoneView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewTap:)]];
    [_qqView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewTap:)]];
}

- (void)shareViewTap:(UITapGestureRecognizer *)tap {
    !_shareBlock?:_shareBlock(tap.view.tag-400);
    !_dismissBlock?:_dismissBlock();
}

- (IBAction)cancelBtnClick:(id)sender {
    !_dismissBlock?:_dismissBlock();
}

@end
