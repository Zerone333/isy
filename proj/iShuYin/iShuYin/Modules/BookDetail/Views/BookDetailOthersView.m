//
//  BookDetailOthersView.m
//  iShuYin
//
//  Created by Apple on 2017/8/14.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookDetailOthersView.h"
#import "HomeCenterCell.h"//居中对齐
#import "HomeBookModel.h"

@interface BookDetailOthersView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation BookDetailOthersView

- (void)awakeFromNib {
    [super awakeFromNib];
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeCenterCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCenterCell"];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse1 = @"HomeCenterCell";
    HomeCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse1 forIndexPath:indexPath];
    cell.bookModel = _dataArray[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (kScreenWidth-32-18) / 4.0;
    CGFloat h = w*105/80 + 30.5;
    return CGSizeMake(w, h);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 16, 22, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 6;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeBookModel *bookModel = _dataArray[indexPath.item];
    !_bookBlock?:_bookBlock(bookModel.show_id);
}

- (IBAction)moreBtnClick:(id)sender {
    !_moreBlock?:_moreBlock();
}

@end
