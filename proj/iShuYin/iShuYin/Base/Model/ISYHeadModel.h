//
//  ISYHeadModel.h
//  iShuYin
//
//  Created by ND on 2018/11/13.
//  Copyright © 2018年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISYHeadModel : NSObject
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *imageName;
+(instancetype)itemWithTitleString:(NSString *)titleString imageName:(NSString *)imageName;
@end
