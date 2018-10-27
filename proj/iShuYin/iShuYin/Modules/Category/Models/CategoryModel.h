//
//  CategoryModel.h
//  iShuYin
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject
@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, strong) NSString *cat_id;
@property (nonatomic, strong) NSString *cat_name;
@property (nonatomic, strong) NSString *cat_desc;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *style;
@property (nonatomic, strong) NSString *sort_order;
@property (nonatomic, strong) NSString *is_show;
@property (nonatomic, strong) NSString *show_in_nav;
@property (nonatomic, strong) NSArray  *son_cats;//二级分类
@property (nonatomic, assign) CGFloat  sectionHeight;
@end
