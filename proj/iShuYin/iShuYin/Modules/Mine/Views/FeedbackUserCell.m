//
//  FeedbackUserCell.m
//  iShuYin
//
//  Created by Apple on 2017/9/20.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "FeedbackUserCell.h"
#import "FeedbackModel.h"

@interface FeedbackUserCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *msgContentView;
@property (weak, nonatomic) IBOutlet UILabel *msgContentLabel;
@end

@implementation FeedbackUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _msgContentView.layer.borderWidth = 1.0f;
    _msgContentView.layer.borderColor = kColorValue(0xf3f4fa).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FeedbackModel *)model {
    _model = model;
    _timeLabel.text = [NSString dateStringWithTimeIntervalSince1970:model.msg_time];
    NSString *config = [USERDEFAULTS objectForKey:kUserConfigHeader];
    if (![NSString isEmpty:config] && config.integerValue == 1) {
        _imgView.image = [UIImage imageNamed:@"ph_women"];
    }else {
        _imgView.image = [UIImage imageNamed:@"ph_man"];
    }
    _msgContentLabel.text = model.msg_content;
    [_msgContentView layoutIfNeeded];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_msgContentView.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0f, 8.0f)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = _msgContentView.bounds;
    shapeLayer.path = bezierPath.CGPath;
    _msgContentView.layer.mask = shapeLayer;
}

@end
