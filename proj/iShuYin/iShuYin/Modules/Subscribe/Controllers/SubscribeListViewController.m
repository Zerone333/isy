//
//  SubscribeListViewController.m
//  iShuYin
//
//  Created by Apple on 2017/10/2.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "SubscribeListViewController.h"

#import "SubDownloadCell.h"
#import "SubCollectCell.h"
#import "SubRecentCell.h"

#import "HomeBookModel.h"
#import "BookDetailModel.h"

#import "BookDownloadViewController.h"
#import "BookDetailViewController.h"

#import "ZXEmptyView.h"
#import "MCDownloader.h"

@interface SubscribeListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZXEmptyView *emptyView;
@end

@implementation SubscribeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    [self configUI];
    [self configData];
}

- (void)configUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)configData {
    if (_listType == SubscribeTypeDownload) {
        [self configDataDownload];
    }else if (_listType == SubscribeTypeCollect) {
        [self configDataCollect];
    }else if (_listType == SubscribeTypeRecent) {
        [self configDataRecent];
    }
}

- (void)configDataDownload {
    [_dataArray removeAllObjects];
    NSString *json = [USERDEFAULTS objectForKey:kDownloadBooks];
    NSArray *bookArray = [NSArray yy_modelArrayWithClass:[BookDetailModel class] json:json];
    
    for (BookDetailModel *m in bookArray) {
        [self caculateChapterCountWithModel:m];
        [_dataArray addObject:m];
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    self.tableView.backgroundView = _dataArray.count?nil:self.emptyView;
}

- (void)configDataCollect {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryCollectionList];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager GETWithURLString:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            [strongSelf.dataArray removeAllObjects];
            NSArray *temp = [NSArray yy_modelArrayWithClass:[HomeBookModel class] json:responseObject[@"data"]];
            [strongSelf.dataArray addObjectsFromArray:temp];
            [strongSelf.tableView reloadData];
            strongSelf.tableView.backgroundView = strongSelf.dataArray.count?nil:strongSelf.emptyView;
        }else {
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
        [strongSelf.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)configDataRecent {
    [_dataArray removeAllObjects];
    NSString *json = [USERDEFAULTS objectForKey:kRecentBooks];
    NSArray *bookArray = [NSArray yy_modelArrayWithClass:[BookDetailModel class] json:json];
    [_dataArray addObjectsFromArray:bookArray];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    self.tableView.backgroundView = _dataArray.count?nil:self.emptyView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_listType == SubscribeTypeDownload) {
        static NSString *reuseId = @"SubDownloadCell";
        SubDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        __weak __typeof(self)weakSelf = self;
        cell.deleteBlock = ^(BookDetailModel *m) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf deleteDownloadWithModel:m];
        };
        cell.detailModel = _dataArray[indexPath.row];
        return cell;
    }
    else if (_listType == SubscribeTypeCollect) {
        static NSString *reuseId = @"SubCollectCell";
        SubCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        __weak __typeof(self)weakSelf = self;
        cell.collectCancelBlock = ^(HomeBookModel *model) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf collectCancelWithModel:model];
        };
        cell.bookModel = _dataArray[indexPath.row];
        return cell;
    }else if (_listType == SubscribeTypeRecent) {
        static NSString *reuseId = @"SubRecentCell";
        SubRecentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        cell.detailModel = _dataArray[indexPath.row];
        return cell;
    }else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_listType == SubscribeTypeDownload) {
        BookDownloadViewController *vc = [[BookDownloadViewController alloc]init];
        vc.detailModel = _dataArray[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_listType == SubscribeTypeCollect) {
        HomeBookModel *model = _dataArray[indexPath.row];
        if ([NSString isEmpty:model.show_id]) {
            [SVProgressHUD showImage:nil status:@"书本数据有误"];
            return;
        }
        BookDetailViewController *vc = [[BookDetailViewController alloc]init];
        vc.bookid = model.show_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_listType == SubscribeTypeRecent) {
        BookDetailModel *model = _dataArray[indexPath.row];
        if ([NSString isEmpty:model.show_id]) {
            [SVProgressHUD showImage:nil status:@"书本数据有误"];
            return;
        }
        BookDetailViewController *vc = [[BookDetailViewController alloc]init];
        vc.bookid = model.show_id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Methods
- (void)caculateChapterCountWithModel:(BookDetailModel *)detailModel {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *bookPath = [NSString stringWithFormat:@"%@/downloads/%@_%@",document,detailModel.show_id,detailModel.title];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:bookPath]) {
        return;
    }
    NSDirectoryEnumerator *enumerator = [fm enumeratorAtPath:bookPath];
    NSInteger count = 0;
    for (NSString *fileName in enumerator) {
        if ([NSString isEmpty:fileName]) {
            continue;
        }
        NSString *cid = [[fileName componentsSeparatedByString:@"_"]firstObject];//章节id
        for (BookChapterModel *chapter in detailModel.chapters) {
            if ([cid isEqualToString:chapter.l_id]) {
                count++;
            }
        }
    }
    detailModel.download_count = count;
}

