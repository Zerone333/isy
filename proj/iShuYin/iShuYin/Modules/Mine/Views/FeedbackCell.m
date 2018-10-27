//
//  FeedbackCell.m
//  iShuYin
//
//  Created by Apple on 2017/9/19.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "FeedbackCell.h"
#import "FeedbackModel.h"

@interface FeedbackCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation FeedbackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FeedbackModel *)model {
    _model = model;
    _titleLabel.text = model.msg_title;
    _timeLabel.text = [NSString dateStringWithTimeIntervalSince1970:model.msg_time];
}

@end
