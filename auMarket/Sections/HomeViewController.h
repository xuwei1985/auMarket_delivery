//
//  HomeViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import "MapMaker.h"
#import "PredictTimeEntity.h"
#import "GMSMarker+MyGMSMarker.h"
#import "TaskListViewController.h"
#import "TaskModel.h"
#import "SmsTaskViewController.h"

@interface HomeViewController : SPBaseViewController<GMSMapViewDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    GMSMapView *mapView;
    MapMaker *mapMaker;
    CLLocationCoordinate2D sel_coordinate;
    UIButton *btn_workState;
    NSMutableArray<GMSMarker *> *markerArr;
    NSMutableArray<GMSMarker *> *parkingMarkerArr;
    Boolean isLoadedMaker;
    GMSMarker *selectedMarker;
    UIPickerView *predictTimePicker;
    Boolean isShowing;
    UITextField *_txt_predict;
    int predict_select_index;
    NSMutableArray<PredictTimeEntity *>*predict_time_arr;
}
@property(nonatomic,retain) TaskModel *model;
@end

