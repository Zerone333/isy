//
//  BookDetailDescTwoView.m
//  iShuYin
//
//  Created by Apple on 2017/8/15.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookDetailDescTwoView.h"

@interface BookDetailDescTwoView ()
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *foldBtn;

@end

@implementation BookDetailDescTwoView

- (void)awakeFromNib {
    [super awakeFromNib];
    [_foldBtn setTitle:@"展开" forState:UIControlStateNormal];
    [_foldBtn setTitle:@"收起" forState:UIControlStateSelected];
    [_foldBtn setTitleColor:kColorValue(0x8DC44B) forState:UIControlStateNormal];
    [_foldBtn setTitleColor:kColorValue(0x8DC44B) forState:UIControlStateSelected];
}

- (void)setDesc:(NSString *)desc {
    _desc = desc;
    _descLabel.text = desc;
}

- (void)setUnfoldHeight:(CGFloat)unfoldHeight {
    _unfoldHeight = unfoldHeight;
}

//章节
- (IBAction)chapterBtnClick:(id)sender {
    !_chapterBlock?:_chapterBlock();
}

//下载
- (IBAction)downloadBtnClick:(id)sender {
    !_downloadBlock?:_downloadBlock();
}

//展开/收起
- (IBAction)foldBtnClick:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    CGFloat h = btn.isSelected ? (198-84+_unfoldHeight) : 198;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(h));
    }];
}

@end
