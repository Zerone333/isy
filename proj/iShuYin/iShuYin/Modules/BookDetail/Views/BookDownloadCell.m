//
//  BookDownloadCell.m
//  iShuYin
//
//  Created by Apple on 2017/8/22.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookDownloadCell.h"
#import "BookDetailModel.h"

@interface BookDownloadCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation BookDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter
- (void)setChapterModel:(BookChapterModel *)chapterModel {
    _chapterModel = chapterModel;
    _titleLabel.text = chapterModel.l_title;
}

@end
