//
//  ISYCategoryDetailViewController.m
//  iShuYin
//
//  Created by ND on 2018/11/11.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYCategoryDetailViewController.h"
#import "ISYBookListTableViewCell.h"
#import "HomeModel.h"
#import "ISYCategoryDetailTableViewCell.h"
#import "BookDetailViewController.h"
#import "ISYSearchViewController.h"

@interface ISYCategoryDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) HMSegmentedControl *seg;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger typeIndex;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation ISYCategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类详情";
    self.typeIndex = 0;
    self.pageIndex = 1;
    [self setupUI];
    
    [self requestData:0 page:1 category:self.category.cat_id];
  
}

- (void)setupUI {
    
    
    [self addNavBtnWithTitle:@"" color:[UIColor clearColor] target:nil action:nil isLeft:YES];
    [self addNavBtnWithTitle:@"" color:[UIColor clearColor] target:nil action:nil isLeft:NO];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftButton setTitle:[NSString stringWithFormat:@"  %@", self.category.cat_name] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
  
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(46, 6, kScreenWidth-46 * 2, 32);
    [bgView addSubview:self.searchBar];
    self.navigationItem.titleView = bgView;
    
    [self.view addSubview:self.seg];
    [self.view addSubview:self.tableView];
    
    [self.seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    
    UIImageView *adImageView = [[UIImageView alloc] init];
    adImageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:adImageView];
    [adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seg.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(52);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adImageView.mas_bottom);
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

#pragma mark - Event
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData:(NSInteger)typeIndex page:(NSInteger)page category:(NSString *)category{
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2BookList];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
//    type    int    N        1推荐 2热播 3新书 4完结
//    category    int    N        分类id
    NSNumber *typeNumber;
    if (typeIndex == 0) {
        
    } else if (typeIndex == 1) {
        typeNumber = @(1);
    } else if (typeIndex == 2) {
        typeNumber = @(2);
        
    }
    NSDictionary *parameter;
    if (!typeNumber) {
        parameter = @{@"category" : category,
                      @"page" : @(page),
                      @"jishu_show" : @(1)
                      };
    } else {
        parameter = @{@"type" : typeNumber,
                      @"category" : category,
                      @"page" : @(page),
                      @"jishu_show" : @(1)
                      };
    }
    
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
            strongSelf.typeIndex = typeIndex;
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
//    cell.model = model;
    [cell updateModel:model type:1];
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
            [strongSelf requestData:strongSelf.typeIndex page:1 category:self.category.cat_id];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf requestData:strongSelf.typeIndex page:self.pageIndex + 1 category:self.category.cat_id];
        }];
    }
    return _tableView;
}

- (HMSegmentedControl *)seg {
    if (!_seg) {
        _seg = [[HMSegmentedControl alloc]init];
        _seg.backgroundColor = [UIColor whiteColor];
        _seg.selectionIndicatorColor = kMainTone;
        _seg.selectionIndicatorHeight = 1.0;
        _seg.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _seg.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _seg.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _seg.sectionTitles = @[@"分类", @"推荐", @"热播"];
        _seg.selectedTitleTextAttributes = @{NSFontAttributeName:kFontSystem(14),NSForegroundColorAttributeName:kMainTone};
        _seg.titleTextAttributes = @{NSFontAttributeName:kFontSystem(14),NSForegroundColorAttributeName:kColorValue(0x9b9b9b)};
        __weak __typeof(self)weakSelf = self;
        _seg.indexChangeBlock = ^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf requestData:index page:1 category:strongSelf.category.cat_id];
        };
    }
    return _seg;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-46 * 2 - 30, 32)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.tintColor = [UIColor whiteColor];
        
        UIColor *color = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        UIImage *bgImage = [UIImage imageWithColor:color size:CGSizeMake(kScreenWidth-46 * 2, 32)];
        [_searchBar setSearchFieldBackgroundImage:bgImage forState:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"home_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"home_clear"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"home_clear"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
        
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.layer.masksToBounds = YES;
        searchField.layer.cornerRadius = 4.0;
        searchField.textColor= [UIColor whiteColor];
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _searchBar;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
    
    ISYSearchViewController *vc = [[ISYSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}
@end
