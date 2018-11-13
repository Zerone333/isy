//
//  ISYBookListTableCarViewCell.m
//  iShuYin
//
//  Created by ND on 2018/11/13.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYBookListTableCarViewCell.h"

@interface ISYBookListTableCarViewCell ()

@property (nonatomic, strong) UILabel *desLabel;
@end

@implementation ISYBookListTableCarViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).mas_offset(4);
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.contentView).mas_offset(-12);
            make.bottom.lessThanOrEqualTo(self.contentView).mas_offset(-12);
        }];
    }
    return self;
}

+ (NSString *)cellID {
    return @"ISYBookListTableCarViewCellID";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setModel:(HomeBookModel *)model {
    [super setModel:model];
   self.desLabel.text = model.descriptionString;
}

#pragma mark -getter
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.numberOfLines = 0;
        _desLabel.textColor = kColorValue(0x333333);
        _desLabel.font =[UIFont systemFontOfSize:13];
    }
    return _desLabel;
}
@end
