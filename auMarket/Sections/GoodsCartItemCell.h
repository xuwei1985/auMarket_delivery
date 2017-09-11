//
//  GoodsCategoryParentCell.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/13.
//  Copyright © 2016年 daao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCartEntity.h"

@interface GoodsCartItemCell : UITableViewCell<UITextFieldDelegate>{
    UILabel *_goodsTitleLbl;
    UILabel *_goodsPriceLbl;
    UIImageView *_goodsImageView;
    UITextField *_numText;
}

@property(nonatomic,retain)GoodsCartItemEntity *entity;

@end
