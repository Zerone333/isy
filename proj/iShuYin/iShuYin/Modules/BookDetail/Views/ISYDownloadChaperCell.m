//
//  ISYDownloadChaperCell.m
//  iShuYin
//
//  Created by 李艺真 on 2018/12/8.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYDownloadChaperCell.h"
#import "BookDetailModel.h"
#import "MCDownloader.h"

@interface ISYDownloadChaperCell ()
@property (strong, nonatomic) UIImageView *chooseImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) UILabel *statuLabel;
@end

@implementation ISYDownloadChaperCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.chooseImageView];
        [self.contentView addSubview:self.titleLabel];
        
        [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(44);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.chooseImageView.mas_right).mas_offset(4);
        }];
        
        [self.contentView addSubview:self.statuLabel];
        [self.statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-4);
            
        }];
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    if (selected) {
//        self.chooseImageView.image = [UIImage imageNamed:@"download_choose_sel"];
//    } else {
//        self.chooseImageView.image = [UIImage imageNamed:@"download_choose_nor"];
//    }
//}

#pragma mark - Setter
- (void)setChapterModel:(BookChapterModel *)chapterModel {
    _chapterModel = chapterModel;
    if (chapterModel.isSelected) {
        self.chooseImageView.image = [UIImage imageNamed:@"download_choose_sel"];
    } else {
        self.chooseImageView.image = [UIImage imageNamed:@"download_choose_nor"];
    }
    
//    self.chooseImageView.hidden = chapterModel.isSelected;
    _titleLabel.text = chapterModel.l_title;
}

- (UIImageView *)chooseImageView {
    if (!_chooseImageView) {
        _chooseImageView = [[UIImageView alloc] init];
        _chooseImageView.contentMode = UIViewContentModeCenter;
    }
    return _chooseImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)statuLabel {
    if (!_statuLabel) {
        _statuLabel = [[UILabel alloc] init];
    }
    return _statuLabel;
}

- (void)setUrl:(NSString *)url {
    _url = url;
//    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:url];
//    receipt.customFilePathBlock = ^NSString * _Nullable(MCDownloadReceipt * _Nullable receipt) {
//        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSString *bookPath = [NSString stringWithFormat:@"%@/downloads/%@_%@/",document,_detailModel.show_id,_detailModel.title];
//        return [bookPath stringByAppendingString:[NSString stringWithFormat:@"%@_%@",self.chapterModel.l_id,url.lastPathComponent]];
//    };
//    
//     CGFloat progress = receipt.progress.fractionCompleted;
//    if (receipt.state == MCDownloadStateDownloading || receipt.state == MCDownloadStateWillResume) {
//        self.statuLabel.text = @"停止中/等待下载";
//    } else if (receipt.state == MCDownloadStateCompleted) {
//            self.statuLabel.text = @"已下载";
//    } else {
//        if (progress == 1.0) {
//            self.statuLabel.text = @"已下载";
//        }else {
//            self.statuLabel.text = @"还未下载/下载失败";
//        }
//    }
//    
//    receipt.downloaderProgressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
//        if ([targetURL.absoluteString isEqualToString:self.url]) {
//            NSLog(@"%@", [NSString stringWithFormat:@"下载中 %f", receivedSize * 1.0/ expectedSize ]);
//            self.statuLabel.text = [NSString stringWithFormat:@"下载中 %f", receivedSize * 1.0/ expectedSize ];
//        }
//    };
//    
//    receipt.downloaderCompletedBlock = ^(MCDownloadReceipt *receipt, NSError * _Nullable error, BOOL finished) {
//        if (error) {
//            self.statuLabel.text = @"下载失败";
//        } else {
//            self.statuLabel.text = @"下载完成";
//        }
//    };
}
@end
