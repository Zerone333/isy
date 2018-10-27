//
//  GuideViewController.m
//  iShuYin
//
//  Created by Apple on 2017/7/30.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideCell.h"

@interface GuideViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configData];
    [self configUI];
}

- (void)configData {
    _dataArray = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 0; i < 3; i++) {
        [_dataArray addObject:[NSString stringWithFormat:@"guide_%li",(long)i]];
    }
}

- (void)configUI {
    self.view.backgroundColor = kBackgroundColor;
    
    _imgView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _imgView.image = [UIImage imageNamed:@"guide_2"];
    [self.view addSubview:_imgView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    layout.sectionInset = UIEdgeInsetsZero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    [collectionView registerNib:[UINib nibWithNibName:@"GuideCell" bundle:nil] forCellWithReuseIdentifier:@"GuideCell"];
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GuideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GuideCell" forIndexPath:indexPath];
    cell.imgName = _dataArray[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _dataArray.count-1) {
        [collectionView removeFromSuperview];
        collectionView.dataSource = nil;
        collectionView.delegate = nil;
        collectionView = nil;
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _imgView.transform = CGAffineTransformMakeScale(3, 3);
            _imgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            /*
            NSString *mobile = [APPDELEGATE.keyWrapper objectForKey:(__bridge id)kSecAttrAccount];
            NSString *api_token = [APPDELEGATE.keyWrapper objectForKey:(__bridge id)kSecValueData];
            NSString *last_login_time = [USERDEFAULTS objectForKey:kLastLoginTime];
            NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
            if ([last_login_time isKindOfClass:[NSString class]] && last_login_time.doubleValue > 0 &&
                now - last_login_time.doubleValue > 0 && now - last_login_time.doubleValue < 7*24*60*60 &&
                [mobile isKindOfClass:[NSString class]] && ![NSString isEmpty:mobile] &&
                [api_token isKindOfClass:[NSString class]] && ![NSString isEmpty:api_token]) {
                [APPDELEGATE autoLogin];
            }else {
                APPDELEGATE.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:SBVC(@"HomeVC")];
            }
             */
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
