//
//  BookDetailModel.h
//  iShuYin
//
//  Created by Apple on 2017/8/14.
//  Copyright © 2017年 ishuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookChapterModel : NSObject
@property (nonatomic, strong) NSString *l_id;//章节id
@property (nonatomic, strong) NSString *l_url;//播放地址
@property (nonatomic ,strong) NSString *l_title;//第几集，第几章节
@property (nonatomic, strong) NSString *l_point;//播放需要的听币
@property (nonatomic, strong) NSString *l_path;//该章节下载后的本地路径
@property (nonatomic, assign) BOOL isSelected;
@end



@interface BookDetailModel : NSObject
@property (nonatomic, strong) NSString *cat_id;
@property (nonatomic, strong) NSString *show_id;
@property (nonatomic, strong) NSString *server_id;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *actor;
@property (nonatomic, strong) NSString *director;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *title_alias;
@property (nonatomic, strong) NSString *title_english;
@property (nonatomic, strong) NSString *title_style;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *pubdate;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *runtime;
@property (nonatomic, strong) NSString *click_count;
@property (nonatomic, strong) NSString *click_time;
@property (nonatomic, strong) NSString *click_month;
@property (nonatomic, strong) NSString *click_week;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *player;
@property (nonatomic, strong) NSString *points;
@property (nonatomic, strong) NSString *moviepoint;
@property (nonatomic, strong) NSString *userspoint;
@property (nonatomic, strong) NSString *attribute;
@property (nonatomic, strong) NSString *is_show;
@property (nonatomic, strong) NSString *is_toupdate;
@property (nonatomic, strong) NSString *is_collected;
@property (nonatomic, strong) NSString *desc;//描述
@property (nonatomic, strong) NSString *detail;//详细
@property (nonatomic, strong) NSArray  *chapters;//章节
@property (nonatomic, strong) NSArray  *actor_books;//作者其他作品
@property (nonatomic, strong) NSArray  *director_books;//播音其他作品

//black list
@property (nonatomic, strong) NSArray *download_chapter_idArray;//本地下载的章节id数组 (数量可能不准确)
@property (nonatomic, assign) NSInteger download_count;//本地下载的章节数量(比较准确)
@property (nonatomic, strong) BookChapterModel *recent_chapter;//最近播放的章节id
@end
