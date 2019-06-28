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
@property (nonatomic, strong) UILabel *zanLabel;
@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) UIView *autoResizingView;


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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:listModel.add_time.integerValue];
    NSString *updateTime = [formatter stringFromDate:date];
    
    self.timeLabel.text = updateTime;
    self.desLabel.text = listModel.content;
    self.nameLabel.text = listModel.user_name;
    [self.zanBtn setTitle:listModel.agree forState:UIControlStateNormal];
    [self.zanBtn setTitle:listModel.agree forState:UIControlStateSelected];
    self.zanBtn.selected = listModel.isLike;
    self.zanLabel.text = listModel.agree;
}
#pragma mark - private
- (void)setupUI {
    [self.contentView addSubview:self.iconImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.desLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.zanBtn];
    [self.contentView addSubview:self.zanLabel];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).mas_offset(12);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage).mas_offset(12);
        make.left.equalTo(self.iconImage.mas_right).mas_offset(4);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).mas_offset(-12);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabel.mas_bottom).mas_offset(12);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.zanLabel.mas_left).mas_offset(0);
        make.centerY.equalTo(self.timeLabel);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.zanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).mas_offset(-15);
        make.centerY.equalTo(self.zanBtn);
    }];
    
    [self.contentView addSubview:self.autoResizingView];
    [self.autoResizingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10.0f);
    }];
}

- (void)zan {
    if (self.zanCb) {
        self.zanCb(self.model);
    }
}

#pragma mark - getter
- (UIView *)autoResizingView {
    if (!_autoResizingView) {
        _autoResizingView = [[UIView alloc] init];
    }
    return _autoResizingView;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
    }
    return _iconImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font =[UIFont systemFontOfSize:15];
        _nameLabel.textColor = kColorValue(0x282828);
    }
    return _nameLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.numberOfLines = 0;
        _desLabel.font =[UIFont systemFontOfSize:15];
        _desLabel.textColor = kColorValue(0x282828);
    }
    return _desLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font =[UIFont systemFontOfSize:15];
        _timeLabel.textColor = kColorValue(0x282828);
    }
    return _timeLabel;
}
        
- (UIButton *)zanBtn {
    if (!_zanBtn) {
        _zanBtn = [[UIButton alloc] init];
        [_zanBtn setImage:[UIImage imageNamed:@"comment_like_nor"] forState:UIControlStateNormal];
        [_zanBtn addTarget:self action:@selector(zan) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zanBtn;
}
- (UILabel *)zanLabel {
    if (!_zanLabel) {
        _zanLabel = [[UILabel alloc] init];
        _zanLabel.font =[UIFont systemFontOfSize:13];
        _zanLabel.textColor = kColorValue(0x666666);
    }
    return _zanLabel;
}

@end
