//
//  HomeViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//
#define PREDICT_PICKER_HEIGHT 250
#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self addNotification];
}

-(void)initData{
    isExchangeModel=NO;
    isLoadedMaker=NO;
    showSections=YES;
    markerArr=[[NSMutableArray alloc] init];
    parkingMarkerArr=[[NSMutableArray alloc] init];
    predict_time_arr=[[NSMutableArray alloc] init];
    sectionSelArr=[[NSMutableArray alloc] init];
    defaultSectionColor=@"#B4B4B4";
    sectionColorArr=[[NSArray alloc] initWithObjects:@"#0E7ECA",@"#6251BE",@"#C73855",@"#24BF4B",@"#F267EB",@"#CCB857", nil];
    [self generatePredictTime];
}

-(void)generatePredictTime{
    int start_hour=9;
    int end_hour=22;
    int step=90;//结束时间的步进分钟数
    int interval=30;//开始时间的间隔分钟数（2:00-3:30  然后是 2:30-4:00）
    int start_minite=0;
    int end_minite=0;
    int current_start_hour=start_hour;
    int current_end_hour=start_hour;
    
    while ((current_start_hour+step/60)<=end_hour) {
        NSString *minite_str=@"";
        PredictTimeEntity *entity=[[PredictTimeEntity alloc] init];
        if(start_minite<10){
            minite_str=[NSString stringWithFormat:@"0%d",start_minite];
        }
        else{
            minite_str=[NSString stringWithFormat:@"%d",start_minite];
        }
        entity.start_time=[NSString stringWithFormat:@"%d:%@",current_start_hour,minite_str];
        
        end_minite=start_minite+step;
        if(end_minite>=60){
            current_end_hour+=end_minite/60;
            end_minite=end_minite%60;
        }
        if(end_minite<10){
            minite_str=[NSString stringWithFormat:@"0%d",end_minite];
        }
        else{
            minite_str=[NSString stringWithFormat:@"%d",end_minite];
        }
        entity.end_time=[NSString stringWithFormat:@"%d:%@",current_end_hour,minite_str];
        entity.time_range=[NSString stringWithFormat:@"%@ — %@",entity.start_time,entity.end_time];
        [predict_time_arr addObject:entity];
        
        start_minite+=interval;
        if(start_minite>=60){
            current_start_hour+=start_minite/60;
            start_minite=start_minite%60;
        }
        current_end_hour=current_start_hour;
    }
}

-(void)initUI{
    [self setNavigation];
    [self createMapView];
    [self createParkingMask];
    [self createPredictTimeView];
}

-(void)setNavigation{
    UIButton *btn_l = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_l.frame= CGRectMake(0, 0, 32, 32);
    [btn_l setImage:[UIImage imageNamed:@"task"] forState:UIControlStateNormal];
    [btn_l addTarget:self action:@selector(gotoSmsTaskView) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn_r.frame= CGRectMake(0, 0, 32, 32);
//    [btn_r setImage:[UIImage imageNamed:@"1_09"] forState:UIControlStateNormal];
//    [btn_r setImage:[UIImage imageNamed:@"1_21"] forState:UIControlStateSelected];
//    [btn_r addTarget:self action:@selector(toggleParkMaker:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btn_left = [[UIBarButtonItem alloc] initWithCustomView:btn_l];
    self.navigationItem.leftBarButtonItem =btn_left;
    
    sectionSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    sectionSwitch.on = showSections;
    sectionSwitch.transform = CGAffineTransformMakeScale(0.95, 0.95);
    [sectionSwitch addTarget:self action:@selector(sectionSwitchChanged:) forControlEvents:(UIControlEventValueChanged)];
    self.navigationItem.titleView=sectionSwitch;
    
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:sectionSwitch];
    self.navigationItem.rightBarButtonItem =btn_right;
    
    btn_workState = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_workState.frame= CGRectMake(0, 0, 100, 29);
    [btn_workState setBackgroundImage:[UIImage imageNamed:@"1_04"] forState:UIControlStateNormal];
    [btn_workState setBackgroundImage:[UIImage imageNamed:@"1_03"] forState:UIControlStateSelected];
//    [btn_workState setTitle:@"休息中" forState:UIControlStateNormal];
//    [btn_workState setTitle:@"正在接单" forState:UIControlStateSelected];
    [btn_workState setTitle:@"全部订单" forState:UIControlStateNormal];
    [btn_workState setTitle:@"未设置送达时间" forState:UIControlStateSelected];
    btn_workState.titleLabel.font=FONT_SIZE_SMALL;
    [btn_workState setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [btn_workState setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
//    [btn_workState setTitleColor:COLOR_GRAY forState:UIControlStateNormal];
//    [btn_workState setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    [btn_workState addTarget:self action:@selector(toggleWorkState:) forControlEvents:UIControlEventTouchUpInside];
    btn_workState.selected=APP_DELEGATE.isWorking;
    self.navigationItem.titleView=btn_workState;
}


-(void)sectionSwitchChanged:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    if (isButtonOn) {
        sectionSwitch.on = YES;
        showSections=YES;
        [self setSectionButtonState:1];
    }else {
        sectionSwitch.on = NO;
        showSections=NO;
        [self setSectionButtonState:0];
    }
    [self handlerWorkState];
}


-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskUpdate:) name:TASK_UPDATE_NOTIFICATION object:nil];
}

