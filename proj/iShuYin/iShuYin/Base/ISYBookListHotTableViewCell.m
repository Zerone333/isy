//
//  ISYBookListHotTableViewCell.m
//  iShuYin
//
//  Created by ND on 2018/11/10.
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

- (void)setModel:(HomeBookModel *)model {
    [super setModel:model];
    self.chaperCountLabel.text = [NSString stringWithFormat:@"%@章节", model.jishu];
    if ([model.status isEqualToString:@"完结"]) {
        self.statuImage.hidden = NO;
        self.statuLabel.hidden = YES;
    } else {
        self.statuImage.hidden = YES;
        self.statuLabel.hidden = NO;
    }
    
    self.timesLabel.text = [NSString stringWithFormat:@"%@次", model.click_count];
    self.categryLabel.text = model.cat_name;
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
    }
    return _statuLabel;
}

- (UILabel *)chaperCountLabel {
    if (!_chaperCountLabel) {
        _chaperCountLabel = [[UILabel alloc] init];
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
    }
    return _desLabel;
}

- (UILabel *)timesLabel {
    if (!_timesLabel) {
        _timesLabel = [[UILabel alloc] init];
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
        _categryLabel.font = [UIFont systemFontOfSize:11];
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
