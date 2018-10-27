//
//  CommentListCell.m
//  iShuYin
//
//  Created by Apple on 2017/10/23.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "CommentListCell.h"
#import "CommentListModel.h"

@interface CommentListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@end

@implementation CommentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListModel:(CommentListModel *)listModel {
    _listModel = listModel;
    [_imgView sd_setImageWithURL:[listModel.passport.img_url url] placeholderImage:[UIImage imageNamed:@"ph_man"]];
    _nameLabel.text = [NSString isEmpty:listModel.passport.nickname]?@"":listModel.passport.nickname;
    
    NSString *create_time = [NSString stringWithFormat:@"%f",listModel.create_time.floatValue/1000];
    _timeLabel.text = [NSString dateStringWithTimeIntervalSince1970:create_time];
    _contentLabel.text = listModel.content;
    if ([NSString isEmpty:listModel.support_count] || listModel.support_count.integerValue <= 0 ) {
        _countLabel.text = listModel.isLike?@"1":@"0";
    }else {
        if (listModel.isLike) {
            _countLabel.text = [NSString stringWithFormat:@"%li",listModel.support_count.integerValue+1];
        }else {
            _countLabel.text = [NSString stringWithFormat:@"%li",listModel.support_count.integerValue];
        }
    }
    _likeBtn.selected = listModel.isLike;
}

- (IBAction)likeBtnClick:(id)sender {
    if (_likeBtn.isSelected) {
        return;
    }
    !_commentLikeBlock?:_commentLikeBlock(_listModel);
}

@end
