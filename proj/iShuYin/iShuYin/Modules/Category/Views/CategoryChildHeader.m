//
//  CategoryChildHeader.m
//  iShuYin
//
//  Created by Apple on 2017/8/10.
//  Copyright © 2016年 angxun. All rights reserved.
//

#import "CategoryChildHeader.h"

@interface CategoryChildHeader ()
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@end

@implementation CategoryChildHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHeader:(NSString *)header {
    _header = header;
    _headerLabel.text = header;
}

@end
