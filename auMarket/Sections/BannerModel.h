//
//  BannerModel.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseModel.h"
#import "BannerEntity.h"

@interface BannerModel : SPBaseModel
@property (nonatomic,retain) BannerEntity *entity;

-(void)loadBanner;
@end
