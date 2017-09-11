//
//  BannerEntity.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseEntity.h"
@class BannerItemEntity;

@interface BannerEntity : SPBaseEntity
@property (nonatomic,retain) NSMutableArray<BannerItemEntity*> *banners;
@end

@interface BannerItemEntity : SPBaseEntity
@property (nonatomic,retain) NSString *src;
@property (nonatomic,retain) NSString *url;
@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) NSString *sort;
@end
