//
//  FeedbackListViewController.m
//  iShuYin
//
//  Created by Apple on 2017/9/19.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "FeedbackListViewController.h"
#import "FeedbackModel.h"
#import "FeedbackCell.h"
#import "FeedbackDetailViewController.h"

@interface FeedbackListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation FeedbackListViewController

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
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.view addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-32);
        make.bottom.mas_equalTo(self.view).offset(-48);
        make.width.equalTo(@(56));
        make.height.equalTo(@(56));
    }];
}

- (void)requestData {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryFeedBackList];
    NSDictionary *params = @{@"msg_type":@(_type),
                             @"page":@(_page),
                             };
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager GETWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id response) {
        DLog(@"%@", response);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response[@"statusCode"]integerValue] == 200) {
            if (strongSelf->_page == 1) {
                [strongSelf.dataArray removeAllObjects];
            }
            NSArray *temp = [NSArray yy_modelArrayWithClass:[FeedbackModel class] json:response[@"data"]];
            [strongSelf.dataArray addObjectsFromArray:temp];
            [strongSelf.tableView reloadData];
        }else {
            [SVProgressHUD showImage:nil status:response[@"message"]];
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
    static NSString *reuseId = @"FeedbackCell";
    FeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedbackModel *model = _dataArray[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        ZXNetworkManager *manager = [ZXNetworkManager shareManager];
        NSString *url = [manager URLStringWithQuery:QueryFeedBackDel];
        NSDictionary *params = @{@"msg_id":model.msg_id};
        __weak __typeof(self)weakSelf = self;
        [ZXProgressHUD showLoading:@""];
        [manager GETWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id response) {
            DLog(@"%@", response);
            if ([response[@"statusCode"]integerValue] == 200) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.dataArray removeObject:model];
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
                [tableView endUpdates];
            }else {
                [SVProgressHUD showImage:nil status:response[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            DLog(@"%@", error.localizedDescription);
            [SVProgressHUD showImage:nil status:error.localizedDescription];
        }];
    }];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FeedbackDetailViewController *vc = [[FeedbackDetailViewController alloc]init];
    vc.model = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action
//添加留言
- (void)addBtnClick:(UIButton *)btn {
    [self.navigationController pushViewController:SBVC(@"FeedbackAddVC") animated:YES];
}

#pragma mark - Getter
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
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"FeedbackCell" bundle:nil] forCellReuseIdentifier:@"FeedbackCell"];
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

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithFrame:CGRectZero
                                      image:@"feedback_add"
                                     target:self
                                     action:@selector(addBtnClick:)];
    }
    return _addBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
