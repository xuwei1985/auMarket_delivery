//
//  GoodsCategoryModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/12.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseModel.h"
#import "GoodsListEntity.h"

@interface GoodsListModel : SPBaseModel
@property(nonatomic,retain) GoodsListEntity *entity;
@property(nonatomic,retain) NSString *tid;
@property(nonatomic,retain) NSString *keyword;
@property(nonatomic,retain) NSString *sort;
@property(nonatomic,retain) NSString *catid;
@property(nonatomic,assign) BOOL hasmore;

-(void)loadGoodsList;


@end
