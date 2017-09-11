//
//  GoodsCategoryEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/12.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
@class GoodsCategoryEntity;

@interface GoodsCategoryListEntity : SPBaseEntity
@property(nonatomic,retain) NSMutableArray <GoodsCategoryEntity *>*categorylist;
@property(nonatomic,retain) NSMutableArray<GoodsCategoryEntity *>*firstCategoryArr;
@property(nonatomic,retain) NSMutableDictionary *secondCategoryDic;
@property(nonatomic,retain) NSMutableDictionary *thirdCategoryDic;
@end

@interface GoodsCategoryEntity : SPBaseEntity

@property(nonatomic,retain) NSString *cat_id;
@property(nonatomic,retain) NSString *cat_name;
@property(nonatomic,retain) NSString *keywords;
@property(nonatomic,retain) NSString *cat_desc;
@property(nonatomic,retain) NSString *parent_id;
@property(nonatomic,retain) NSString *sort_order;
@property(nonatomic,retain) NSString *template_file;
@property(nonatomic,retain) NSString *measure_unit;
@property(nonatomic,retain) NSString *show_in_nav;
@property(nonatomic,retain) NSString *style;
@property(nonatomic,assign) BOOL is_show;
@property(nonatomic,retain) NSString *grade;
@property(nonatomic,retain) NSString *filter_attr;
@property(nonatomic,retain) NSString *category_index;
@property(nonatomic,retain) NSString *show_in_index;
@property(nonatomic,retain) NSString *cat_index_rightad;
@property(nonatomic,retain) NSString *cat_adimg_1;
@property(nonatomic,retain) NSString *cat_adurl_1;
@property(nonatomic,retain) NSString *cat_adimg_2;
@property(nonatomic,retain) NSString *cat_adurl_2;
@property(nonatomic,retain) NSString *cat_nameimg;
@property(nonatomic,retain) NSString *thumb;
@end
