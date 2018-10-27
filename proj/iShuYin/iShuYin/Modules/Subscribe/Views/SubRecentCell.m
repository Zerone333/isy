//
//  SubRecentCell.m
//  iShuYin
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "SubRecentCell.h"
#import "BookDetailModel.h"

@interface SubRecentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation SubRecentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailModel:(BookDetailModel *)detailModel {
    _detailModel = detailModel;
    if ([detailModel.thumb containsString:kPrefixImageDefault]) {
        [_imgView sd_setImageWithURL:[detailModel.thumb url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }else {
        [_imgView sd_setImageWithURL:[[kPrefixImageDefault stringByAppendingString:detailModel.thumb] url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }
    _titleLabel.text = detailModel.title;
    _timeLabel.text = [NSString stringWithFormat:@"收听到第%li集",detailModel.recent_chapter.l_id.integerValue];
}

@end
