//
//  HomeListCell.m
//  iShuYin
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "HomeListCell.h"
#import "HomeBookModel.h"

@interface HomeListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation HomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBookModel:(HomeBookModel *)bookModel {
    _bookModel = bookModel;
    if ([bookModel.thumb containsString:kPrefixImageDefault]) {
        [_imgView sd_setImageWithURL:[bookModel.thumb url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }else {
        [_imgView sd_setImageWithURL:[[kPrefixImageDefault stringByAppendingString:bookModel.thumb] url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }
    _titleLabel.text = bookModel.title;
    _authorLabel.text = [NSString stringWithFormat:@"作者：%@",bookModel.actor];
    _directorLabel.text = [NSString stringWithFormat:@"播音：%@",bookModel.director];
    _statusLabel.text = [NSString stringWithFormat:@"状态：%@",bookModel.status];
}

@end
