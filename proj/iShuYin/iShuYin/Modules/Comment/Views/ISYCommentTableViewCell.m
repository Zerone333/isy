//
//  ISYCommentTableViewCell.m
//  iShuYin
//
//  Created by ND on 2018/11/10.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYCommentTableViewCell.h"

@interface ISYCommentTableViewCell ()
@property (nonatomic, strong)  UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *zanBtn;


@end

@implementation ISYCommentTableViewCell

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
        [self setupUI];
    }
    return self;
}

- (void)setModel:(CommentListModel *)listModel {
    if (listModel == nil) {
        return;
    }
    _model = listModel;
    [self.iconImage sd_setImageWithURL:[listModel.passport.img_url url] placeholderImage:[UIImage imageNamed:@"ph_man"]];
    self.nameLabel.text = [NSString isEmpty:listModel.passport.nickname]?@"":listModel.passport.nickname;
    
    NSString *create_time = [NSString stringWithFormat:@"%f",listModel.create_time.floatValue/1000];
    self.timeLabel.text = [NSString dateStringWithTimeIntervalSince1970:create_time];
    self.desLabel.text = listModel.content;
    
    [self.zanBtn setTitle:listModel.agree forState:UIControlStateNormal];
    [self.zanBtn setTitle:listModel.agree forState:UIControlStateSelected];
    self.zanBtn.selected = listModel.isLike;
}

#pragma mark - private
- (void)setupUI {
    [self.contentView addSubview:self.iconImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.desLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.zanBtn];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).mas_offset(12);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage);
        make.left.equalTo(self.iconImage.mas_right);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).mas_offset(12);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabel.mas_bottom).mas_offset(12);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.left.equalTo(self.contentView).mas_offset(50);
    }];
    
}

#pragma mark - getter
- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
    }
    return _iconImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
    }
    return _desLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
    }
    return _timeLabel;
}
        
- (UIButton *)zanBtn {
    if (!_zanBtn) {
        _zanBtn = [[UIButton alloc] init];
        [_zanBtn setImage:[UIImage imageNamed:@"comment_like_nor"] forState:UIControlStateNormal];
        [_zanBtn setImage:[UIImage imageNamed:@"comment_like_sel"] forState:UIControlStateNormal];
    }
    return _zanBtn;
}

@end
