//
//  GoodsCategoryModel.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/12.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "GoodsCartModel.h"


@implementation GoodsCartModel

-(instancetype)init{
    self = [super init];
    if (self) {
        SPAccount *_account=[[AccountManager sharedInstance] getCurrentUser];
        self.shortRequestAddress=[NSString stringWithFormat:@"apiv1.php?act=cart_list&user_id=%@",_account.user_id];
        self.parseDataClassType = [GoodsCartEntity class];
        self.entity.err_msg=@"未获取到有效的购物车数据";
    }
    return self;
}

-(void)loadGoodsCart{
    SPAccount *_account=[[AccountManager sharedInstance] getCurrentUser];
    
//    self.params = @{
//        @"user_id":_account.user_id
//    };
    [self loadInner];
}

-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[GoodsCartEntity class]]) {
        self.entity = (GoodsCartEntity*)parsedData;
    }
}


-(GoodsCartEntity *)entity{
    if(!_entity){
        _entity=[[GoodsCartEntity alloc] init];
    }
    
    return _entity;
}
@end
