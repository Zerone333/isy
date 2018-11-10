//
//  ISYBookTableViewCell.m
//  iShuYin
//
//  Created by ND on 2018/10/27.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import "ISYBookTableViewCell.h"
#import "HomeCenterCell.h"
#import "HomeBookModel.h"
#import "ISYBookListTableViewCell.h"

@interface ISYBookTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ISYBookTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // collection
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.scrollEnabled = NO;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCenterCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCenterCell"];
        [self.contentView addSubview:self.collectionView];
//        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView);
//            make.left.right.equalTo(self.contentView);
//            CGFloat itemW = (kScreenWidth-32-18) / 3.0;
//            CGFloat itemH = itemW*kCoverProportion + 30.5;
//            make.height.mas_equalTo(itemH);
//        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - public
+ (CGFloat)cellHeightForLineCount:(NSInteger)lineCount {
    CGFloat w = (kScreenWidth-32-18) / 3.0;
    CGFloat h = w*105/80 + 30.5;
    return h * lineCount + 32 * lineCount;  // 32collction 边距
}

- (void)updateDataSource:(NSArray *)dataSource  {
    self.dataArray = dataSource;
    _collectionView.hidden = NO;
    [_collectionView reloadData];
}
+ (NSString *)cellID {
    return @"ISYBookTableViewCellID";
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
    CGFloat w = (kScreenWidth-32-18) / 3.0;
    CGFloat h = w*105/80 + 30.5;
    return CGSizeMake(w, h);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsZero;
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
    if (self.itemClickBlock != nil) {
        self.itemClickBlock(bookModel);
    };
}
@end
