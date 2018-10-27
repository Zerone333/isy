//
//  HomeModel.h
//  iShuYin
//
//  Created by Apple on 2017/8/6.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
@property (nonatomic, strong) NSArray *slide;//轮播图
@property (nonatomic, strong) NSArray *recommend;//推荐
@property (nonatomic, strong) NSArray *hot;//热播
@property (nonatomic, strong) NSArray *newest;//新作
@property (nonatomic, strong) NSArray *xiaoshuo;//小说
@property (nonatomic, strong) NSArray *entertain;//娱乐
@property (nonatomic, strong) NSArray *comment;//评书
@property (nonatomic, strong) NSArray *child;//儿童
@property (nonatomic, strong) NSArray *opera;//戏曲
@property (nonatomic, strong) NSArray *today;//
@property (nonatomic, strong) NSArray *week;//
@property (nonatomic, strong) NSArray *month;//


@property (nonatomic, copy) NSString *public_content;//公告
@end
