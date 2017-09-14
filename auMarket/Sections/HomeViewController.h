//
//  HomeViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import "MapMaker.h"
#import "GMSMarker+MyGMSMarker.h"

@interface HomeViewController : SPBaseViewController<GMSMapViewDelegate,UIActionSheetDelegate>
{
    GMSMapView *mapView;
    MapMaker *mapMaker;
    CLLocationCoordinate2D sel_coordinate;
    UIButton *btn_workState;
    NSMutableArray<GMSMarker *> *markerArr;
    //Boolean isLoadedMaker;
}
@end
