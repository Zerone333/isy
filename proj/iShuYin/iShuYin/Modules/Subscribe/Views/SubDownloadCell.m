//
//  SubDownloadCell.m
//  iShuYin
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "SubDownloadCell.h"
#import "BookDetailModel.h"

@interface SubDownloadCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@end

@implementation SubDownloadCell

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
    _actorLabel.text = [NSString stringWithFormat:@"作者：%@",detailModel.actor];
    
    if (detailModel.download_count > 0) {
        _countLabel.hidden = NO;
        _countLabel.text = [NSString stringWithFormat:@"下载数%li",detailModel.download_count];
    }else if (detailModel.download_chapter_idArray.count > 0) {
        _countLabel.hidden = NO;
        _countLabel.text = [NSString stringWithFormat:@"下载数：%li",detailModel.download_chapter_idArray.count];
    }else {
        _countLabel.hidden = YES;
    }
}

- (IBAction)deleteBtnClick:(id)sender {
    !_deleteBlock?:_deleteBlock(_detailModel);
}

@end