-(void)createDeliveryTimeSection{
    //sectionArr
    float s_width=(WIDTH_SCREEN-20-10)/2;
    float s_height=34.0f;
    float s_x=20.0;
    float s_y=10.0;
    
    self.view.userInteractionEnabled=YES;
    
    NSArray *list=APP_DELEGATE.booter.sectionArr;
    for (int i=0; i<list.count; i++) {
        s_x=i%2*((WIDTH_SCREEN-20-10)/2+10)+10;
        s_y=i/2*(s_height+10)+10;
        UIButton *timeSectionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [timeSectionBtn setTitle:[self formatSectionTime:[list objectAtIndex:i]] forState:UIControlStateNormal];
        timeSectionBtn.tag=7000+i;
        [timeSectionBtn setFrame:CGRectMake(s_x, s_y, s_width, s_height)];
        [timeSectionBtn setImage:[UIImage imageNamed:@"section_location"] forState:UIControlStateNormal];
        timeSectionBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 8, 2, 75);
        timeSectionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -38, 0, 0);
        [timeSectionBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        timeSectionBtn.titleLabel.font=FONT_SIZE_MIDDLE;
        timeSectionBtn.layer.cornerRadius=16;
        timeSectionBtn.clipsToBounds=YES;
        timeSectionBtn.alpha=0.83;
        timeSectionBtn.backgroundColor=[Common hexColor:defaultSectionColor];
        [timeSectionBtn addTarget:self action:@selector(timeSectionTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:timeSectionBtn];
    }
    
    [self setSectionButtonState:1];
}

-(void)setSectionButtonState:(int)mode{
    NSArray *list=APP_DELEGATE.booter.sectionArr;
    if(mode==0){
        for (int i=0; i<list.count; i++) {
            UIButton *timeSectionBtn=[self.view viewWithTag:7000+i];
            [timeSectionBtn setBackgroundColor:[Common hexColor:defaultSectionColor]];
            
            if([sectionSelArr containsObject:[NSString stringWithFormat:@"%d",(7000+i)]]){
                [sectionSelArr removeObject:[NSString stringWithFormat:@"%d",(7000+i)]];
            }
        }
    }
    else{
        for (int i=0; i<list.count; i++) {
            NSString *sectionColor=[sectionColorArr objectAtIndex:i];//匹配对应的颜色值
            UIButton *timeSectionBtn=[self.view viewWithTag:7000+i];
            [timeSectionBtn setBackgroundColor:[Common hexColor:sectionColor]];
            
            if(![sectionSelArr containsObject:[NSString stringWithFormat:@"%d",(7000+i)]]){//未选择过
                [sectionSelArr addObject:[NSString stringWithFormat:@"%d",(7000+i)]];
            }
        }
    }
}

-(void)timeSectionTap:(UIButton *)sender{
    int tag=(int)sender.tag;
    NSString *sectionColor=[sectionColorArr objectAtIndex:(tag-7000)];//匹配对应的颜色值

    if(![sectionSelArr containsObject:[NSString stringWithFormat:@"%d",tag]]){//未选择过
        [sectionSelArr addObject:[NSString stringWithFormat:@"%d",tag]];
        [sender setBackgroundColor:[Common hexColor:sectionColor]];
    }
    else{
        [sectionSelArr removeObject:[NSString stringWithFormat:@"%d",tag]];
        [sender setBackgroundColor:[Common hexColor:defaultSectionColor]];
    }
    [self loadTaskMask:0];
}

