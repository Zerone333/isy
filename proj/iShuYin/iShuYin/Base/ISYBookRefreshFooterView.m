//
//  ISYBookRefreshFooterView.m
//  iShuYin
//
//  Created by ND on 2018/11/10.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYBookRefreshFooterView.h"

@implementation ISYBookRefreshFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [refreshButton setImage:[UIImage imageNamed:@"换一换btn"] forState:UIControlStateNormal];
        [refreshButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [refreshButton addTarget:self action:@selector(refreshButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:refreshButton];
        [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(80, 44));
        }];
        
    }
    return self;
}

- (void)refreshButtonClick {
    if (self.refreshBlock != nil) {
        self.refreshBlock();
    }
}

+(CGFloat)height {
    return 50;
}

@end
