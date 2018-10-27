//
//  MoreListViewController.m
//  iShuYin
//
//  Created by Apple on 2017/8/10.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "MoreListViewController.h"
#import "ZXEmptyView.h"
#import "HomeListCell.h"
#import "HomeBookModel.h"
#import "CategoryModel.h"
#import "BookDetailViewController.h"

@interface MoreListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZXEmptyView *emptyView;
@end

@implementation MoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _page = 1;
    _dataArray = [NSMutableArray array];
    [self configUI];
    [self requestData];
}

- (void)configUI {
    self.view.backgroundColor = kBackgroundColor;
    if (_category) {
        self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:_category.cat_name];
    }else if (_keyword.length) {
        self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:_keyword];
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([NSString isEmpty:self.keyword] && self.category == nil) {
            //更多
            make.edges.mas_equalTo(self.view);
        }else {
            //关键字 分类
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(kNavBarOffset, 0, 0, 0));
        }
    }];
}

- (void)requestData {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryHomeMore];
    NSDictionary *params = @{@"page":@(_page),
                             @"type":@(_type),
                             @"category":_category?_category.cat_id:@"",
                             @"sort":_keyword.length?_keyword:@"",
                             };
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager GETWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            if (strongSelf->_page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            NSArray *temp = [NSArray yy_modelArrayWithClass:[HomeBookModel class] json:responseObject[@"data"]];
            [strongSelf.dataArray addObjectsFromArray:temp];
            [strongSelf.tableView reloadData];
            strongSelf.tableView.backgroundView = strongSelf.dataArray.count?nil:strongSelf.emptyView;
        }else {
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"HomeListCell";
    HomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.bookModel = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeBookModel *bookModel = _dataArray[indexPath.row];
    if ([NSString isEmpty:bookModel.show_id]) {
        [SVProgressHUD showImage:nil status:@"书本数据有误"];
        return;
    }
    BookDetailViewController *vc = [[BookDetailViewController alloc]init];
    vc.bookid = bookModel.show_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = self.emptyView;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"HomeListCell" bundle:nil] forCellReuseIdentifier:@"HomeListCell"];
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf->_page = 1;
            [strongSelf requestData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf->_page++;
            [strongSelf requestData];
        }];
    }
    return _tableView;
}

- (ZXEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [ZXEmptyView loadFromNib];
        _emptyView.tip = @"暂无相关书籍";
    }
    return _emptyView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
