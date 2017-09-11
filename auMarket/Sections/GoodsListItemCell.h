//
//  GoodsCategoryParentCell.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/13.
//  Copyright © 2016年 daao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListEntity.h"

@interface GoodsListItemCell : UITableViewCell{
    UILabel *_goodsTitleLbl;
    UILabel *_goodsPriceLbl;
    UIImageView *_goodsImageView;
    UIImageView *_cartView;
}

@property(nonatomic,retain)GoodsListItemEntity *entity;

@end
