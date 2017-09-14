//
//  GMSMarker+MyGMSMarker.m
//  auMarket
//
//  Created by 吴绪伟 on 2017/9/14.
//  Copyright © 2017年 daao. All rights reserved.
//

#import "GMSMarker+MyGMSMarker.h"
static const void *latitudeKey = &latitudeKey;
static const void *longitudeKey = &longitudeKey;

@implementation GMSMarker (MyGMSMarker)
- (double)latitude {
    return [objc_getAssociatedObject(self, latitudeKey) doubleValue];
}

- (void)setLatitude:(double)latitude {
    objc_setAssociatedObject(self, latitudeKey, [NSNumber numberWithDouble:latitude], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (double)longitude {
    return [objc_getAssociatedObject(self, longitudeKey) doubleValue];
}

- (void)setLongitude:(double)longitude {
    objc_setAssociatedObject(self, longitudeKey, [NSNumber numberWithDouble:longitude], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
