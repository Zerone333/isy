//
//  SleepCell.m
//  iShuYin
//
//  Created by Apple on 2017/12/21.
//  Copyright © 2017年 angxun. All rights reserved.
//

#import "SleepCell.h"
#import "SleepModel.h"

@interface SleepCell()
@property (weak, nonatomic) IBOutlet UILabel *intervalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImgView;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation SleepCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSleepModel:(SleepModel *)sleepModel {
    _sleepModel = sleepModel;
    
    if (sleepModel.sleepType == SleepType0) {
        _intervalLabel.text = @"不开启睡眠";
    }else {
        _intervalLabel.text = [NSString stringWithFormat:@"%li分钟后关闭",sleepModel.sleepType];
    }
    
    if (sleepModel.isSelected) {
        _flagImgView.image = [UIImage imageNamed:@"ph_sleep_sel"];
        if (sleepModel.sleepType == SleepType0) {
            //不开启
            _countdownLabel.hidden = YES;
            [self stopTimer];
        }else {
            _countdownLabel.hidden = NO;
            [self timerAction];
            [self startTimer];
        }
    }else {
        _flagImgView.image = [UIImage imageNamed:@"ph_sleep_nor"];
        _countdownLabel.hidden = YES;
        [self stopTimer];
    }
}

- (void)startTimer {
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)timerAction {
    DLog(@"%s", __FUNCTION__);
    if (APPDELEGATE.sleepInterval < 0) {
        [self stopTimer];
        _countdownLabel.hidden = YES;
        _sleepModel.isSelected = NO;
        _flagImgView.image = [UIImage imageNamed:@"ph_sleep_nor"];
    }else {
        NSInteger minute = APPDELEGATE.sleepInterval / 60;
        NSInteger second = APPDELEGATE.sleepInterval % 60;
        _countdownLabel.text = [NSString stringWithFormat:@"倒计时%02li:%02li",minute,second];
    }
}

- (void)dealloc {
    [self stopTimer];
}

@end