-(NSString *)formatSectionTime:(NSString *)sectionTime{
    NSString * str=sectionTime;
    if(str){
        NSArray *array =[str componentsSeparatedByString:@" "];
        if(array){
            return [array lastObject];
        }
        else{
            return @"";
        }
    }
    else{
        return @"";
    }
}

-(int)getSectionColorIndex:(NSString *)time{
    int color= -1;
    NSArray *list=APP_DELEGATE.booter.sectionArr;
    for (int i=0; i<list.count; i++) {
        if([[self formatSectionTime:time] isEqualToString:[self formatSectionTime:[list objectAtIndex:i]]]){
            color = i;
        }
    }
    return color;
}

-(void)createPredictTimeView{
    _txt_predict=[[UITextField alloc] initWithFrame:CGRectZero];
    _txt_predict.delegate=self;
    [self.view addSubview:_txt_predict];
    
    predictTimePicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, HEIGHT_SCREEN-64, WIDTH_SCREEN, PREDICT_PICKER_HEIGHT)];
    predictTimePicker.backgroundColor=COLOR_WHITE;
    //设置阴影的颜色
    predictTimePicker.layer.shadowColor=[UIColor blackColor].CGColor;
    //设置阴影的偏移量，如果为正数，则代表为往右边偏移
    predictTimePicker.layer.shadowOffset=CGSizeMake(0, -5);
    //设置阴影的透明度(0~1之间，0表示完全透明)
    predictTimePicker.layer.shadowOpacity=0.4;
    predictTimePicker.showsSelectionIndicator = YES;
    predictTimePicker.backgroundColor=COLOR_BG_WHITE;
    predictTimePicker.delegate=self;
    predictTimePicker.dataSource=self;
    predictTimePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _txt_predict.inputView=predictTimePicker;
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlackTranslucent;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.barTintColor=COLOR_BG_WHITE;
    keyboardDoneButtonView.tintColor = COLOR_MAIN;
    [keyboardDoneButtonView sizeToFit];
    
    UIView  *line=[[UIView alloc] initWithFrame:CGRectMake(0, keyboardDoneButtonView.frame.size.height-0.5, keyboardDoneButtonView.frame.size.width, 0.5)];
    line.backgroundColor=COLOR_BG_VIEW;
    [keyboardDoneButtonView addSubview:line];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(closePredictTimeView)];
    cancelButton.tintColor=COLOR_DARKGRAY;
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(pickerDoneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton,fixedButton,doneButton, nil]];
    _txt_predict.inputAccessoryView = keyboardDoneButtonView;

}

-(void)createMapView{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-37.8274851
                                                            longitude:144.9527565
                                                                 zoom:12];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.delegate=self;
    [[mapView settings] setMyLocationButton:YES];
    self.view = mapView;
}

