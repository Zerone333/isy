//
//  BookDownloadBottomView.m
//  iShuYin
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "BookDownloadBottomView.h"
#import "BookChapterCountCell.h"
#import "BookDetailModel.h"

@interface BookDownloadBottomView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@end

@implementation BookDownloadBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"BookChapterCountCell" bundle:nil] forCellWithReuseIdentifier:@"BookChapterCountCell"];
}

#pragma mark - Setter
- (void)setIsChooseAll:(BOOL)isChooseAll {
    _isChooseAll = isChooseAll;
    _allBtn.selected = isChooseAll;
}

- (void)setDetailModel:(BookDetailModel *)detailModel {
    _detailModel = detailModel;
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _detailModel.chapters.count/50 + (_detailModel.chapters.count%50 != 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"BookChapterCountCell";
    BookChapterCountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    NSInteger count = (indexPath.item + 1) * 50;
    if (count > _detailModel.chapters.count) {
        count = indexPath.item * 50 + _detailModel.chapters.count%50;
    }
    cell.text = [NSString stringWithFormat:@"%li-%li",indexPath.item*50+1,count];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 36);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 16, 8, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    !_itemBlock?:_itemBlock(indexPath.item);
}

#pragma mark - Actions
//全选
- (IBAction)allBtnClick:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    !_allBlock?:_allBlock(btn.isSelected);
}

//下载
- (IBAction)downloadBtnClick:(id)sender {
    !_downloadBlock?:_downloadBlock();
}

@end
