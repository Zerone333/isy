//
//  ISYSearchViewController.m
//  iShuYin
//
//  Created by ND on 2018/11/11.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYSearchViewController.h"
#import "HomeModel.h"
#import "CategoryChildHeader.h"
#import "HomeCenterCell.h"
#import "ISYDBManager.h"
#import "ISYSearchResultViewController.h"
#import "HomeBookModel.h"
#import "ISYHeadModel.h"
#import "ISYHeadCollectionReusableView.h"
#import "BookDetailViewController.h"

@interface ISYSearchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *hotKeyWords;
@property (nonatomic, copy) NSArray *historyKeyWords;
@property (nonatomic, copy) NSArray *hotBooks;
@property (nonatomic, copy) UISearchBar *searchBar;
@property (nonatomic, strong) ISYSearchResultViewController *vc;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, copy) NSArray <ISYHeadModel *> *titleArray;
@end

@implementation ISYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    NSArray *array =  [[ISYDBManager shareInstance] querySearchKewords];
    NSLog(@"%@", array);
    self.historyKeyWords = array;
    [self requestData];
}

- (void)setupUI {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"搜索" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = leftItem;
    self.leftButton = leftButton;
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(46, 6, kScreenWidth-46 * 2, 32);
    [bgView addSubview:self.searchBar];
    self.navigationItem.titleView = bgView;
    
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (void)requestData {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery:QueryHomeList];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    [manager POSTWithURLString:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"%@", responseObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            HomeModel *model = [HomeModel yy_modelWithJSON:responseObject[@"data"]];
            strongSelf.hotKeyWords = [model.search_keywords componentsSeparatedByString:@" "];
            strongSelf.hotBooks = model.hot;
            [self.collectionView reloadData];
        }else {
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

- (void)searchData:(NSString *)keyWord page:(NSInteger)page {
    ZXNetworkManager *manager = [ZXNetworkManager shareManager];
    NSString *url = [manager URLStringWithQuery2:Query2BookList];
    __weak __typeof(self)weakSelf = self;
    [ZXProgressHUD showLoading:@""];
    NSDictionary *parameter = @{
                                @"page" : @(page),
                                @"sort" : keyWord,
                                @"jishu_show" : @(1)
                                };
    
    [manager GETWithURLString:url parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        DLog(@"%@", responseObject);
        if ([responseObject[@"statusCode"]integerValue] == 200) {
            NSArray *temp = [NSArray yy_modelArrayWithClass:[HomeBookModel class] json:responseObject[@"data"]];
          ISYSearchResultViewController *vc = [[ISYSearchResultViewController alloc] init];
            vc.keyWord = keyWord;
            vc.firstDataSource = temp;
            vc.hotKeyWords = strongSelf.hotKeyWords;
            [strongSelf addChildViewController:vc];
            [strongSelf.view addSubview:vc.view];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(strongSelf.collectionView);
            }];
            strongSelf.vc = vc;
        }else {
            [SVProgressHUD showImage:nil status:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"%@", error.localizedDescription);
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}
#pragma mark - Event
- (void)rightButtonClick {
    if (self.vc) {
        [self.leftButton setTitle:@"搜索" forState:UIControlStateNormal];
        [self.vc.view removeFromSuperview];
        [self.vc removeFromParentViewController];
        self.vc = nil;
        self.searchBar.text = nil;
    } else {
        if (self.searchBar.text.length == 0) {
            [SVProgressHUD showImage:nil status:@"搜索条件不能为空"];
            return;
        }
        [self searchBarSearchButtonClicked:self.searchBar];
        [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.hotKeyWords.count;
    } else if (section == 1) {
        return self.historyKeyWords.count;
    } else {
        return self.hotBooks.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section <=1) {
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
        if (indexPath.section == 0) {
            text = self.hotKeyWords[indexPath.item];
        } else if (indexPath.section == 1) {
            text = self.historyKeyWords[indexPath.item];
        }
        label.text = text;
        return cell;
    } else {
        static NSString *reuse1 = @"HomeCenterCell";
        HomeCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse1 forIndexPath:indexPath];
        cell.bookModel = self.hotBooks[indexPath.item];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ISYHeadModel *model = self.titleArray[indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        static NSString *reuseId_header = @"ISYHeadCollectionReusableViewid";
        ISYHeadCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header forIndexPath:indexPath];
//        CategoryModel *model = _dataArray[indexPath.section];
        headerView.titleLabel.text = model.titleString;
        headerView.imageView.image = [UIImage imageNamed:model.imageName];
        headerView.backgroundColor =  [UIColor whiteColor];
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section <= 1) {
        NSString *text;
        if (indexPath.section == 0) {
            text = self.hotKeyWords[indexPath.item];
        } else if (indexPath.section == 1) {
            text = self.historyKeyWords[indexPath.item];
        }
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
        return CGSizeMake(MIN(size.width + 16, kScreenWidth - 11 * 2), 25);
    } else {
        CGFloat w = (kScreenWidth-11 * 4) / 3.0;
        CGFloat h = w*105/80 + 30.5;
        return CGSizeMake(floor( w), h);
    }
    
}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section  {
//    return 11;
//}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section <=1) {
        NSString *text;
        if (indexPath.section == 0) {
            text = self.hotKeyWords[indexPath.item];
        } else if (indexPath.section == 1) {
            text = self.historyKeyWords[indexPath.item];
        }
        [self searchData:text page:1];
        if (![self.historyKeyWords containsObject:text]) {
            
            [[ISYDBManager shareInstance] insertSearchKeyword:text];
            [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    } else {
        HomeBookModel *bookModel = self.hotBooks[indexPath.item];
        [self pushBookVC:bookModel.show_id];
    }
}

- (void)pushBookVC:(NSString *)bookID {
    if (self.navigationController) {
        if ([NSString isEmpty:bookID]) {
            [SVProgressHUD showImage:nil status:@"书本数据有误"];
            return;
        }
        BookDetailViewController *vc = [[BookDetailViewController alloc]init];
        vc.bookid = bookID;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (!searchBar.text.length) {
        [SVProgressHUD showImage:nil status:@"搜索条件不能为空"];
        return;
    }
    [searchBar resignFirstResponder];
    //t本地添加搜索关键字
    [[ISYDBManager shareInstance] insertSearchKeyword:searchBar.text];
    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [self searchData:searchBar.text page:1];
//    MoreListViewController *vc = [[MoreListViewController alloc]init];
//    vc.keyword = searchBar.text;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
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
//       [_collectionView registerNib:[UINib nibWithNibName:@"CategoryChildHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategoryChildHeader"];
        [_collectionView registerClass:[ISYHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ISYHeadCollectionReusableViewid"];
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeCenterCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCenterCell"];
    }
    return _collectionView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-46 * 2 - 30, 32)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"关键字";
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

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[[ISYHeadModel itemWithTitleString:@"热门搜索" imageName:@"进度"],
                        [ISYHeadModel itemWithTitleString:@"历史搜索" imageName:@"进度"],
                        [ISYHeadModel itemWithTitleString:@"热播" imageName:@"进度"]];
    }
    return _titleArray;
}
@end
