//
//  CommentListViewController.m
//  iShuYin
//
//  Created by Apple on 2017/10/23.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentListCell.h"
#import "CommentListHeader.h"0
#import "CommentListModel.h"
#import "BookDetailModel.h"

@interface CommentListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation CommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _page = 1;
    _dataArray = [NSMutableArray array];
    [self configUI];
    [self requestData];
}

- (void)configUI {
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:@"评论列表"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(kNavBarOffset, 0, 0, 0));
    }];
}

- (void)requestData {
    NSString *pageNo = [NSString stringWithFormat:@"%li",_page];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [ChangyanSDK getTopicComments:self.topic_id pageSize:@"10" pageNo:pageNo orderBy:nil style:nil depth:nil subSize:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        [ZXProgressHUD hide];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (statusCode == CYSuccess) {
            if ([pageNo isEqualToString:@"1"]) {
                [strongSelf.dataArray removeAllObjects];
            }
            id response = [responseStr jsonParse];
            DLog(@"%@", response);
            NSArray *temp = [NSArray yy_modelArrayWithClass:[CommentListModel class] json:response[@"comments"]];
            for (CommentListModel *m in temp) {
                CGFloat h = [m.content boundingRectWithSize:CGSizeMake(kScreenWidth-100, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontSystem(15)} context:nil].size.height;
                m.cellHeight = 126-18+h;
                [strongSelf.dataArray addObject:m];
            }
            [strongSelf.tableView reloadData];
            [strongSelf.tableView.mj_header endRefreshing];
            if (strongSelf.dataArray.count == [response[@"cmt_sum"]integerValue]) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [strongSelf.tableView.mj_footer endRefreshing];
            }
        }else {
            [SVProgressHUD showImage:nil status:@"请求失败"];
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"CommentListCell";
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    __weak __typeof(self)weakSelf = self;
    cell.commentLikeBlock = ^(CommentListModel *m) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf likeCommentWithModel:m];
    };
    cell.listModel = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentListModel *m = _dataArray[indexPath.row];
    return m.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 66.0f;
    }
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CommentListHeader *header = [CommentListHeader loadFromNib];
        __weak __typeof(self)weakSelf = self;
        header.commentBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf editComment];
        };
        return header;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions
- (void)likeCommentWithModel:(CommentListModel *)m {
    __weak __typeof(self)weakSelf = self;
    [ChangyanSDK commentAction:1 topicID:self.topic_id commentID:m.comment_id completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        if (statusCode == CYSuccess) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            m.isLike = YES;
            [strongSelf.tableView beginUpdates];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[strongSelf.dataArray indexOfObject:m] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [strongSelf.tableView endUpdates];
        }
    }];
}

- (void)editComment {
    UIViewController *vc = [ChangyanSDK getPostCommentViewController:@"" topicID:self.topic_id topicSourceID:nil categoryID:nil topicTitle:nil replyPlaceHolder:@"我来说两句"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"CommentListCell" bundle:nil] forCellReuseIdentifier:@"CommentListCell"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
