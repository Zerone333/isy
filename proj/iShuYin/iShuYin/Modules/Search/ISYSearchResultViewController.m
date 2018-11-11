//
//  ISYSearchResultViewController.m
//  iShuYin
//
//  Created by ND on 2018/11/11.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYSearchResultViewController.h"
#import "ISYBookListTableViewCell.h"
#import "HomeModel.h"
#import "ISYCategoryDetailTableViewCell.h"
#import "BookDetailViewController.h"
#import "CategoryChildHeader.h"

@interface ISYSearchResultViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger typeIndex;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) UIView *nodataView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ISYSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    self.typeIndex = 0;
    self.pageIndex = 1;
    [self.dataSource addObjectsFromArray:self.firstDataSource];
    [self setupUI];
    
    
}

- (void)setupUI {
    if (self.firstDataSource.count == 0 ) {
        [self.view addSubview:self.nodataView];
        [self.nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.mas_equalTo(100);
        }];
        [self.view addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nodataView.mas_bottom);
            make.left.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
        }];
    } else {
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
        }];
    }
}

#pragma mark - Event
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData:(NSString *)keyWord page:(NSInteger)page {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2BookList];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    NSDictionary *parameter = @{
                      @"page" : @(page),
                      @"sort" : keyWord
                      };
    
    [manager GETWithURLString:url parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            NSArray *temp = [NSArray yy_modelArrayWithClass:[HomeBookModel class] json:responseObject[@"data"]];
            if (page == 1) {
                [strongSelf.dataSource removeAllObjects];
            }
            [strongSelf.dataSource addObjectsFromArray:temp];
            [strongSelf.tableView reloadData];
            strongSelf.pageIndex = page;
            if (temp.count == 0) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else {
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)pushToBookDetailWithIdentity:(NSString *)bookid {
    if ([NSString isEmpty:bookid]) {
        [SVProgressHUD showImage:nil status:@"书本数据有误"];
        return;
    }
    BookDetailViewController *vc = [[BookDetailViewController alloc]init];
    vc.bookid = bookid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeBookModel *model = self.dataSource[indexPath.row];
    ISYCategoryDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISYCategoryDetailTableViewCell cellID]];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeBookModel *model = self.dataSource[indexPath.row];
    [self pushToBookDetailWithIdentity:model.show_id];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ISYBookListTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //    if (!searchBar.text.length) {
    //        return;
    //    }
    //    [searchBar resignFirstResponder];
    //    MoreListViewController *vc = [[MoreListViewController alloc]init];
    //    vc.keyword = searchBar.text;
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return self.hotKeyWords.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ISYSearchViewControllerTextCellID" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [cell.contentView viewWithTag:45354534];
        if (!label) {
            label = [[UILabel alloc] init];
            label.tag = 45354534;
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = kColorValue(0x666666);
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell.contentView);
                make.left.greaterThanOrEqualTo(cell.contentView).mas_offset(8);
                make.right.greaterThanOrEqualTo(cell.contentView).mas_offset(-8);
            }];
            cell.contentView.layer.masksToBounds = YES;
            cell.contentView.layer.cornerRadius = 4;
            cell.contentView.layer.borderWidth = 0.5;
            cell.contentView.layer.borderColor = kColorValue(0x9999999).CGColor;
        }
        NSString *text;
            text = self.hotKeyWords[indexPath.item];
        label.text = text;
        return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        static NSString *reuseId_header = @"CategoryChildHeader";
        CategoryChildHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header forIndexPath:indexPath];
        //        CategoryModel *model = _dataArray[indexPath.section];
        headerView.header = @"热门搜索";
        headerView.backgroundColor =  [UIColor whiteColor];
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        NSString *text;
            text = self.hotKeyWords[indexPath.item];
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
        return CGSizeMake(MIN(size.width + 16, kScreenWidth - 11 * 2), 25);
    
}
#pragma mark - get/set method

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource= self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[ISYCategoryDetailTableViewCell class] forCellReuseIdentifier:[ISYCategoryDetailTableViewCell cellID]];
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf requestData:self.keyWord page:1];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf requestData:self.keyWord page:self.pageIndex + 1 ];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[UIView alloc] init];
        _nodataView.backgroundColor = [UIColor greenColor];
    }
    return _nodataView;
}
#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat space = 11;
        //        CGFloat w = floor((kScreenWidth-kTableViewWidth-5*space)/4.0);
        //        CGFloat h = 40;
        layout.minimumLineSpacing = 11;
        layout.minimumInteritemSpacing = space;
        //        layout.itemSize = CGSizeMake(w, h);
        layout.sectionInset = UIEdgeInsetsMake(16, space, 16, space);
        layout.headerReferenceSize = CGSizeMake(kScreenWidth, 40);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ISYSearchViewControllerTextCellID"];
        [_collectionView registerNib:[UINib nibWithNibName:@"CategoryChildHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategoryChildHeader"];
    }
    return _collectionView;
}
@end
