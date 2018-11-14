//
//  ISYSettingTableViewCell.m
//  iShuYin
//
//  Created by ND on 2018/11/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYSettingTableViewCell.h"

@interface ISYSettingTableViewCell ()
@property (nonatomic, strong) UISwitch *switchBtn;
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation ISYSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.switchBtn];
        [self.contentView addSubview:self.infoLabel];
        
        [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).mas_offset(-12);
        }];
        
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).mas_offset(-12);
        }];
    }
    return self;
}


+(NSString *)cellId {
    return @"ISYSettingTableViewCellid";
}

- (UISwitch *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc] init];
        _switchBtn.onTintColor = [UIColor redColor];
        [_switchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel =[[UILabel alloc] init];
    }
    return _infoLabel;
}

- (void)setModel:(ISYSettingModel *)model {
    _model = model;
    [self.imageView setImage:[UIImage imageNamed:model.imageName]];
    self.textLabel.text = model.title;
    self.switchBtn.hidden = model.settingType != ISYSettingModelSettingType_Swich;
    if (model.settingType == ISYSettingModelSettingType_info) {
        self.infoLabel.text = model.valueString;
        self.infoLabel.hidden = NO;
    } else {
        self.infoLabel.text = model.valueString;
        [self.switchBtn setOn:[model.valueString isEqualToString:@"1"]];
        self.infoLabel.hidden = YES;
    }
}

- (void)switchBtnClick:(UISwitch *)switchbtn {
    if (self.model.switchValueChagneBlock != nil) {
        self.model.switchValueChagneBlock(switchbtn.isOn);
    }
}
@end
