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
#import "UserCenterViewController.h"
#import "StateIndicator.h"
#import <CoreLocation/CoreLocation.h>

@interface HomeViewController : SPBaseViewController<GMSMapViewDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    GMSMapView *mapView;
    CLLocationCoordinate2D sel_coordinate;
    UIButton *btn_refresh;
    NSMutableArray<GMSMarker *> *markerArr;
    NSMutableArray<GMSMarker *> *parkingMarkerArr;
    NSMutableArray *sectionSelArr; //当前选中的时间段数组
    NSArray *sectionColorArr;
    NSString *defaultSectionColor;
    Boolean isLoadedMaker;
    GMSMarker *selectedMarker;
    UIPickerView *predictTimePicker;
    StateIndicator *stateIndicator;
    Boolean isShowing; //当前界面是否显示中，是否活跃
    UIButton *btn_l_1;
    UIButton *btn_l_2;
    UIButton *btn_r;
    UITextField *_txt_predict;
    int predict_select_index;
    NSMutableArray<PredictTimeEntity *>*predict_time_arr; 
    UISwitch *sectionSwitch;
    int showSections;   //0:分时图标不管预计送达的状态 1:分时图标带预计送达的图标 2:关闭分时图标状态
}
@property(nonatomic,retain) TaskModel *model;
@end

