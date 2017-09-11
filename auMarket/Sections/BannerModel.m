//
//  BannerModel.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.shortRequestAddress=@"apiv1.php?act=get_banner";
        self.parseDataClassType = [BannerEntity class];
        self.entity.err_msg=@"未获取到有效的Banner数据";
    }
    return self;
}

-(void)loadBanner{
    self.params = @{};
    [self loadInner];
}


-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[BannerEntity class]]) {
        self.entity = (BannerEntity*)parsedData;
    }
}


-(BannerEntity *)entity{
    if(!_entity){
        _entity=[[BannerEntity alloc] init];
    }
    
    return _entity;
}
@end
