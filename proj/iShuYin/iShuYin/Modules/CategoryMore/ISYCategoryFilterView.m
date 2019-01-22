//
//  ISYCategoryFilterView.m
//  iShuYin
//
//  Created by 李艺真 on 2018/12/15.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYCategoryFilterView.h"
#import "CategoryModel.h"
#import "ISYCategoryMoreHeadView.h"
#import "ISYCategoryFilterCollectionCell.h"

@interface ISYCategoryFilterView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) NSArray *array;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, weak) ISYCategoryMoreHeadView *dataMoreView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ISYCategoryFilterView


+ (instancetype)viewWithArray:(NSArray *)arrar selectIndex:(NSInteger)selectIndex title:(NSString *)title icon:(NSString *)icon {
    ISYCategoryFilterView *view = [[ISYCategoryFilterView alloc] init];
    view.array = arrar;
    view.selectIndex = selectIndex;
    view.dataMoreView.imageView.image = [UIImage imageNamed:icon];
    view.dataMoreView.titleLabel.text = title;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.headView];
        [self addSubview:self.collectionView];
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(44);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.top.equalTo(self.headView.mas_bottom);
        }];
    }
    return self;
}
#pragma mark - event
- (void)closeButtonClick {
    if (self.dismissBlock) {
        self.dismissBlock(self.selectIndex);
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *reuseId_child = @"ISYCategoryFilterCollectionCell";
    ISYCategoryFilterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId_child forIndexPath:indexPath];
    cell.title = self.array[indexPath.item];
    cell.selected = indexPath.item == self.selectIndex;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
   if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        static NSString *reuseId_header = @"ISYCategoryMoreHeadViewid";
        ISYCategoryMoreHeadView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseId_header forIndexPath:indexPath];
        
        view.imageView.image = [UIImage imageNamed:@"detail_like_nor"];
        view.titleLabel.text = @"排序";
        return view;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        self.categorySelectIndex = indexPath.row;
//    } else {
//        self.sortSelectIndex = indexPath.row;
//    }
    self.selectIndex = indexPath.item;
//    [self.collectionView reloadData];
    [self closeButtonClick];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
        return CGSizeZero;
//    } else {
//        return CGSizeMake(kScreenWidth, 40);
//    }
}

#pragma mark - getter
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] init];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kColorValue(0x999999);
        [_headView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(38);
            make.width.mas_equalTo(2);
            make.left.centerY.equalTo(_headView);
            
        }];
        
        UIImageView *rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ph_down"]];
        [_headView addSubview:rightImage];

        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headView);
            make.right.equalTo(_headView).mas_offset(-4);
        }];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTitle:@"收起" forState:UIControlStateNormal];
        [closeButton setTitleColor:kColorValue(0x333333) forState:UIControlStateNormal];
        closeButton.titleLabel.font = kFontSystem(16);
        [_headView addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_headView);
            make.width.mas_equalTo(80);
        }];
        
        ISYCategoryMoreHeadView *view = [[ISYCategoryMoreHeadView alloc] init];
        view.imageView.image = [UIImage imageNamed:@"detail_like_nor"];
        view.titleLabel.text = @"筛选/分类";
        [_headView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_headView);
            make.right.equalTo(closeButton.mas_left);
        }];
        _dataMoreView = view;
    }
    return _headView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.minimumLineSpacing = 0;
//        layout.minimumInteritemSpacing = 0;
//        layout.sectionInset = UIEdgeInsetsZero;
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        _collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat space = 16;
        CGFloat w = floor((kScreenWidth-4*space)/3.0);
        CGFloat h = 40;
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = space;
        layout.itemSize = CGSizeMake(w, h);
        layout.sectionInset = UIEdgeInsetsMake(16, space, 16, space);
        layout.headerReferenceSize = CGSizeMake(kScreenWidth, 40);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[ISYCategoryFilterCollectionCell class] forCellWithReuseIdentifier:@"ISYCategoryFilterCollectionCell"];
        
        [_collectionView registerClass:[ISYCategoryMoreHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ISYCategoryMoreHeadViewid"];
        
    }
    return _collectionView;
}

@end
