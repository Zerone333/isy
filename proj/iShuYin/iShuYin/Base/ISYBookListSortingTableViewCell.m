//
//  ISYBookListSortingTableViewCell.m
//  iShuYin
//
//  Created by ND on 2018/11/13.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYBookListSortingTableViewCell.h"


@interface ISYBookListSortingTableViewCell ()
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIView *categryBgView;
@property (nonatomic, strong) UILabel *categryLabel;
@property (nonatomic, strong) UIImageView *statuImage;
@property (nonatomic, strong) UILabel *statuLabel;
@property (nonatomic, strong) UILabel *desLabel;
@end

@implementation ISYBookListSortingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.indexLabel];
        [self.contentView addSubview:self.statuImage];
        [self.contentView addSubview:self.statuLabel];
        
        [self.contentView addSubview:self.categryBgView];
        [self.contentView addSubview:self.categryLabel];
        [self.contentView addSubview:self.desLabel];
        
        [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(18, 18));
            make.left.equalTo(self.contentView).mas_offset(12);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.thumImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(110 / kCoverProportion, 110));
            make.top.equalTo(self.contentView).mas_offset(12);
            make.left.equalTo(self.indexLabel.mas_right).mas_offset(12);
        }];
        
        [self.categryBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(self.thumImageView);
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
        
        
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).mas_offset(4);
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.contentView).mas_offset(-12);
            make.bottom.lessThanOrEqualTo(self.contentView).mas_offset(-12);
        }];
    }
    return self;
}

+ (NSString *)cellID {
    return @"ISYBookListSortingTableViewCellID";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setModel:(HomeBookModel *)model index:(NSInteger)index {
    [super setModel:model];  if ([model.status isEqualToString:@"完结"]) {
        self.statuImage.hidden = NO;
        self.statuLabel.hidden = YES;
    } else {
        self.statuImage.hidden = YES;
        self.statuLabel.hidden = NO;
        self.statuLabel.text = @"连载中";
    }
    
    self.categryLabel.text = model.cat_name;
    self.desLabel.text = model.descriptionString;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld", index + 1];
    if (index <= 2) {
        self.indexLabel.backgroundColor = [UIColor redColor];
    } else {
        self.indexLabel.backgroundColor = kColorValue(0x666666);
    }
}

#pragma mark -getter
- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont systemFontOfSize:13];
        _indexLabel.layer.masksToBounds = YES;
        _indexLabel.layer.cornerRadius = 9;
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.textColor = [UIColor whiteColor];
    }
    return _indexLabel;
}
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
        _statuLabel.textColor = kColorValue(0xe82123);
        _statuLabel.font = [UIFont systemFontOfSize:13];
    }
    return _statuLabel;
}


- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.numberOfLines = 3;
        _desLabel.textColor = kColorValue(0x333333);
        _desLabel.font =[UIFont systemFontOfSize:13];
    }
    return _desLabel;
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
