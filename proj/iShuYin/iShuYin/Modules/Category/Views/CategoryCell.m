//
//  CategoryCell.m
//  iShuYin
//
//  Created by Apple on 2017/8/10.
//  Copyright © 2016年 angxun. All rights reserved.
//

#import "CategoryCell.h"
#import "CategoryModel.h"

@interface CategoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (selected) {
        _nameLabel.font = kFontSystem(14);
        _nameLabel.textColor = kMainTone;
        self.contentView.backgroundColor = kColorRGB(247, 247, 247);
    }else {
        _nameLabel.font = kFontSystem(13);
        _nameLabel.textColor = kColorValue(0x8f8f8f);
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setModel:(CategoryModel *)model {
    _model = model;
    _nameLabel.text = model.cat_name;
}

@end
