//
//  LoginModel.h
//  iShuYin
//
//  Created by Apple on 2017/8/17.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *is_validated;
@property (nonatomic, strong) NSString *last_ip;
@property (nonatomic, strong) NSString *lastactivity;
@property (nonatomic, strong) NSString *lastvisit;
@property (nonatomic, strong) NSString *minute;
@property (nonatomic, strong) NSString *msn;
@property (nonatomic, strong) NSString *pay_point;//积分
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *playcount;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *referrer;
@property (nonatomic, strong) NSString *reg_time;
@property (nonatomic, strong) NSString *salt;
@property (nonatomic, strong) NSString *unit_date;//计时会员前期时间
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_money;//余额
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_point;//听币
@property (nonatomic, strong) NSString *user_rank;//用户等级 1计时会员 2计点会员
@property (nonatomic, strong) NSString *usertype;
@property (nonatomic, strong) NSString *visit_count;
@property (nonatomic, strong) NSString *headUrl; //头像地址
@property (nonatomic, strong) NSString *skyuc_sessionhash;//cookie
@end
