//
//  FeedbackAdminCell.m
//  iShuYin
//
//  Created by Apple on 2017/9/20.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "FeedbackAdminCell.h"
#import "FeedbackModel.h"


@interface FeedbackAdminCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *msgContentView;
@property (weak, nonatomic) IBOutlet UILabel *msgContentLabel;
@end

@implementation FeedbackAdminCell

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
    _timeLabel.text = [NSString dateStringWithTimeIntervalSince1970:model.msg_time];
    _msgContentLabel.text = model.msg_content;
    [_msgContentView layoutIfNeeded];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_msgContentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0f, 8.0f)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = _msgContentView.bounds;
    shapeLayer.path = bezierPath.CGPath;
    _msgContentView.layer.mask = shapeLayer;
}

@end
