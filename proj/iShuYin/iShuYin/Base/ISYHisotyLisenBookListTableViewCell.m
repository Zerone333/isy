//
//  ISYHisotyLisenBookListTableViewCell.m
//  iShuYin
//
//  Created by ND on 2018/11/13.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYHisotyLisenBookListTableViewCell.h"
@interface ISYHisotyLisenBookListTableViewCell ()
@property (nonatomic, strong) UILabel *chaperLabel;
@property (nonatomic, strong) UIImageView *audioIcon;
@property (nonatomic, strong) UILabel *currentTimeLabe;
@property (nonatomic, strong) UIButton *continueButton;
@end

@implementation ISYHisotyLisenBookListTableViewCell

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
        [self addSubview:self.chaperLabel];
        [self addSubview:self.audioIcon];
        [self addSubview:self.currentTimeLabe];
        [self addSubview:self.continueButton];
        [self.chaperLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.nameLabel);
        }];
        
        [self.audioIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.thumImageView).mas_offset(-12);
            make.left.equalTo(self.nameLabel);
        }];
        
        [self.currentTimeLabe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.audioIcon.mas_right).mas_offset(8);
            make.centerY.equalTo(self.audioIcon);
        }];
        
        [self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 24));
            make.centerY.equalTo(self.audioIcon);
            make.right.equalTo(self.contentView).mas_offset(-12);
        }];
    }
    return self;
}

+ (NSString *)cellID {
    return @"ISYHisotyLisenBookListTableViewCellid";
}

- (void)setHistoryListenModel:(ISYHistoryListenModel *)historyListenModel {
    _historyListenModel = historyListenModel;
    HomeBookModel *bookModel = [[HomeBookModel alloc] init];
    bookModel.title = historyListenModel.bookModel.title;
    bookModel.thumb = historyListenModel.bookModel.thumb;
    self.model = bookModel;
    
    self.chaperLabel.text = [NSString stringWithFormat:@"第%ld集", (long)historyListenModel.chaperNumber + 1];
    self.currentTimeLabe.text = [NSString stringWithFormat:@"场次播放至%@", [self timeConvert:historyListenModel.time]];
}
- (NSString *)timeConvert:(NSInteger)time {
    NSInteger s = time % 60;
    NSInteger m = (time - s) / 60;
    NSInteger h = (time - s - m * 60)/ 3600;
    return  [NSString stringWithFormat:@"%ld:%ld", (long)m, s, time];
}
#pragma mark - Event
- (void)continueButtonClick {
    if (self.playBlock != nil) {
        self.playBlock(self.historyListenModel);
    }
}

#pragma mark - getter
- (UILabel *)chaperLabel {
    if (!_chaperLabel) {
        _chaperLabel = [[UILabel alloc] init];
        _chaperLabel.textColor = kColorValue(0x666666);
        _chaperLabel.font = [UIFont systemFontOfSize:13];
        
    }
    return _chaperLabel;
}

- (UIImageView *)audioIcon {
    if (!_audioIcon) {
        _audioIcon = [[UIImageView alloc] init];
        _audioIcon.image = [UIImage imageNamed:@"播报icon"];
    }
    return _audioIcon;
}

- (UILabel *)currentTimeLabe {
    if (!_currentTimeLabe) {
        _currentTimeLabe = [[UILabel alloc] init];
        _currentTimeLabe.textColor = kColorValue(0x666666);
        _currentTimeLabe.font = [UIFont systemFontOfSize:16];
        
    }
    return _currentTimeLabe;
}

- (UIButton *)continueButton {
    if (!_continueButton) {
        _continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_continueButton setTitle:@"继续收听" forState:UIControlStateNormal];
        _continueButton.backgroundColor =[ UIColor redColor];
        _continueButton.layer.masksToBounds = YES;
        _continueButton.layer.cornerRadius = 2;
        _continueButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_continueButton addTarget:self action:@selector(continueButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continueButton;
}
@end
