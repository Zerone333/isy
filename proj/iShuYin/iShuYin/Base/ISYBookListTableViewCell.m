//
//  ISYBookListTableViewCell.m
//  iShuYin
//
//  Created by 李艺真 on 2018/10/14.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYBookListTableViewCell.h"

@interface ISYBookListTableViewCell ()
@end

@implementation ISYBookListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:true reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return  self;
}

#pragma mark - public
+ (CGFloat)cellHeight {
    return 110 + 12 * 2;
}

+ (NSString *)cellID {
    return @"ISYBookListTableViewCellID";
}
#pragma mark - private

- (void)setupUI {
    [self.contentView addSubview:self.thumImageView];
    [self.contentView addSubview:self.nameLabel];
    
    [self.thumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110 / kCoverProportion, 110));
        make.top.left.equalTo(self.contentView).mas_offset(12);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumImageView.mas_right).mas_offset(8);
        make.top.equalTo(self.thumImageView);
    }];
}


- (void)setModel:(HomeBookModel *)model {
    _model = model;
    if ([model.thumb containsString:kPrefixImageDefault]) {
        [self.thumImageView sd_setImageWithURL:[model.thumb url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }else {
        [self.thumImageView sd_setImageWithURL:[[kPrefixImageDefault stringByAppendingString:model.thumb] url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }
    
    self.nameLabel.text = model.title;
}

#pragma mark - get/set method
- (UIImageView *)thumImageView {
    if (!_thumImageView) {
        _thumImageView = [[UIImageView alloc] init];
        _thumImageView.image = [UIImage imageNamed:@"ph_image"];
    }
    return _thumImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"name";
        _nameLabel.font =[UIFont systemFontOfSize:16];
        _nameLabel.textColor = kColorValue(0x282828);
    }
    return _nameLabel;
}
@end
