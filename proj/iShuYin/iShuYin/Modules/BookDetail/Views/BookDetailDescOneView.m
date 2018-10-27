//
//  BookDetailDescOneView.m
//  iShuYin
//
//  Created by Apple on 2017/8/15.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookDetailDescOneView.h"

@interface BookDetailDescOneView ()
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@end

@implementation BookDetailDescOneView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.button1 setTitleColor:kColorValue(0xe82123) forState:UIControlStateSelected];
    [self.button1 setTitleColor:kColorValue(0x6666666) forState:UIControlStateNormal];
    [self.button2 setTitleColor:kColorValue(0xe82123) forState:UIControlStateSelected];
    [self.button2 setTitleColor:kColorValue(0x6666666) forState:UIControlStateNormal];
    [self.button3 setTitleColor:kColorValue(0xe82123) forState:UIControlStateSelected];
    [self.button3 setTitleColor:kColorValue(0x6666666) forState:UIControlStateNormal];
    self.button1.selected = YES;
    self.bottomLineView.backgroundColor =kColorValue(0xe82123);
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(4);
        make.centerX.equalTo(self.button1);
    }];
    
}

- (void)setDesc:(NSString *)desc {
    _desc = desc;
    _descLabel.text = desc;
}

//节目
- (IBAction)chapter1BtnClick:(id)sender {
    !_chapter1Block?:_chapter1Block();
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(4);
        make.centerX.equalTo(self.button1);
    }];
    self.button1.selected = YES;
    self.button2.selected = NO;
}
//x详情
- (IBAction)chapterBtnClick:(id)sender {
    !_chapterBlock?:_chapterBlock();
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(4);
        make.centerX.equalTo(self.button2);
    }];
    self.button1.selected = NO;
    self.button2.selected = YES;
}

//下载
- (IBAction)downloadBtnClick:(id)sender {
    !_downloadBlock?:_downloadBlock();
}

@end
