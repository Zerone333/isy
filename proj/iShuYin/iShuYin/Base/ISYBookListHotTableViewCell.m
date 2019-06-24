//
//  ISYBookListHotTableViewCell.m
//  iShuYin
//
//  Created by ND on 2018/13/10.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYBookListHotTableViewCell.h"


@interface ISYBookListHotTableViewCell ()
@property (nonatomic, strong) UIView *categryBgView;
@property (nonatomic, strong) UILabel *categryLabel;
@property (nonatomic, strong) UIImageView *statuImage;
@property (nonatomic, strong) UILabel *statuLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *timesLabel;
@property (nonatomic, strong) UIImageView *timesIcon;
@property (nonatomic, strong) UILabel *chaperCountLabel;
@property (nonatomic, strong) UIImageView *chaperImage;
@end

@implementation ISYBookListHotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.statuImage];
        [self.contentView addSubview:self.statuLabel];
        [self.contentView addSubview:self.chaperImage];
        [self.contentView addSubview:self.chaperCountLabel];
        
        [self.contentView addSubview:self.categryBgView];
        [self.contentView addSubview:self.categryLabel];
        
        [self.contentView addSubview:self.desLabel];
        [self.contentView addSubview:self.timesLabel];
        [self.contentView addSubview:self.timesIcon];
        
        [self.categryBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.thumImageView);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(18);
        }];
        [self.categryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.categryBgView);
        }];
        
        [self.statuImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.thumImageView);
            make.right.equalTo(self.contentView).mas_offset(-12);
        }];
        
        [self.statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.thumImageView);
            make.right.equalTo(self.contentView).mas_offset(-12);
        }];
        
        [self.chaperImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.thumImageView);
            make.left.equalTo(self.nameLabel);
        }];
        
        [self.chaperCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.chaperImage.mas_right).mas_offset(4);
            make.centerY.equalTo(self.chaperImage);
        }];
        
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).mas_offset(4);
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.contentView).mas_offset(-12);
        }];
        
        [self.timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-12);
            make.centerY.equalTo(self.chaperImage);
        }];
        
        [self.timesIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.timesLabel.mas_left).mas_offset(-4);
            make.centerY.equalTo(self.chaperImage);
        }];
    }
    return self;
}

