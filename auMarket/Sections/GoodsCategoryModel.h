//
//  GoodsCategoryModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/12.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseModel.h"
#import "GoodsCategoryEntity.h"

@interface GoodsCategoryModel : SPBaseModel
@property(nonatomic,retain) GoodsCategoryListEntity *entity;

@property(nonatomic,assign) BOOL hasmore;

-(void)loadGoodsCategory;

-(GoodsCategoryListEntity *)getCategoryCache;

-(void)setCategoryCache:(GoodsCategoryListEntity *)data;
@end
