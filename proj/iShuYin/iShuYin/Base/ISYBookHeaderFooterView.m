//
//  ISYBookHeaderFooterView.m
//  iShuYin
//
//  Created by ND on 2018/10/27.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYBookHeaderFooterView.h"

@implementation ISYBookHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.catogryTitleLabel];
        [self.catogryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView).mas_offset(12);
        }];
        
        UIImage *image = [UIImage imageNamed:@"icon-下一步"];
        NSString *buttionTitle = @"更多  ";
        CGSize size = [buttionTitle sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
        
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [moreButton setTitle:buttionTitle forState:UIControlStateNormal];
        
     
        [moreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [moreButton setImage:image forState:UIControlStateNormal];
        [moreButton setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, -image.size.width)];
        [moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, size.width, 0, 0)];
        
        
        [self.contentView addSubview:moreButton];
        [moreButton addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-12);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}


- (void)moreBtnClick {
    if (self.moreBlock != nil) {
        self.moreBlock();
    }
}
#pragma mark - get method
- (UILabel *)catogryTitleLabel {
    if (!_catogryTitleLabel) {
        _catogryTitleLabel = [[UILabel alloc] init];
    }
    return _catogryTitleLabel;
}


@end