+ (NSString *)cellID {
    return @"ISYBookListHotTableViewCellID";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

//作者作品更多
- (void)setModel:(HomeBookModel *)model isAuthorMore:(BOOL)isAuthorMore {
    [super setModel:model];
    self.model = model;
    if (isAuthorMore) {
        self.categryBgView.hidden = YES;
        self.categryLabel.hidden = YES;
        self.chaperCountLabel.text = [NSString stringWithFormat:@"%@ | %@", model.director, model.actor];
        self.chaperImage.image = [UIImage imageNamed:@"播报icon"];
        
        NSString *timeString;
        NSInteger value = model.click_count.integerValue;
        if (value >= 10000) {
            timeString = [NSString stringWithFormat:@"%ld万 次", value/ 10000];
        } else {
            timeString = [NSString stringWithFormat:@"%ld次", (long)value];
        }
        self.timesLabel.text = timeString;
    } else {
       
    }
}

- (void)setModel:(HomeBookModel *)model type:(NSString *)type {
    self.model = model;
    if ([type isEqualToString:@"小说"]) {
        self.timesLabel.hidden = YES;
        self.timesIcon.hidden = YES;
        self.chaperCountLabel.text = [NSString stringWithFormat:@"%@ | %@", model.director, model.actor];
        self.chaperImage.image = [UIImage imageNamed:@"播报icon"];
        
        self.statuImage.hidden = YES;
        self.statuLabel.hidden = YES;
    } else if ([type isEqualToString:@"娱乐"]) {
        self.timesLabel.hidden = YES;
        self.timesIcon.hidden = YES;
        
        NSString *timeString;
        NSInteger value = model.click_count.integerValue;
        if (value >= 10000) {
            timeString = [NSString stringWithFormat:@"%ld万 次", value/ 10000];
        } else {
            timeString = [NSString stringWithFormat:@"%ld次", (long)value];
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.add_time.integerValue];
        NSString *updateTime = [formatter stringFromDate:date];
        
        self.desLabel.text = [NSString stringWithFormat:@"更新 %@", updateTime ];
        self.chaperCountLabel.text = timeString;
        self.chaperImage.image = [UIImage imageNamed:@"播放次数"];
        self.statuImage.hidden = YES;
        self.statuLabel.hidden = YES;
    } else {
        self.timesLabel.hidden = NO;
        self.timesIcon.hidden = NO;
        self.chaperImage.image = [UIImage imageNamed:@"home_chaper"];
    }
}

- (void)setModel:(HomeBookModel *)model {
    [super setModel:model];
    self.chaperCountLabel.text = [NSString stringWithFormat:@"%@章节", model.jishu?:@"0"];
    if ([model.status isEqualToString:@"完结"]) {
        self.statuImage.hidden = NO;
        self.statuLabel.hidden = YES;
    } else {
        self.statuImage.hidden = YES;
        self.statuLabel.hidden = NO;
    }
    
    self.timesLabel.text = [NSString stringWithFormat:@"%@次", model.click_count?:@"0"];
    if (model.cat_name) {
        self.categryLabel.text = model.cat_name;
        self.categryBgView.hidden = NO;
    } else {
        self.categryBgView.hidden = YES;
    }
    self.desLabel.text = model.descriptionString;
}

#pragma mark -getter
- (UIImageView *)statuImage {
    if (!_statuImage) {
        _statuImage = [[UIImageView alloc] init];
        [_statuImage setImage:[UIImage imageNamed:@"完结标签"]];
    }
    return _statuImage;
}

- (UILabel *)statuLabel {
    if (!_statuLabel) {
        _statuLabel = [[UILabel alloc] init];
        _statuLabel.text = @"连载中...";
        _statuLabel.font =[UIFont systemFontOfSize:13];
        _statuLabel.textColor = kColorValue(0x666666);
    }
    return _statuLabel;
}

- (UILabel *)chaperCountLabel {
    if (!_chaperCountLabel) {
        _chaperCountLabel = [[UILabel alloc] init];
        _chaperCountLabel.font =[UIFont systemFontOfSize:13];
        _chaperCountLabel.textColor = kColorValue(0x666666);
    }
    return _chaperCountLabel;
}

- (UIImageView *)chaperImage {
    if (!_chaperImage) {
        _chaperImage = [[UIImageView alloc] init];
        _chaperImage.image = [UIImage imageNamed:@"home_chaper"];
    }
    return _chaperImage;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.numberOfLines = 2;
        _desLabel.font =[UIFont systemFontOfSize:13];
        _desLabel.textColor = kColorValue(0x666666);
    }
    return _desLabel;
}

- (UILabel *)timesLabel {
    if (!_timesLabel) {
        _timesLabel = [[UILabel alloc] init];
        _timesLabel.font =[UIFont systemFontOfSize:13];
        _timesLabel.textColor = kColorValue(0x666666);
    }
    return _timesLabel;
}

- (UIImageView *)timesIcon {
    if (!_timesIcon) {
        _timesIcon = [[UIImageView alloc] init];
        _timesIcon.image = [UIImage imageNamed:@"播放次数t"];
    }
    return _timesIcon;
}

- (UILabel *)categryLabel {
    if (!_categryLabel) {
        _categryLabel = [[UILabel alloc] init];
        _categryLabel.textColor = [UIColor whiteColor];
        _categryLabel.font = [UIFont systemFontOfSize:13];
    }
    return _categryLabel;
}


- (UIView *)categryBgView {
    if (!_categryBgView) {
        _categryBgView = [[UIView alloc] init];
        _categryBgView.backgroundColor = [UIColor redColor];
    }
    return _categryBgView;
}


@end