-(void)loadTaskMask:(int)model{
    CLLocationCoordinate2D coordinate;
    TaskItemEntity *itemEntity;
    GMSMarker *marker;
    NSString *location_icon=@"";
    BOOL only_unset_predict_order=(model==1);//model:1 只显示未设置预计配送到达时间的订单

    if(markerArr){
        for(int i=0;i<markerArr.count;i++){
            [markerArr objectAtIndex:i].map=nil;
        }
        [markerArr removeAllObjects];
    }
    else{
        markerArr=[[NSMutableArray alloc] init];
    }
    [mapView clear];
    
    
    //配送失败的
    for(int i=0;i<[APP_DELEGATE.booter.tasklist_failed count];i++){
        itemEntity=[APP_DELEGATE.booter.tasklist_failed objectAtIndex:i];
        
        if(only_unset_predict_order&&itemEntity.predict_time.length>0){//只显示未设置配送时间的订单
            break;
        }
        
        coordinate=CLLocationCoordinate2DMake([self reviseDoubleValue:[itemEntity.latitude doubleValue]], [self reviseDoubleValue:[itemEntity.longitude doubleValue]]);
        itemEntity.coordinate=coordinate;//设置配送项目的坐标
        
        //判断某个coordinate的marker是否存在
        marker=[self isExistMarker:itemEntity.coordinate andAddress:itemEntity.address];
        if(marker==nil){
            mapMaker=[[MapMaker alloc] initWithFrame:CGRectMake(0, 0, 34, 48.5)];
            if([itemEntity.upstairs_mark isEqualToString:@"default"]){
                mapMaker.image=[UIImage imageNamed:@"1_29_gray"];
            }
            else{
                mapMaker.image=[UIImage imageNamed:[NSString stringWithFormat:@"1_29_gray_%@",itemEntity.upstairs_mark]];
            }
            
            mapMaker.markTip=@"";
            [mapMaker loadData];
            
            marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(itemEntity.coordinate.latitude, itemEntity.coordinate.longitude);
            marker.title = itemEntity.consignee;
            marker.snippet = itemEntity.address;
            marker.appearAnimation = kGMSMarkerAnimationNone;
            marker.iconView=mapMaker;
            marker.map = mapView;
            marker.latitude=[self reviseDoubleValue:itemEntity.coordinate.latitude];
            marker.longitude=[self reviseDoubleValue:itemEntity.coordinate.longitude];
            marker.taskArr=[[NSMutableArray<TaskItemEntity *> alloc] initWithObjects:itemEntity, nil];
            
            [markerArr addObject:marker];
        }
        else{
            int n=[((MapMaker *)marker.iconView).markTip intValue];
            if(n<=0){
                n=1;
            }
            ((MapMaker *)marker.iconView).markTip=[NSString stringWithFormat:@"%d",n+1];
            [((MapMaker *)marker.iconView) loadData];
            
            NSMutableArray *arr=[NSMutableArray arrayWithArray:marker.taskArr];
            [arr addObject:itemEntity];
            marker.taskArr=[[NSMutableArray<TaskItemEntity *> alloc] initWithArray:arr];
            
            mapMaker.image=[UIImage imageNamed:@"1_29_gray"];
        }
    }
    
    //等待配送的
    for(int i=0;i<[APP_DELEGATE.booter.tasklist_delivering count];i++){
        
        itemEntity=[APP_DELEGATE.booter.tasklist_delivering objectAtIndex:i];
        if(only_unset_predict_order){//只显示未设置配送时间的订单
            if(itemEntity.predict_time.length>0){
                break;
            }
        }
        
        coordinate=CLLocationCoordinate2DMake([self reviseDoubleValue:[itemEntity.latitude doubleValue]], [self reviseDoubleValue:[itemEntity.longitude doubleValue]]);
        itemEntity.coordinate=coordinate;//设置配送项目的坐标
        //判断某个coordinate的marker是否存在
        marker=[self isExistMarker:itemEntity.coordinate andAddress:itemEntity.address];
        if(marker==nil){
            mapMaker=[[MapMaker alloc] initWithFrame:CGRectMake(0, 0, 34, 48.5)];
            
            if(showSections&&[self isSectionEnable:[self formatSectionTime:itemEntity.delivery_time]]){//时段模式，并且该时段按钮点亮的情况
                int n=[self getSectionColorIndex:itemEntity.delivery_time];
                if(n>-1){
                    location_icon=[NSString stringWithFormat:@"1_29_color_%d",n];
                    if([itemEntity.predict_time length]<=0){
                        if(![itemEntity.upstairs_mark isEqualToString:@"default"]){
                            location_icon=[NSString stringWithFormat:@"%@_%@",location_icon,itemEntity.upstairs_mark];
                        }
                    }
                }
                else{
                    location_icon=@"1_29_blue";
                }
                mapMaker.image=[UIImage imageNamed:location_icon];
            }
            else{
                if([itemEntity.predict_time length]<=0){
                    if([itemEntity.upstairs_mark isEqualToString:@"default"]){
                        mapMaker.image=[UIImage imageNamed:@"1_29_blue"];
                    }
                    else{
                        mapMaker.image=[UIImage imageNamed:[NSString stringWithFormat:@"1_29_blue_%@",itemEntity.upstairs_mark]];
                    }
                }
                else{
                    if([itemEntity.upstairs_mark isEqualToString:@"default"]){
                        mapMaker.image=[UIImage imageNamed:@"1_29"];
                    }
                    else{
                        mapMaker.image=[UIImage imageNamed:[NSString stringWithFormat:@"1_29_%@",itemEntity.upstairs_mark]];
                    }
                }
            }
            
            mapMaker.markTip=@"";
            [mapMaker loadData];
            
            marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(itemEntity.coordinate.latitude, itemEntity.coordinate.longitude);
            marker.title = itemEntity.consignee;
            marker.snippet = itemEntity.address;
            marker.appearAnimation = kGMSMarkerAnimationNone;
            marker.iconView=mapMaker;
            marker.map = mapView;
            marker.latitude=[self reviseDoubleValue:itemEntity.coordinate.latitude];
            marker.longitude=[self reviseDoubleValue:itemEntity.coordinate.longitude];
            marker.taskArr=[[NSMutableArray<TaskItemEntity *> alloc] initWithObjects:itemEntity, nil];

            [markerArr addObject:marker];
        }
        else{
            int n=[((MapMaker *)marker.iconView).markTip intValue];
            if(n<=0){
                n=1;
            }
        
            ((MapMaker *)marker.iconView).markTip=[NSString stringWithFormat:@"%@",(n+1)>1?[NSString stringWithFormat:@"%d",(n+1)]:@""];
            [((MapMaker *)marker.iconView) loadData];

            NSMutableArray *arr=[NSMutableArray arrayWithArray:marker.taskArr];
            [arr addObject:itemEntity];
            marker.taskArr=[[NSMutableArray<TaskItemEntity *> alloc] initWithArray:arr];
            
            Boolean has_unPredict=NO;
            for (TaskItemEntity *enity in marker.taskArr) {
                if([enity.predict_time length]<=0){
                    has_unPredict=YES;
                }
            }
            if(has_unPredict){
                mapMaker.image=[UIImage imageNamed:@"1_29_blue"];
            }
            else{
                mapMaker.image=[UIImage imageNamed:@"1_29"];
            }
        }
    }
    isExchangeModel=NO;
}

