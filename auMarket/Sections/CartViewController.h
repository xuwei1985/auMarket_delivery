//
//  CartViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import "GoodsCartItemCell.h"
#import "GoodsCartModel.h"

@interface CartViewController : SPBaseViewController
{
    UIView *_summaryView;
    UILabel *_goodsCounterLbl;
    UILabel *_totalPriceLbl;
    UIImageView *_postageTipImage;
    UILabel *_postageTipLbl;
    UILabel *_appNameLbl;
}

@property(nonatomic,retain)GoodsCartModel *model;
@end
