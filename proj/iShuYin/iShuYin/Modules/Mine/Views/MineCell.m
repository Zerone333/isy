//
//  MineCell.m
//  iShuYin
//
//  Created by Apple on 2017/9/6.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "MineCell.h"

@interface MineCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation MineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    _imgView.image = [UIImage imageNamed:dict[@"image"]];
    _titleLabel.text = dict[@"title"];
}

@end
