//
//  GoodsCategoryViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import "GoodsCategoryModel.h"
#import "GoodsCategoryView.h"
#import "GoodsListViewController.h"

@interface GoodsCategoryViewController : SPBaseViewController<GoodsCategoryViewDelegate>
{
    GoodsCategoryView *categoryView;
}
@property(nonatomic,retain)GoodsCategoryModel *model;
@property(nonatomic,retain)GoodsCategoryListEntity *goodsCategory;
@end
