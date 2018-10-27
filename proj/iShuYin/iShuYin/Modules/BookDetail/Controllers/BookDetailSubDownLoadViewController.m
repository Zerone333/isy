//
//  BookDetailSubDownLoadViewController.m
//  iShuYin
//
//  Created by 李艺真 on 2018/10/21.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "BookDetailSubDownLoadViewController.h"
#import "BookChapterCell.h"
#import "BookDetailModel.h"
#import "PlayViewController.h"
#import "BookDownloadBottomView.h"
#import "MCDownloader.h"

@interface BookDetailSubDownLoadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BookDownloadBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@end

@implementation BookDetailSubDownLoadViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for (BookChapterModel *chapterModel in _selectArray) {
        chapterModel.isSelected = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MCDownloader sharedDownloader].downloadTimeout = 60;
    [MCDownloader sharedDownloader].maxConcurrentDownloads = 1;
    [self configUI];
    [self configData];
}

- (void)configUI {
    NSString *text = [NSString stringWithFormat:@"%@",_detailModel.title];
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:text];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.equalTo(@(104));
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
}

- (void)configData {
    _dataArray = [NSMutableArray arrayWithCapacity:50];
    _selectArray = [NSMutableArray arrayWithCapacity:50];
    if (_detailModel.chapters.count) {
        [self getChapterWithIndex:0];
    }
}

- (void)getChapterWithIndex:(NSInteger)index {
    _bottomView.isChooseAll = NO;
    for (BookChapterModel *chapterModel in _selectArray) {
        chapterModel.isSelected = NO;
    }
    [_selectArray removeAllObjects];
    [_dataArray removeAllObjects];
    
    NSInteger count = (index + 1) * 50;
    if (count > _detailModel.chapters.count) {
        count = index * 50 + _detailModel.chapters.count%50;
    }
    for (NSInteger i = index * 50; i < count ; i++) {
        BookChapterModel *m = _detailModel.chapters[i];
        [_dataArray addObject:[m yy_modelCopy]];
    }
    [_tableView reloadData];
    if (_dataArray.count) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"BookChapterCell";
    BookChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    __weak __typeof(self)weakSelf = self;
    cell.chooseBlock = ^(BookChapterModel *chapterModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf chooseBtnClick:chapterModel];
    };
    cell.detailModel = _detailModel;
    BookChapterModel *chapterModel = _dataArray[indexPath.row];
    cell.chapterModel = chapterModel;
    cell.url = [chapterModel.l_url decodePlayURL];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kScreenWidth*94.0/750.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:@"download_ad"];
    return imgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookChapterModel *chapterModel = _dataArray[indexPath.row];
    [APPDELEGATE.playVC playWithBook:_detailModel index:chapterModel.l_id.integerValue-1];
    if ([self.navigationController.viewControllers containsObject:APPDELEGATE.playVC]) {
        [self.navigationController popToViewController:APPDELEGATE.playVC animated:YES];
    }else {
        [self.navigationController pushViewController:APPDELEGATE.playVC animated:YES];
    }
}

#pragma mark - Actions
//切换章节
- (void)chapterItemSelect:(NSInteger)idx {
    [self getChapterWithIndex:idx];
}

//单选
- (void)chooseBtnClick:(BookChapterModel *)chapterModel {
    if ([_selectArray containsObject:chapterModel]) {
        [_selectArray removeObject:chapterModel];
    }else {
        [_selectArray addObject:chapterModel];
    }
    _bottomView.isChooseAll = (_selectArray.count == _dataArray.count);
}

//全选
- (void)allBtnClick:(BOOL)isAll {
    [_selectArray removeAllObjects];
    for (BookChapterModel *m in _dataArray) {
        m.isSelected = isAll;
    }
    if (isAll) {
        [_selectArray addObjectsFromArray:_dataArray];
    }
    [_tableView reloadData];
}

//下载
- (void)downloadBtnClick {
    if (_selectArray.count == 0) {
        [SVProgressHUD showImage:nil status:@"请选择要下载的章节"];
        return;
    }
    for (BookChapterModel *m in _selectArray) {
        NSString *urlString = [m.l_url decodePlayURL];
        
        MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:urlString];
        if (receipt.progress.fractionCompleted == 1.0) {
            continue;
        }else {
            receipt.state = MCDownloadStateNone;
            receipt.customFilePathBlock = ^NSString * _Nullable(MCDownloadReceipt * _Nullable receipt) {
                NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *bookPath = [NSString stringWithFormat:@"%@/downloads/%@_%@/",document,_detailModel.show_id,_detailModel.title];
                return [bookPath stringByAppendingString:[NSString stringWithFormat:@"%@_%@",m.l_id,urlString.lastPathComponent]];
            };
            
        }
        [[MCDownloader sharedDownloader] downloadDataWithURL:[urlString url] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
            
        } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
            
        }];
        NSInteger row = [_dataArray indexOfObject:m];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"BookChapterCell" bundle:nil] forCellReuseIdentifier:@"BookChapterCell"];
    }
    return _tableView;
}

- (BookDownloadBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [BookDownloadBottomView loadFromNib];
        _bottomView.detailModel = _detailModel;
        __weak __typeof(self)weakSelf = self;
        _bottomView.itemBlock = ^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf chapterItemSelect:index];
        };
        _bottomView.allBlock = ^(BOOL isAll){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf allBtnClick:isAll];
        };
        _bottomView.downloadBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf downloadBtnClick];
        };
    }
    return _bottomView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
