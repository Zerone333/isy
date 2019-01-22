//
//  SubCollectCell.m
//  iShuYin
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "SubCollectCell.h"
#import "HomeBookModel.h"

@interface SubCollectCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *subscribButton;
@end

@implementation SubCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.subscribButton.backgroundColor = kMainTone;
    self.subscribButton.layer.masksToBounds = YES;
    self.subscribButton.layer.cornerRadius = 4;
    [self.subscribButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBookModel:(HomeBookModel *)bookModel {
    _bookModel = bookModel;
    if ([bookModel.thumb containsString:kPrefixImageDefault]) {
        [_imgView sd_setImageWithURL:[bookModel.thumb url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }else {
        [_imgView sd_setImageWithURL:[[kPrefixImageDefault stringByAppendingString:bookModel.thumb] url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }
    _titleLabel.text = bookModel.title;
    _directorLabel.text = [NSString stringWithFormat:@"%@",bookModel.director];
    NSString *dateString = [NSString dateStringWithTimeIntervalSince1970:bookModel.ctime];
    _timeLabel.text = [NSString stringWithFormat:@"%@ 更新",dateString];
}

- (IBAction)deleteBtnClick:(id)sender {
    !_collectCancelBlock?:_collectCancelBlock(_bookModel);
}

@end
