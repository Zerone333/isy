//
//  BookChapterCountCell.m
//  iShuYin
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookChapterCountCell.h"

@interface BookChapterCountCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation BookChapterCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 4.0f;
    self.contentView.layer.borderColor = kColorValue(0x999999).CGColor;
    self.contentView.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _label.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor redColor];
    }else {
        _label.textColor = kColorValue(0x666666);
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    _label.text = text;
}

@end
