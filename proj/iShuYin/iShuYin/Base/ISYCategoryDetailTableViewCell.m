//
//  ISYCategoryDetailTableViewCell.m
//  iShuYin
//
//  Created by ND on 2018/11/11.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYCategoryDetailTableViewCell.h"

@interface ISYCategoryDetailTableViewCell()

@property (nonatomic, strong) UIImageView *statuImage;
@property (nonatomic, strong) UILabel *statuLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *timesLabel;
@property (nonatomic, strong) UIImageView *timesIcon;
@property (nonatomic, strong) UILabel *chaperCountLabel;
@property (nonatomic, strong) UIImageView *chaperImage;
@end
@implementation ISYCategoryDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellID {
    return @"ISYCategoryDetailTableViewCellID";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.statuImage];
        [self.contentView addSubview:self.statuLabel];
        [self.contentView addSubview:self.chaperImage];
        [self.contentView addSubview:self.chaperCountLabel];
        
         [self.contentView addSubview:self.desLabel];
        [self.contentView addSubview:self.timesLabel];
        [self.contentView addSubview:self.timesIcon];
        
        
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

- (void)setModel:(HomeBookModel *)model {
    [super setModel:model];
    self.chaperCountLabel.text = model.director;
    if ([model.status isEqualToString:@"完结"]) {
        self.statuImage.hidden = NO;
        self.statuLabel.hidden = YES;
    } else {
        self.statuImage.hidden = YES;
        self.statuLabel.hidden = NO;
    }
    self.desLabel.text = model.descriptionString;
    
    NSString *timeString;
    NSInteger value = model.click_count.integerValue;
    if (value >= 10000) {
        timeString = [NSString stringWithFormat:@"%ld万 次", value/ 10000];
    } else {
        timeString = [NSString stringWithFormat:@"%ld次", (long)value];
    }
    self.timesLabel.text = timeString;
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
@end
