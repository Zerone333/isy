//
//  BookDownloadViewController.m
//  iShuYin
//
//  Created by Apple on 2017/9/6.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookDownloadViewController.h"
#import "ZXEmptyView.h"
#import "BookDownloadCell.h"
#import "BookDetailModel.h"
#import "PlayViewController.h"

@interface BookDownloadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZXEmptyView *emptyView;
@end

@implementation BookDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    [self configData];
    [self configUI];
}

- (void)configData {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *bookPath = [NSString stringWithFormat:@"%@/downloads/%@_%@",document,_detailModel.show_id,_detailModel.title];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:bookPath]) {
        return;
    }
    NSDirectoryEnumerator *enumerator = [fm enumeratorAtPath:bookPath];
    for (NSString *fileName in enumerator) {
        if ([NSString isEmpty:fileName]) {
            continue;
        }
        NSString *cid = [[fileName componentsSeparatedByString:@"_"]firstObject];//章节id
        for (BookChapterModel *chapter in _detailModel.chapters) {
            if ([cid isEqualToString:chapter.l_id]) {
                chapter.l_path = [bookPath stringByAppendingPathComponent:fileName];
                [_dataArray addObject:chapter];
            }
        }
    }
    
    [_dataArray sortUsingComparator:^NSComparisonResult(BookChapterModel *obj1, BookChapterModel *obj2) {
        return [obj1.l_id compare:obj2.l_id options:NSNumericSearch];
    }];
}

- (void)configUI {
    NSString *text = [NSString stringWithFormat:@"%@下载",_detailModel.title];
    self.navigationItem.titleView = [UILabel navigationItemTitleViewWithText:text];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(kNavBarOffset, 0, 0, 0));
    }];
    self.tableView.backgroundView = self.dataArray.count?nil:self.emptyView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"BookDownloadCell";
    BookDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.chapterModel = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        BookChapterModel *chapter = _dataArray[indexPath.row];
        [[ZXTools shareTools]removeFileAtPath:chapter.l_path];
        [strongSelf.dataArray removeObject:chapter];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                         withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
        tableView.backgroundView = strongSelf.dataArray.count?nil:strongSelf.emptyView;
        [strongSelf removeChapterJsonWithIdentity:chapter.l_id];
    }];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BookChapterModel *chapter = _dataArray[indexPath.row];
    for (NSInteger idx = 0; idx < _detailModel.chapters.count; idx++) {
        BookChapterModel *obj = _detailModel.chapters[idx];
        if ([obj.l_id isEqualToString:chapter.l_id]) {
            [APPDELEGATE.playVC playWithBook:_detailModel index:idx];
            if ([self.navigationController.viewControllers containsObject:APPDELEGATE.playVC]) {
                [self.navigationController popToViewController:APPDELEGATE.playVC animated:YES];
            }else {
                [self.navigationController pushViewController:APPDELEGATE.playVC animated:YES];
            }
            break;
        }
    }
}

#pragma mark - Method
- (void)removeChapterJsonWithIdentity:(NSString *)identity {
    NSString *downloadString = [USERDEFAULTS objectForKey:kDownloadBooks];
    NSArray *temp = [NSArray yy_modelArrayWithClass:[BookDetailModel class] json:downloadString];
    NSMutableArray *bookArray = [NSMutableArray arrayWithArray:temp];
    [bookArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BookDetailModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.show_id isEqualToString:_detailModel.show_id]) {
            if ([obj.download_chapter_idArray containsObject:identity]) {
                NSMutableArray *idArray = [NSMutableArray arrayWithArray:obj.download_chapter_idArray];
                [idArray removeObject:identity];
                obj.download_chapter_idArray = idArray;
            }
        }
        if (obj.download_chapter_idArray == nil || obj.download_chapter_idArray.count == 0) {
            [bookArray removeObjectAtIndex:idx];
        }
    }];
    NSString *down_json = [bookArray yy_modelToJSONString];
    [USERDEFAULTS setObject:down_json forKey:kDownloadBooks];
    [USERDEFAULTS synchronize];
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
        _tableView.backgroundView = self.emptyView;
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"BookDownloadCell" bundle:nil] forCellReuseIdentifier:@"BookDownloadCell"];
    }
    return _tableView;
}

- (ZXEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [ZXEmptyView loadFromNib];
        _emptyView.tip = @"暂无下载章节";
    }
    return _emptyView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
