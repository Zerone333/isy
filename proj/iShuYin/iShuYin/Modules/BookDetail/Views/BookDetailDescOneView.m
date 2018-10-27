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
@end

@implementation BookDetailDescOneView

- (void)setDesc:(NSString *)desc {
    _desc = desc;
    _descLabel.text = desc;
}

//章节
- (IBAction)chapterBtnClick:(id)sender {
    !_chapterBlock?:_chapterBlock();
}

//下载
- (IBAction)downloadBtnClick:(id)sender {
    !_downloadBlock?:_downloadBlock();
}

@end
