//
//  ISYChaperListView.m
//  iShuYin
//
//  Created by 李艺真 on 2019/1/13.
//  Copyright © 2019年 ishuyin. All rights reserved.
//

#import "ISYChaperListView.h"

@interface ISYChaperListView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, weak) BookDetailModel *book;
@property (nonatomic, strong) UIImageView *playSortImage;
@property (nonatomic, strong) UILabel *playSortLabel;
@property (nonatomic, strong) UIImageView *listSortImage;
@property (nonatomic, strong) UILabel *listSortLabel;
@end

@implementation ISYChaperListView

+ (instancetype)showWithBook:(BookDetailModel *)book {
    ISYChaperListView *view = [[ISYChaperListView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    view.book = book;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.sortNormal = YES;
        [self addSubview:self.bottomView];
        [self addSubview:self.tableView];
        [self addSubview:self.headView];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(44);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(350);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];

        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(52);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.tableView.mas_top);
        }];
        
        self.playSortImage.image = [UIImage imageNamed:@"顺序播放"];
        self.playSortLabel.text = @"顺序播放";
        self.listSortImage.image = [UIImage imageNamed:@"sort_z"];
        self.listSortLabel.text = @"正序";

    }
    return self;
}

#pragma mark - set

- (void)setPlaySort:(ISYPalySort)playSort {
    _playSort = playSort;
    switch (_playSort) {
        case ISYPalySortshunxu:
            {
                self.playSortImage.image = [UIImage imageNamed:@"顺序播放"];
                self.playSortLabel.text = @"顺序播放";
            }
            break;
        case ISYPalySortSingle:
        {
            self.playSortImage.image = [UIImage imageNamed:@"单集循环"];
            self.playSortLabel.text = @"单集循环";
            
        }
            break;
        case ISYPalySortRandam:
        {
            self.playSortImage.image = [UIImage imageNamed:@"随机"];
            self.playSortLabel.text = @"随机";
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Action

- (void)closeButtonClick {
    [self removeFromSuperview];
}

- (void)playSortButtonClick {
    switch (self.playSort) {
        case ISYPalySortshunxu:
        {
            self.playSort = ISYPalySortSingle;
        }
            break;
        case ISYPalySortSingle:
        {
            self.playSort = ISYPalySortRandam;
            
        }
            break;
        case ISYPalySortRandam:
        {
            self.playSort = ISYPalySortshunxu;
            
        }
            break;
            
        default:
            break;
    }
    
    self.sortCallBack(self.playSort);
}

- (void)listSortButtonClick {
    self.sortNormal = !self.sortNormal;
    if (self.sortNormal) {
        self.listSortImage.image = [UIImage imageNamed:@"sort_z"];
        self.listSortLabel.text = @"正序";
    } else {
        self.listSortImage.image = [UIImage imageNamed:@"sort_n"];
        self.listSortLabel.text = @"逆序";
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.book.chapters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fdfsfsd"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fdfsfsd"];
    }
    if (self.sortNormal) {
        BookChapterModel *chaper = self.book.chapters[indexPath.row];
        cell.textLabel.text = chaper.l_title;
        
        if (APPDELEGATE.playVC.currentIndex == indexPath.row) {
            cell.imageView.image = [UIImage imageNamed:@"播放状态"];
        } else {
            cell.imageView.image = nil;
        }
    } else {
        NSInteger total = self.book.chapters.count - 1 ;
        BookChapterModel *chaper = self.book.chapters[total - indexPath.row];
        cell.textLabel.text = chaper.l_title;
        
        if (APPDELEGATE.playVC.currentIndex == total - indexPath.row) {
            cell.imageView.image = [UIImage imageNamed:@"播放状态"];
        } else {
            cell.imageView.image = nil;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark getter
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
        
        [_headView addSubview:self.playSortImage];
        [_headView addSubview:self.playSortLabel];
        [_headView addSubview:self.listSortImage];
        [_headView addSubview:self.listSortLabel];
        
        [self.playSortImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headView).mas_offset(12);
            make.centerY.equalTo(_headView);
        }];
        
        [self.playSortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playSortImage.mas_right).mas_offset(4);
            make.centerY.equalTo(_headView);
        }];
        
        [self.listSortImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.listSortLabel.mas_left).mas_offset(-4);
            make.centerY.equalTo(_headView);
        }];
        
        [self.listSortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headView).mas_offset(-12);
            make.centerY.equalTo(_headView);
        }];
        
        
        UIButton *playSortButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playSortButton addTarget:self action:@selector(playSortButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:playSortButton];
        [playSortButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(_headView);
            make.right.equalTo(self.playSortLabel);
        }];
        
        
        UIButton *listSortButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [listSortButton addTarget:self action:@selector(listSortButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:listSortButton];
        [listSortButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_headView);
            make.left.equalTo(self.listSortImage);
        }];
        
    }
    return _headView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_bottomView);
        }];
    }
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)playSortImage {
    if (!_playSortImage) {
        _playSortImage = [[ UIImageView alloc] init];
    }
    return _playSortImage;
}

- (UILabel *)playSortLabel {
    if (!_playSortLabel) {
        _playSortLabel = [[UILabel alloc] init];
    }
    return _playSortLabel;
}

- (UIImageView *)listSortImage {
    if (!_listSortImage) {
        _listSortImage = [[ UIImageView alloc] init];
    }
    return _listSortImage;
}

- (UILabel *)listSortLabel {
    if (!_listSortLabel) {
        _listSortLabel = [[UILabel alloc] init];
        _listSortLabel.text = @"正序";
    }
    return _listSortLabel;
}
@end
