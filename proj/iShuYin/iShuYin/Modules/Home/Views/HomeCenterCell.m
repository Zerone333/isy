//
//  HomeCenterCell.m
//  iShuYin
//
//  Created by Apple on 2017/8/6.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "HomeCenterCell.h"
#import "HomeBookModel.h"

@interface HomeCenterCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation HomeCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBookModel:(HomeBookModel *)bookModel {
    _bookModel = bookModel;
    if ([bookModel.thumb containsString:kPrefixImageDefault]) {
        [_imgView sd_setImageWithURL:[bookModel.thumb url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }else {
        [_imgView sd_setImageWithURL:[[kPrefixImageDefault stringByAppendingString:bookModel.thumb] url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }
    _titleLabel.text = bookModel.title;
}

@end
