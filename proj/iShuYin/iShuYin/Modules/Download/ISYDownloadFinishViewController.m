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
#import "BookChapterViewController.h"

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

#pragma mark - action

- (void)dinyueBtnClick {
    //TODO: 订阅
}

- (void)deleteBtnClick {
    BookChapterViewController *vc = [[BookChapterViewController alloc]init];
    vc.detailModel = self.book;
    vc.isDelete = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)downloadBtnClick {
    BookChapterViewController *vc = [[BookChapterViewController alloc]init];
    vc.detailModel = self.book;
    [self.navigationController pushViewController:vc animated:YES];
}

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
    cell.isLoading = NO;
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
            make.size.mas_equalTo(CGSizeMake(94, 26));
        }];
        
        [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.thumImageView);
            make.right.equalTo(_headView).mas_offset(-12);
            make.size.mas_equalTo(CGSizeMake(94, 26));
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
        [_dinyueBtn setImage:[UIImage imageNamed:@"订阅btn"] forState:UIControlStateNormal];
        [_dinyueBtn setTitleColor:kMainTone forState:UIControlStateNormal];
        [_dinyueBtn addTarget:self action:@selector(dinyueBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dinyueBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"批量删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _deleteBtn.backgroundColor = [UIColor grayColor];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.layer.cornerRadius = 4;
    }
    return _deleteBtn;
}

- (UIButton *)downloadBtn {
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadBtn setTitle:@"下载更多" forState:UIControlStateNormal];
        [_downloadBtn setImage:[UIImage imageNamed:@"download_btn"] forState:UIControlStateNormal];
        _downloadBtn.backgroundColor = kMainTone;
        _downloadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_downloadBtn addTarget:self action:@selector(downloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _downloadBtn.layer.masksToBounds = YES;
        _downloadBtn.layer.cornerRadius = 4;
    }
    return _downloadBtn;
}
@end