//判断某个时间段的按钮是否开启
-(BOOL)isSectionEnable:(NSString *)timeStr{
    NSArray *list=APP_DELEGATE.booter.sectionArr;
    for(int i=0;i<list.count;i++){
        if([[list objectAtIndex:i] isEqualToString:timeStr]){
            int tag=7000+i;
            if([sectionSelArr containsObject:[NSString stringWithFormat:@"%d",tag]]){
                return YES;
            }
            break;
        }
    }
    return NO;
}

//创建停车场的Marker
-(void)createParkingMask{
    CLLocationCoordinate2D coordinate;
    ParkingItemEntity *itemEntity;
    GMSMarker *marker;
    
    if(parkingMarkerArr){
        [parkingMarkerArr removeAllObjects];
    }
    else{
        parkingMarkerArr=[[NSMutableArray alloc] init];
    }

    for(int i=0;i<[APP_DELEGATE.booter.parkinglist count];i++){
        itemEntity=[APP_DELEGATE.booter.parkinglist objectAtIndex:i];
        coordinate=CLLocationCoordinate2DMake([self reviseDoubleValue:[itemEntity.latitude doubleValue]], [self reviseDoubleValue:[itemEntity.longitude doubleValue]]);
        marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.icon=[UIImage imageNamed:@"1_32"];
        marker.map = nil;
        
        [parkingMarkerArr addObject:marker];
    }
}

-(void)showParkingMarkers{
    for (GMSMarker *mk in parkingMarkerArr) {
        mk.map=mapView;
    }
}

-(void)hideParkingMarkers{
    for (GMSMarker *mk in parkingMarkerArr) {
        mk.map= nil;
    }
}

-(GMSMarker *)isExistMarker:(CLLocationCoordinate2D)coordinate andAddress:(NSString *)addr{
    GMSMarker *mArr=nil;
    if(markerArr){
//        NSString *filterStr=[NSString stringWithFormat:@"latitude=%f AND longitude=%f",coordinate.latitude,coordinate.longitude];
//        NSPredicate *predicate=[NSPredicate predicateWithFormat:filterStr];
//        mArr=[markerArr filteredArrayUsingPredicate:predicate];
        for(int i=0;i<markerArr.count;i++){
            if(([[NSString stringWithFormat:@"%.4f",[markerArr objectAtIndex:i].latitude] isEqualToString:[NSString stringWithFormat:@"%.4f",coordinate.latitude]])&&([[NSString stringWithFormat:@"%.4f",[markerArr objectAtIndex:i].longitude] isEqualToString:[NSString stringWithFormat:@"%.4f",coordinate.longitude]])){
                mArr= [markerArr objectAtIndex:i];
                break;
            }
        }
        
        if(mArr!=nil){
            return mArr;
        }
        else{
            for(int i=0;i<markerArr.count;i++){
                if([markerArr objectAtIndex:i].snippet==addr){
                    return [markerArr objectAtIndex:i];
                    break;
                }
            }
        }
    }

    return nil;
}

