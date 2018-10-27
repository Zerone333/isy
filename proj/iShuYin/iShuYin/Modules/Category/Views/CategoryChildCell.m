//
//  CategoryChildCell.m
//  iShuYin
//
//  Created by Apple on 2017/8/10.
//  Copyright © 2016年 angxun. All rights reserved.
//

#import "CategoryChildCell.h"
#import "CategoryModel.h"

@interface CategoryChildCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation CategoryChildCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.borderColor = kColorValue(0x666666).CGColor;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 2.f;
}

- (void)setModel:(CategoryModel *)model {
    _model = model;
    _nameLabel.text = model.cat_name;
}

@end
