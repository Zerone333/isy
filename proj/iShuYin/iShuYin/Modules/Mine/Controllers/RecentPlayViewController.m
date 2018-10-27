//
//  RecentPlayViewController.m
//  iShuYin
//
//  Created by Apple on 2017/10/10.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "RecentPlayViewController.h"
#import "BookDetailModel.h"
#import "RecentPlayCell.h"
#import "BookDetailViewController.h"
#import "ZXEmptyView.h"

@interface RecentPlayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZXEmptyView *emptyView;
@end

@implementation RecentPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    [self configUI];
    [self configData];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"点播记录"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(kNavBarOffset, 0, 0, 0));
    }];
}

- (void)configData {
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
    static NSString *reuseId = @"RecentPlayCell";
    RecentPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.model = _dataArray[indexPath.row];
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
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
        [_tableView registerNib:[UINib nibWithNibName:@"RecentPlayCell" bundle:nil] forCellReuseIdentifier:@"RecentPlayCell"];
    }
    return _tableView;
}

- (ZXEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [ZXEmptyView loadFromNib];
        _emptyView.tip = @"暂无收听记录";
    }
    return _emptyView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
