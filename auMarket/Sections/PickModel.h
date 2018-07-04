//
//  BannerModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "PickEntity.h"

@interface PickModel : SPBaseModel
@property (nonatomic,retain) PickEntity *entity;
-(void)loadPickOrderWithListType:(int)list_type;
-(void)finishPickPackage:(int)type andOrderId:(NSString *)order_id andDeliveryId:(NSString *)delivery_id andPackageType:(NSString *)package_type;
@end
