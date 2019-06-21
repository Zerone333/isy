//
//  ISYDownloadChaperStatusCell.m
//  iShuYin
//
//  Created by 李艺真 on 2018/12/8.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYDownloadChaperStatusCell.h"
#import "ISYDownloadHelper.h"

@interface ISYDownloadChaperStatusCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UILabel *downloadingText;
@property (nonatomic, strong) UIImageView *timeIcon;
@property (nonatomic, strong) UILabel *waitLabel;
@end

@implementation ISYDownloadChaperStatusCell

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
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.deleteButton];
        [self.contentView addSubview:self.downloadingText];
        [self.contentView addSubview:self.timeIcon];
        [self.contentView addSubview:self.waitLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(12);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.equalTo(self.contentView);
            make.width.mas_equalTo(44);
        }];
        
        [self.timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.waitLabel.mas_left).mas_offset(-4);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.downloadingText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-12);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-12);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - Evnet

- (void)deleteButtonClick {
    if (self.deleteCb) {
        self.deleteCb(self.chaper);
    }
}

#pragma mark - get/set method
- (void)setStatus:(NSInteger)status {
    self.deleteButton.hidden = status != 1;
    self.timeIcon.hidden = status ==1;
    self.downloadingText.hidden = status ==1;
    self.waitLabel.hidden = status ==1;
}

- (void)setChaper:(BookChapterModel *)chaper {
    _chaper = chaper;
    self.titleLabel.text = chaper.l_title;
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:[chaper.l_url decodePlayURL]];
    if (receipt.state == MCDownloadStateDownloading) {
        self.timeIcon.hidden = YES;
        self.waitLabel.hidden = YES;
        self.downloadingText.hidden = NO;
        [[ISYDownloadHelper shareInstance] downloadChaper:chaper bookId:self.bookId progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
            self.downloadingText.text = [NSString stringWithFormat:@"%.0f%%", receivedSize * 1.0/ expectedSize * 100];
        } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
            if (self.downLoadFinishCb) {
                self.downLoadFinishCb(chaper);
            }
            DLog(@"刷新列表");
        }];
    } else if (receipt.state == MCDownloadStateCompleted) {
        DLog(@"重新获取数据刷新列表");
    } else if (receipt.state == MCDownloadStateWillResume) {
        self.timeIcon.hidden = NO;
        self.waitLabel.hidden = NO;
        self.downloadingText.hidden = YES;
        
    } else if (receipt.state == MCDownloadStateFailed) {
        self.timeIcon.hidden = YES;
        self.waitLabel.hidden = YES;
        self.downloadingText.hidden = NO;
        self.downloadingText.text = @"下载失败";
        
        
        if (self.isLoading) {
            self.downloadingText.hidden = NO;
            self.downloadingText.text = @"重新下载";
        }
    } else if (receipt.state == MCDownloadStateNone) {
        self.timeIcon.hidden = YES;
        self.waitLabel.hidden = YES;
        self.downloadingText.hidden = YES;
        
        
        if (self.isLoading) {
            self.downloadingText.hidden = NO;
            self.downloadingText.text = @"开始下载";
        }
    }
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_deleteButton setImage:[UIImage imageNamed:@"播报icon"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _titleLabel;
}

- (UILabel *)downloadingText {
    if (!_downloadingText) {
        _downloadingText = [[UILabel alloc] init];
        _downloadingText.text = @"";
        _downloadingText.textColor = [UIColor blackColor];
        _downloadingText.font = [UIFont systemFontOfSize:12];
    }
    return _downloadingText;
}

- (UILabel *)waitLabel {
    if (!_waitLabel) {
        _waitLabel = [[UILabel alloc] init];
        _waitLabel.text = @"等待下载";
        _waitLabel.textColor = [UIColor blackColor];
        _waitLabel.font = [UIFont systemFontOfSize:12];
    }
    return _waitLabel;
}

- (UIImageView *)timeIcon {
    if (!_timeIcon) {
        _timeIcon = [[UIImageView alloc] init];
        _timeIcon.image = [UIImage imageNamed:@"播报icon"];
    }
    return _timeIcon;
}

@end
