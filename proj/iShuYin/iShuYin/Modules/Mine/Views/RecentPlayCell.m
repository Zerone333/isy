//
//  RecentPlayCell.m
//  iShuYin
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "RecentPlayCell.h"
#import "BookDetailModel.h"

@interface RecentPlayCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation RecentPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
}

@end
