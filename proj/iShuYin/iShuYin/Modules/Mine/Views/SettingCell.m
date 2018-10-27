//
//  SettingCell.m
//  iShuYin
//
//  Created by Apple on 2017/10/18.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation SettingCell

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
    _titleLabel.text = dict[@"title"];
    _infoLabel.text = dict[@"info"];
    _imgView.hidden = [dict[@"hidden"] boolValue];
}

@end
