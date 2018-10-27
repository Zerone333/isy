//
//  CategoryViewController.m
//  iShuYin
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryModel.h"
#import "CategoryCell.h"
#import "CategoryChildCell.h"
#import "CategoryChildHeader.h"
#import "MoreListViewController.h"

#define kTableViewWidth (0)
@interface CategoryViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    BOOL _isTrigger;//是否是点击tableview触发的collectionview滚动
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation CategoryViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isTrigger = YES;
    _dataArray = [NSMutableArray array];
    [self configUI];
    [self requestData];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"分类"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.mas_top).offset(kNavBarOffset);
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kTabBarOffset);
        make.width.equalTo(@(kTableViewWidth));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.mas_top).offset(kNavBarOffset);
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.tableView.mas_right);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kTabBarOffset);
    }];
}

- (void)requestData {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2Category];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@"加载中"];
    [manager GETWithURLString:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            [strongSelf.dataArray removeAllObjects];
            NSArray *temp = [NSArray yy_modelArrayWithClass:[CategoryModel class] json:responseObject[@"data"]];
            [strongSelf.dataArray addObjectsFromArray:temp];
            [strongSelf.tableView reloadData];
            [strongSelf.collectionView reloadData];
            if (strongSelf.dataArray.count) {
                [strongSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }else {
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"CategoryCell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat y = 0.f;
    for (NSInteger i = 0; i < indexPath.row; i++) {
        CategoryModel *model = _dataArray[i];
        y += model.sectionHeight;
    }
    _isTrigger = YES;
    [self.collectionView scrollRectToVisible:CGRectMake(0, y, kScreenWidth-kTableViewWidth, kScreenHeight-64-49) animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CategoryModel *model = _dataArray[section];
    return model.son_cats.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId_child = @"CategoryChildCell";
    CategoryChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId_child forIndexPath:indexPath];
    CategoryModel *model = _dataArray[indexPath.section];
    cell.model = model.son_cats[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        static NSString *reuseId_header = @"CategoryChildHeader";
        CategoryChildHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header forIndexPath:indexPath];
        CategoryModel *model = _dataArray[indexPath.section];
        headerView.header = model.cat_name;
        headerView.backgroundColor =  [UIColor whiteColor];
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryModel *model = _dataArray[indexPath.section];
    CategoryModel *child = model.son_cats[indexPath.item];
    MoreListViewController *vc = [[MoreListViewController alloc]init];
    vc.category = child;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        if (_isTrigger) {
            return;
        }
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0) {
            NSArray *indexPaths = [self.collectionView indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionHeader];
            if (indexPaths.count) {
                NSIndexPath *topIndexPath = indexPaths[0];
                NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForRow:topIndexPath.section inSection:0];
                [self.tableView selectRowAtIndexPath:destinationIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }else {
            NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
            if (indexPaths.count) {
                NSIndexPath *topIndexPath = indexPaths[0];
                NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForRow:topIndexPath.section inSection:0];
                [self.tableView selectRowAtIndexPath:destinationIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isTrigger = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _isTrigger = NO;
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
        [_tableView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellReuseIdentifier:@"CategoryCell"];
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat space = 16;
        CGFloat w = (kScreenWidth-kTableViewWidth-4*space)/3.0;
        CGFloat h = 40;
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = space;
        layout.itemSize = CGSizeMake(w, h);
        layout.sectionInset = UIEdgeInsetsMake(16, space, 16, space);
        layout.headerReferenceSize = CGSizeMake(kScreenWidth-kTableViewWidth, 40);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerNib:[UINib nibWithNibName:@"CategoryChildCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryChildCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"CategoryChildHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategoryChildHeader"];
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