-(double)reviseDoubleValue:(double)conversionValue{
    /* 直接传入精度丢失有问题的Double类型*/
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    double d=[decNumber doubleValue];
    return d;
}

-(void)pickerDoneClicked:(id)sender{
    NSInteger row=[predictTimePicker selectedRowInComponent:0];
    predict_select_index=(int)row;
    NSString *valueStr=[predict_time_arr objectAtIndex:row].time_range;
    [self setTaskItemPredictTime:valueStr];
    [_txt_predict resignFirstResponder];
}

//设置配送任务的预计送达时间数据到坐标点对象上
-(void)setTaskItemPredictTime:(NSString *)t{
    NSMutableString *ids=[NSMutableString string];
    if(selectedMarker&&selectedMarker.taskArr){
        for (int i=0; i<selectedMarker.taskArr.count; i++) {
            [ids appendFormat:@"%@,",[selectedMarker.taskArr objectAtIndex:i].sid];
            [selectedMarker.taskArr objectAtIndex:i].predict_time=t;
        }
    }
    
    if(ids.length>0){
        ids=[NSMutableString stringWithString:[ids substringToIndex:ids.length-1]];
    }
    
    [self loadTaskMask:0];
    
//    NSLog(@"ids:%@",ids);
    [self savePredictTime:ids andPredictTime:t];
}

-(void)savePredictTime:(NSString *)ids andPredictTime:(NSString *)predict_time{
    [self startLoadingActivityIndicatorWithText:@"提交数据"];
    [self.model savePredictTime:ids andPredictTime:predict_time];
}

-(void)onResponse:(TaskModel *)model isSuccess:(BOOL)isSuccess{
    [self stopLoadingActivityIndicator];
    if(model.requestTag==3001){
        if(isSuccess){
            [self showToastWithText:@"保存成功"];
        }
    }
}
#pragma mark UIGestureRecognizerClick

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
    
}

#pragma mark - picker view delegate

/* return column of pickerview*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/*return row number*/
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return predict_time_arr.count;
}

