//
//  GuideCell.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "GuideCell.h"

@interface GuideCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation GuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    _imgView.image = [UIImage imageNamed:imgName];
}

@end
