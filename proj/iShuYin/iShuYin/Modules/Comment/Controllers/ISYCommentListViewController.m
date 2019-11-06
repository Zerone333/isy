//
//  ISYCommentListViewController.m
//  iShuYin
//
//  Created by ND on 2018/11/10.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYCommentListViewController.h"
#import "CommentListModel.h"
#import "ISYCommentTableViewCell.h"

@interface ISYCommentListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *commentDataSource;
@property (nonatomic, strong ) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;

@end

@implementation ISYCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部评论";
    [self.view addSubview:self.tableView];
    self.page = 1;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    [self getcommentListWithBookId:self.bookId page:@(self.page)];
}

- (void)getcommentListWithBookId:(NSString *)bookId page:(NSNumber *)page{
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2getCommentList];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    NSDictionary *params = @{@"show_id":bookId,
                             @"page":page,
                             };
    [manager GETWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            NSArray *commentDataSource = [NSArray yy_modelArrayWithClass:[CommentListModel class] json:responseObject[@"data"]];
            if (page.integerValue == 1) {
                [strongSelf.commentDataSource removeAllObjects];
            }
            [strongSelf.commentDataSource  addObjectsFromArray:commentDataSource];
            [strongSelf.tableView reloadData];
            if (commentDataSource.count > 0) {
                strongSelf.page = page.integerValue;
            }
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

- (void)zanComment:(CommentListModel *)model {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:AddCommentAgree];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    NSDictionary *params = @{@"cmtid":model.comment_id
                             };
    [manager POSTWithURLString:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            model.agree = [NSString stringWithFormat:@"%ld", model.agree.integerValue + 1];
            [self.tableView reloadData];
        } else {
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

#pragma mark - getter
- (NSMutableArray *)commentDataSource {
    if (!_commentDataSource) {
        _commentDataSource = [NSMutableArray array];
    }
    return _commentDataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 120;
        _tableView.rowHeight = UITableViewAutomaticDimension;//iOS8之后默认就是这个值，可以省略
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf getcommentListWithBookId:self.bookId page:@(1)];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf getcommentListWithBookId:self.bookId page:@(self.page + 1)];
        }];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentListModel *model = self.commentDataSource[indexPath.row];
    ISYCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ISYCommentTableViewCellID"];
    if (cell == nil) {
        cell = [[ISYCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ISYCommentTableViewCellID"];
    }
    
    __weak typeof(self) weakSelf = self;
    cell.zanCb = ^(CommentListModel *model) {
        //TODO: 赞
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf zanComment:model];
        
    };
    cell.model = model;
    return cell;
}

@end
