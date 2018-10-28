//
//  HomeTableCell.m
//  iShuYin
//
//  Created by Apple on 2017/8/6.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "HomeTableCell.h"
#import "HomeLeftCell.h"//靠左对齐
#import "HomeCenterCell.h"//居中对齐
#import "HomeBookModel.h"
#import "ISYBookListTableViewCell.h"

@interface HomeTableCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIButton *refreshButton;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation HomeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _collectionView = [[UICollectionView alloc] init];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeLeftCell" bundle:nil] forCellWithReuseIdentifier:@"HomeLeftCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeCenterCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCenterCell"];
    
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_collectionView);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo([ISYBookListTableViewCell cellHeight] * 3);
    }];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      // haed
        UIView *headView = [[UIView alloc] init];
        [self.contentView addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(33);
        }];
        
        [headView addSubview:self.titleLabel];
        [headView addSubview:self.moreButton];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView).mas_offset(12);
            make.centerY.equalTo(headView);
        }];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headView).mas_offset(-12);
            make.centerY.equalTo(headView);
        }];
        
        
        
        // collection
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.scrollEnabled = NO;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"HomeLeftCell" bundle:nil] forCellWithReuseIdentifier:@"HomeLeftCell"];
        [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCenterCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCenterCell"];
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.mas_bottom);
            make.left.right.equalTo(self.contentView);
            CGFloat itemW = (kScreenWidth-32-18) / 3.0;
            CGFloat itemH = itemW*kCoverProportion + 30.5;
            make.height.mas_equalTo(itemH);
        }];
        
        // tableview
        [self.contentView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo([ISYBookListTableViewCell cellHeight] * 3);
        }];
//
        //bottmom
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(54);
        }];
        
        [bottomView addSubview:self.refreshButton];
        [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bottomView);
            make.size.mas_equalTo(CGSizeMake(80, 44));
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - public
+(CGFloat)cellHeight:(HomeTableCellViewType)cellType {
    if (cellType == HomeTableCellViewType_Collection) {
            CGFloat itemW = (kScreenWidth-32-18) / 3.0;
            CGFloat itemH = itemW*kCoverProportion + 30.5;
        return itemH + 10+28+54;
    } else if (cellType == HomeTableCellViewType_Table) {
        return [ISYBookListTableViewCell cellHeight] * 3 + 10+28+54;
    }
    return 0;
}

- (void)updateDataSource:(NSArray *)dataSource cellType:(HomeTableCellViewType)cellType {
    self.cellType = cellType;
    self.dataArray = dataSource;
    
    if (cellType == HomeTableCellViewType_Collection) {
        _collectionView.hidden = NO;
        self.tableView.hidden = YES;
        [_collectionView reloadData];
    } else if (cellType == HomeTableCellViewType_Table) {
        self.tableView.hidden = NO;
        _collectionView.hidden = YES;
        [self.tableView reloadData];
    }
}

- (void)refreshCategoryTitle:(NSString *)categoryTitle {
    self.titleLabel.text = categoryTitle;
}

#pragma mark - Setter
//- (void)setType:(HomeTableCellType)type {
//    _type = type;
//    _imgView.image = [UIImage imageNamed:@[@"home_recommend",@"home_hot",@"home_new"][type]];
//    _titleLabel.text = @[@"推荐",@"热播",@"最新"][type];
//}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        UIImage *image = [UIImage imageNamed:@"icon-下一步"];
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.backgroundColor = [UIColor redColor];
        [_moreButton setTitle:@"更多 " forState:UIControlStateNormal];
        [_moreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_moreButton setImage:image forState:UIControlStateNormal];
        [_moreButton setTitleColor:kColorValue(0x666666) forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, -image.size.width)];
        [_moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 44, 0, 0)];
    }
    return _moreButton;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setImage:[UIImage imageNamed:@"换一换btn"] forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (_type == HomeTableCellTypeNew) {
//        static NSString *reuse2 = @"HomeLeftCell";
//        HomeLeftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse2 forIndexPath:indexPath];
//        cell.bookModel = _dataArray[indexPath.item];
//        return cell;
//    }else {
        static NSString *reuse1 = @"HomeCenterCell";
        HomeCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse1 forIndexPath:indexPath];
        cell.bookModel = _dataArray[indexPath.item];
        return cell;
//    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (_type == HomeTableCellTypeNew) {
//        CGFloat w = (kScreenWidth-32-6) / 2.0;
//        CGFloat h = w*105/165 + 37.5;
//        return CGSizeMake(w, h);
//    }else {
        CGFloat w = (kScreenWidth-32-18) / 3.0;
        CGFloat h = w*105/80 + 30.5;
        return CGSizeMake(w, h);
//    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 16, 22, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    if (_type == HomeTableCellTypeNew) {
//        return 10;
//    }
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 6;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeBookModel *bookModel = _dataArray[indexPath.item];
    !_bookBlock?:_bookBlock(bookModel.show_id);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ISYBookListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ISYBookListTableViewCell cellID]];
    if (cell == nil) {
        cell = [[ISYBookListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[ISYBookListTableViewCell cellID]];
    }
    
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ISYBookListTableViewCell cellHeight];
}

#pragma mark - Action
- (IBAction)moreBtnClick:(id)sender {
    !_moreBlock?:_moreBlock(nil);
}

- (IBAction)refreshBtnClick:(id)sender {
    !_refreshBlock?:_refreshBlock();
}
@end