#pragma mark - Actions
//收藏
- (void)collectCancelWithModel:(HomeBookModel *)model {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryCollectionOperate];
    NSDictionary *params = @{@"book_id":model.show_id,
                             @"operate":@"2",//1 收藏 2取消收藏
                             };
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager POSTWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSInteger idx = [strongSelf.dataArray indexOfObject:model];
            [strongSelf.dataArray removeObject:model];
            [strongSelf.tableView beginUpdates];
            [strongSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
            [strongSelf.tableView endUpdates];
        }
        [SVProgressHUD showImage:nil status:responseObject[@"message"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

//删除下载
- (void)deleteDownloadWithModel:(BookDetailModel *)detailModel {
    for (BookChapterModel *chapter in detailModel.chapters) {
        if ([detailModel.download_chapter_idArray containsObject:chapter.l_id]) {
            NSString *urlString = [chapter.l_url decodePlayURL];
            MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader]downloadReceiptForURLString:urlString];
            [[MCDownloader sharedDownloader]remove:receipt completed:nil];
        }
    }
    
    //刷新页面
    NSInteger idx = [_dataArray indexOfObject:detailModel];
    [_dataArray removeObject:detailModel];
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [_tableView endUpdates];
    //更新缓存
    NSString *downloadString = [USERDEFAULTS objectForKey:kDownloadBooks];
    NSArray *temp = [NSArray yy_modelArrayWithClass:[BookDetailModel class] json:downloadString];
    NSMutableArray *bookArray = [NSMutableArray arrayWithArray:temp];
    for (BookDetailModel *obj in bookArray) {
        if ([obj.show_id isEqualToString:detailModel.show_id]) {
            [bookArray removeObject:obj];
            break;
        }
    }
    NSString *down_json = [bookArray yy_modelToJSONString];
    [USERDEFAULTS setObject:down_json forKey:kDownloadBooks];
    [USERDEFAULTS synchronize];
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundView = self.emptyView;
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"SubDownloadCell" bundle:nil] forCellReuseIdentifier:@"SubDownloadCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SubCollectCell" bundle:nil] forCellReuseIdentifier:@"SubCollectCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SubRecentCell" bundle:nil] forCellReuseIdentifier:@"SubRecentCell"];
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf configData];
        }];
    }
    return _tableView;
}

- (ZXEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [ZXEmptyView loadFromNib];
        if (_listType == SubscribeTypeDownload) {
            _emptyView.tip = @"暂无下载记录";
        }else if (_listType == SubscribeTypeCollect){
            _emptyView.tip = @"暂无收藏记录";
        }else if (_listType == SubscribeTypeRecent){
            _emptyView.tip = @"暂无收听记录";
        }else {
            _emptyView.tip = @"";
        }
    }
    return _emptyView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
