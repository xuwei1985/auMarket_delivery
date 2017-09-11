//
//  GoodsCategoryModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/12.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseModel.h"
#import "GoodsCartEntity.h"

@interface GoodsCartModel : SPBaseModel
@property(nonatomic,retain) GoodsCartEntity *entity;

-(void)loadGoodsCart;


@end
