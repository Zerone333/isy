//
//  BookDetailInfoView.m
//  iShuYin
//
//  Created by Apple on 2017/8/14.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookDetailInfoView.h"
#import "BookDetailModel.h"

@interface BookDetailInfoView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation BookDetailInfoView

- (void)setModel:(BookDetailModel *)model {
    _model = model;
    if ([model.thumb containsString:kPrefixImageDefault]) {
        [_imgView sd_setImageWithURL:[model.thumb url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }else {
        [_imgView sd_setImageWithURL:[[kPrefixImageDefault stringByAppendingString:model.thumb] url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }
    _titleLabel.text = model.title;
    _authorLabel.text = [NSString stringWithFormat:@"作者：%@",model.actor];
    _directorLabel.text = [NSString stringWithFormat:@"播音：%@",model.director];
    _statusLabel.text = [NSString stringWithFormat:@"状态：%@",model.status];
    if (model.is_collected.boolValue) {
        [_likeBtn setImage:[UIImage imageNamed:@"detail_like_sel"] forState:UIControlStateNormal];
    }else {
        [_likeBtn setImage:[UIImage imageNamed:@"detail_like_nor"] forState:UIControlStateNormal];
    }
}

- (IBAction)likeBtnClick:(id)sender {
    !_collectionBlock?:_collectionBlock();
}

- (IBAction)shareBtnClick:(id)sender {
    !_shareBlock?:_shareBlock();
}

@end
