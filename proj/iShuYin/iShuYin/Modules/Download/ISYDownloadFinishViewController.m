//
//  ISYDownloadFinishViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/12/8.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYDownloadFinishViewController.h"
#import "ISYDownloadChaperStatusCell.h"
#import "BookDetailModel.h"
#import "ISYDBManager.h"
#import "ISYDownloadHelper.h"

@interface ISYDownloadFinishViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIImageView *thumImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *dinyueBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *downloadBtn;
@end

@implementation ISYDownloadFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已下载";
    [self setupUI];
    [self queryData];
    
    if ([self.book.thumb containsString:kPrefixImageDefault]) {
        [self.thumImageView sd_setImageWithURL:[self.book.thumb url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }else {
        [self.thumImageView sd_setImageWithURL:[[kPrefixImageDefault stringByAppendingString:self.book.thumb] url] placeholderImage:[UIImage imageNamed:@"ph_image"]];
    }
    self.titleLabel.text = self.book.title;
}

#pragma mark - private
- (void)queryData {
    self.dataSource = [NSMutableArray arrayWithArray:[[ISYDBManager shareInstance] queryDownloadChapers:4 bookId:self.bookId]];
    [self.tableView reloadData];
}

- (void)setupUI {
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(100 + 24);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).mas_offset(10);
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (void)deleteChaper:(BookChapterModel *)chaper {
    [[ISYDownloadHelper shareInstance] deleteDownloadBookId:self.bookId chaper:chaper];
    [self.dataSource removeObject:chaper];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookChapterModel *model = self.dataSource[indexPath.row];
    
    ISYDownloadChaperStatusCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"ISYDownloadChaperStatusCellid"];
    if (cell == nil) {
        cell = [[ISYDownloadChaperStatusCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ISYDownloadChaperStatusCellid"];
    }
    cell.status = 1;
    __weak __typeof(self)weakSelf = self;
    cell.deleteCb = ^(id  _Nonnull chaper) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf deleteChaper:chaper];
    };
    cell.chaper = model;
    return cell;
}

#pragma mark - get/set method

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:self.thumImageView];
        [_headView addSubview:self.titleLabel];
        [_headView addSubview:self.dinyueBtn];
        [_headView addSubview:self.deleteBtn];
        [_headView addSubview:self.downloadBtn];
        
        [self.thumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((100 ) / kCoverProportion, 100));
            make.top.left.equalTo(_headView).mas_offset(12);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.thumImageView.mas_right).mas_offset(8);
            make.top.equalTo(self.thumImageView);
        }];
        
        [self.dinyueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.thumImageView);
            make.left.equalTo(self.titleLabel);
        }];
        
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.thumImageView);
            make.left.equalTo(self.titleLabel);
        }];
        
        [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.thumImageView);
            make.right.equalTo(_headView).mas_offset(-12);
        }];
    }
    return _headView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource= self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (UIImageView *)thumImageView {
    if (!_thumImageView) {
        _thumImageView = [[UIImageView alloc] init];
    }
    return _thumImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIButton *)dinyueBtn {
    if (!_dinyueBtn) {
        _dinyueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dinyueBtn setTitle:@"订阅" forState:UIControlStateNormal];
        [_dinyueBtn setTitleColor:kMainTone forState:UIControlStateNormal];
    }
    return _dinyueBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"批量删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:kMainTone forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

- (UIButton *)downloadBtn {
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadBtn setTitle:@"下载更多" forState:UIControlStateNormal];
        [_downloadBtn setTitleColor:kMainTone forState:UIControlStateNormal];
    }
    return _downloadBtn;
}
@end