/*return component row str*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [predict_time_arr objectAtIndex:row].time_range;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor=16.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:DEFAULT_FONT(18)];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return WIDTH_SCREEN;
}

-(CGFloat) pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component{
    return 48;
}

/*choose com is component,row's function*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    predict_select_index=(int)row;//保存区域类型
//    NSString *valueStr=[predict_time_arr objectAtIndex:row].time_range;
}


#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    NSLog(@"didTapInfoWindowOfMarker");
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
//    if(marker.appearAnimation==kGMSMarkerAnimationNone){
//        sel_coordinate=marker.position;
//        [self showMaskMenu:marker];
//        return YES;
//    }
//    else{
//        sel_coordinate=marker.position;
//        [self showMaskMenu:marker];
//        return YES;
//    }
    
    sel_coordinate=marker.position;
    [self showMaskMenu:marker];
    return YES;
    
}

- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView{
    NSLog(@"mapViewDidFinishTileRendering");
}

-(void)mapViewDidStartTileRendering:(GMSMapView *)mapView{
    if(!isLoadedMaker){
        isLoadedMaker=YES;
        [self loadTaskMask:0];
    }
}

- (void)showMaskMenu:(GMSMarker *)marker
{
    selectedMarker=marker;
    UIActionSheet *actionsheet;
    
    TaskItemEntity *item= (TaskItemEntity *)[selectedMarker.taskArr firstObject];
    BOOL show_predict_menu=true;//是否显示预计配送时间菜单
    if([item.predict_sms_send intValue]>0||[item.status intValue]==2){
        show_predict_menu=false;
    }
    else{
        show_predict_menu=true;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        
        if(marker.appearAnimation==kGMSMarkerAnimationNone){
            if(marker.taskArr.count<=1){
                if(show_predict_menu){
                    actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"Google导航", @"查看订单",@"拨打电话",@"复制地址", @"预计送达时间", nil,nil];
                }
                else{
                    actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"Google导航", @"查看订单",@"拨打电话",@"复制地址", nil,nil];
                }
            }
            else{
                if(show_predict_menu){
                    actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"Google导航", @"查看多个订单",@"复制地址", @"预计送达时间", nil,nil];
                }
                else{
                    actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"Google导航", @"查看多个订单",@"复制地址", nil,nil];
                }
            }
        }
        else{//停车点
            actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"Google导航", nil,nil];
        }
    }
    else{
        if(marker.appearAnimation==kGMSMarkerAnimationNone){
            if(marker.taskArr.count<=1){
                if(show_predict_menu){
                    actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"查看订单",@"拨打电话",@"复制地址", @"预计送达时间",nil,nil];
                }
                else{
                    actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"查看订单",@"拨打电话",@"复制地址",nil,nil];
                }
            }
            else{
                if(show_predict_menu){
                    actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"查看多个订单",@"复制地址", @"预计送达时间", nil,nil];
                }
                else{
                    actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"查看多个订单",@"复制地址", nil,nil];
                }
            }
        }
    }
    
    [actionsheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Google导航"])
    {
        [self runNavigationByGoogle];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"查看订单"]||[[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"查看多个订单"])
    {
        [self gotoOrderDetail];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"拨打电话"])
    {
        TaskItemEntity *item= (TaskItemEntity *)[selectedMarker.taskArr firstObject];
        [self callPhone:item.mobile];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"复制地址"])
    {
        TaskItemEntity *item= (TaskItemEntity *)[selectedMarker.taskArr firstObject];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = item.address;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showToastWithText:@"复制成功"];
            });
        });
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"预计送达时间"])
    {
        [self showPredictTimeView];
    }
}

-(void)showPredictTimeView{
    [_txt_predict becomeFirstResponder];
}

-(void)closePredictTimeView{
    [_txt_predict resignFirstResponder];
}


-(void)runNavigationByGoogle{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
//        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",APP_NAME,APP_SCHEME,sel_coordinate.latitude, sel_coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@&directionsmode=driving",APP_NAME,APP_SCHEME,selectedMarker.snippet] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else{
        [self showToastBottomWithText:@"您未安装Google Maps"];
    }
}

-(void)gotoOrderDetail{
    if(selectedMarker.taskArr.count>1){
        TaskListViewController *tvc=[[TaskListViewController alloc] init];
        tvc.taskArr=selectedMarker.taskArr;
        [self.navigationController pushViewController:tvc animated:YES];
    }
    else{
        OrderDetailViewController *ovc=[[OrderDetailViewController alloc] init];
        ovc.task_entity=[selectedMarker.taskArr firstObject];
        [self.navigationController pushViewController:ovc animated:YES];
    }
}

-(void)unusualList:(UIButton *)sender{
    
}

-(void)toggleParkMaker:(UIButton *)sender{
    sender.selected=!sender.selected;
    if(sender.selected){
        [self showParkingMarkers];
    }
    else{
        [self hideParkingMarkers];
    }
}

-(void)toggleWorkState:(UIButton *)sender{
    if(!isExchangeModel){
        btn_workState.selected=!btn_workState.selected;
        [APP_DELEGATE.booter handlerWorkingState:btn_workState.selected];
        [self handlerWorkState];
    }
}

-(void)handlerWorkState{
    if(btn_workState.selected){
        isExchangeModel=YES;
        [self loadTaskMask:1];
    }
    else{
        isExchangeModel=YES;
        [self loadTaskMask:0];
    }
}

//配送数据更新
- (void)onTaskUpdate:(NSNotification*)aNotitification{
    if(isShowing){
        [self createDeliveryTimeSection];
        [self loadTaskMask:0];
    }
}

-(void)callPhone:(NSString *)phone{
    if(phone!=nil&&phone.length>0){
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
    else{
        [self showToastWithText:@"无效的电话号码"];
    }
}

-(void)gotoSmsTaskView{
    SmsTaskViewController *svc=[[SmsTaskViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isShowing=YES;
    btn_workState.selected=APP_DELEGATE.isWorking;
    [APP_DELEGATE.booter loadTaskList];
//    [self checkLoginStatus];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    isShowing=NO;
}


-(TaskModel *)model{
    if(!_model){
        _model=[[TaskModel alloc] init];
        _model.delegate=self;
    }
    return _model;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
