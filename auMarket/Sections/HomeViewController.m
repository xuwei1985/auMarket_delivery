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
    isLoadedMaker=NO;
    showSections=0;
    markerArr=[[NSMutableArray alloc] init];
    parkingMarkerArr=[[NSMutableArray alloc] init];
    predict_time_arr=[[NSMutableArray alloc] init];
    sectionSelArr=[[NSMutableArray alloc] init];
    defaultSectionColor=@"#B4B4B4";
    sectionColorArr=[[NSArray alloc] initWithObjects:@"#743EF4",@"#4A856C",@"#4468F6",@"#E27CB0",@"#92D568",@"#E94D64", nil];
    [self generatePredictTime];
}

//MARK: 构造预计送达时间范围的基础数据
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

//MARK: 预计送达时间视图创建
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

//MARK: 地图视图创建
-(void)createMapView{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-37.8274851
                                                            longitude:144.9527565
                                                                 zoom:13];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled=NO;
    mapView.delegate=self;
    [[mapView settings] setMyLocationButton:NO];
    self.view = mapView;
    
    //地图上添加刷新数据的按钮
    [mapView addSubview:btn_refresh];
    [mapView bringSubviewToFront:btn_refresh];
}

//MARK: 创建地图上的刷新按钮
-(void)createRefreshBtn{
    btn_refresh = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_refresh.frame= CGRectMake(WIDTH_SCREEN-64, HEIGHT_SCREEN-HEIGHT_TAB_BAR-HEIGHT_STATUS_AND_NAVIGATION_BAR-90, 52, 52);
    btn_refresh.backgroundColor = [UIColor whiteColor];
    btn_refresh.layer.cornerRadius=26;
    [btn_refresh addTarget:self action:@selector(clickRefresh:) forControlEvents:UIControlEventTouchUpInside];
    btn_refresh.layer.shadowOpacity = 0.3;
    btn_refresh.layer.shadowColor = [UIColor blackColor].CGColor;
    btn_refresh.layer.shadowOffset = CGSizeMake(2, 3);
    [btn_refresh setImage:[UIImage imageNamed:@"shuaxin.png"] forState:UIControlStateNormal];
}

//MARK: 创建工作状态指示器
-(void)createStateIndicator{
    stateIndicator = [[StateIndicator alloc] initWithFrame:CGRectMake(0, 0, 150, 32)];
}

-(void)initUI{
    [self createStateIndicator];
    [self setNavigation];
    [self createRefreshBtn];
    [self createMapView];
    [self createPredictTimeView];
}

-(void)setNavigation{
    // 前往送达时间提醒按钮
    btn_l_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_l_1.frame= CGRectMake(0, 0, 24, 24);
    btn_l_2.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 4, 0);
    [btn_l_1 setImage:[UIImage imageNamed:@"task"] forState:UIControlStateNormal];
    [btn_l_1 addTarget:self action:@selector(gotoSmsTaskView) forControlEvents:UIControlEventTouchUpInside];
    
    // 数据状态切换按钮
    btn_l_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_l_2.frame= CGRectMake(0, 0, 24, 24);
    [btn_l_2 setImage:[UIImage imageNamed:@"section_time_0"] forState:UIControlStateNormal];
    btn_l_2.imageEdgeInsets = UIEdgeInsetsMake(2, 4, 2, 0);
    [btn_l_2 addTarget:self action:@selector(toggleParkMaker:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btn_left_1 = [[UIBarButtonItem alloc] initWithCustomView:btn_l_1];
    UIBarButtonItem *btn_left_2 = [[UIBarButtonItem alloc] initWithCustomView:btn_l_2];
    NSArray *leftButtonItems = @[btn_left_1, btn_left_2];
    self.navigationItem.leftBarButtonItems =leftButtonItems;
    
    // 前往个人中心按钮
    btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_r.frame= CGRectMake(0, 0, 36, 36);
    [btn_r setImage:[UIImage imageNamed:@"yonghu"] forState:UIControlStateNormal];
    btn_r.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 0);
    [btn_r addTarget:self action:@selector(gotoMemberView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    self.navigationItem.rightBarButtonItem =btn_right;
    
    self.navigationItem.titleView=stateIndicator;
}

//MARK: 观察者通知注册
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskUpdate:) name:TASK_UPDATE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppEnterBackground:) name:APP_DID_ENTER_BACKGROUND object:nil];
}

//MARK: 创建配送时间段选择视图
-(void)createDeliveryTimeSection{
    //sectionArr
    float s_width=(WIDTH_SCREEN-20-10)/2;
    float s_height=36.0f;
    float s_x=20.0;
    float s_y=10.0;

    NSArray *list=APP_DELEGATE.booter.sectionArr;
    for (int i=0; i<list.count; i++) {
        s_x=i%2*((WIDTH_SCREEN-20-10)/2+10)+10;
        s_y=i/2*(s_height+10)+20;
        
        NSString *sectionColor=[sectionColorArr objectAtIndex:i];//匹配对应的颜色值
        
        UIButton *btn=[self.view viewWithTag:7000+i];
        if(btn){
            [btn removeFromSuperview];
        }
            
        UIButton *timeSectionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [timeSectionBtn setTitle:[self formatSectionTime:[list objectAtIndex:i]] forState:UIControlStateNormal];
        timeSectionBtn.tag=7000+i;
        [timeSectionBtn setFrame:CGRectMake(s_x, s_y, s_width, s_height)];
        [timeSectionBtn setImage:[UIImage imageNamed:@"section_location"] forState:UIControlStateNormal];
        timeSectionBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 8, 2, 75);
        timeSectionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -38, 0, 0);
        [timeSectionBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        timeSectionBtn.titleLabel.font=FONT_SIZE_MIDDLE;
        timeSectionBtn.layer.cornerRadius=18;
        timeSectionBtn.clipsToBounds=YES;
        timeSectionBtn.alpha=0.85;
        [timeSectionBtn setBackgroundImage:[UIImage imageWithColor:[Common hexColor:defaultSectionColor]] forState:UIControlStateNormal];
        [timeSectionBtn setBackgroundImage:[UIImage imageWithColor:[Common hexColor:sectionColor]] forState:UIControlStateSelected];
        [timeSectionBtn addTarget:self action:@selector(timeSectionTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:timeSectionBtn];
    }

    if(showSections!=2){
        [self setSectionButtonState:1];//设置按钮都为点亮状态
    }
    else{
        [self setSectionButtonState:0];//设置按钮都为关闭状态
    }
    
}

//MARK: 设置配送时间段选择状态
-(void)setSectionButtonState:(int)mode{
    NSArray *list=APP_DELEGATE.booter.sectionArr;
    if(mode==0){//设置时间段为熄灭
        for (int i=0; i<list.count; i++) {
            UIButton *timeSectionBtn=[self.view viewWithTag:7000+i];
            timeSectionBtn.selected=NO;
            
            if([sectionSelArr containsObject:[NSString stringWithFormat:@"%d",(7000+i)]]){
                [sectionSelArr removeObject:[NSString stringWithFormat:@"%d",(7000+i)]];
            }
        }
    }
    else{//设置时间段为亮起
        BOOL hasCacheSections=NO;
        NSUserDefaults *cache=USER_DEFAULT;
        NSArray *cacheSelArr=[cache objectForKey:@"sectionSelArr"];//记忆的选择的时间段数据
        NSArray *cacheArr=[cache objectForKey:@"sectionArr"];//记忆的所有时间段数据
        
        if(cacheSelArr){
            hasCacheSections=YES;
        }
        
        for (int i=0; i<list.count; i++) {
            UIButton *timeSectionBtn=[self.view viewWithTag:7000+i];
            if(hasCacheSections){
                if([cacheSelArr containsObject:[NSString stringWithFormat:@"%d",(7000+i)]]){
                    timeSectionBtn.selected=YES;
                }
                else{
                    timeSectionBtn.selected=NO;
                }
            }
            else{
                timeSectionBtn.selected=YES;
            }
            if(![sectionSelArr containsObject:[NSString stringWithFormat:@"%d",(7000+i)]]){//未选择过
                if(hasCacheSections){
                    if([cacheArr containsObject:((UIButton *)[self.view viewWithTag:(7000+i)]).titleLabel.text]&&[cacheSelArr containsObject:[NSString stringWithFormat:@"%d",(7000+i)]]){
                        [sectionSelArr addObject:[NSString stringWithFormat:@"%d",(7000+i)]];
                    }
                }
                else{
                    [sectionSelArr addObject:[NSString stringWithFormat:@"%d",(7000+i)]];
                }
            }
        }
        
        [cache removeObjectForKey:@"sectionSelArr"];
        [cache removeObjectForKey:@"sectionArr"];
        [cache synchronize];
        cacheArr=nil;
        cacheSelArr=nil;
    }
}

//MARK: 时段视图点击事件
-(void)timeSectionTap:(UIButton *)sender{
    if(showSections!=2){
        int tag=(int)sender.tag;

        if(!sender.selected){//未选择过
            [sectionSelArr addObject:[NSString stringWithFormat:@"%d",tag]];
            sender.selected=YES;
        }
        else{
            [sectionSelArr removeObject:[NSString stringWithFormat:@"%d",tag]];
            sender.selected=NO;
        }
        [self loadTaskMask:0];
    }
}

//MARK: 时段视图时间格式化
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

//MARK: 时段视图颜色配值
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

//MARK: 加载配送任务地图上的Mask
/**
 model:  0:全部显示订单  1 只显示未设置预计配送到达时间的订单
 **/
-(void)loadTaskMask:(int)model{
    CLLocationCoordinate2D coordinate;
    TaskItemEntity *itemEntity;
    GMSMarker *marker;
    NSString *location_icon=@"";
    BOOL only_unset_predict_order=(model==1); //是否只显示未设置配送排序的订单
    
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
        
        if([self isSectionEnable:[self formatSectionTime:itemEntity.delivery_time]]){
            //判断某个coordinate的marker是否存在
            MapMaker *mapMaker;
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
        MapMaker *mapMaker;
        marker=[self isExistMarker:itemEntity.coordinate andAddress:itemEntity.address];
        
        if(marker==nil){
            mapMaker=[[MapMaker alloc] initWithFrame:CGRectMake(0, 0, 34, 48.5)];
            
            if(showSections!=2){//时段模式，并且该时段按钮点亮的情况
                if([self isSectionEnable:[self formatSectionTime:itemEntity.delivery_time]]){
                    int n=[self getSectionColorIndex:itemEntity.delivery_time];
                    if(n>-1){
                        location_icon=[NSString stringWithFormat:@"1_29_color_%d",n];
                        
                        if([itemEntity.predict_time length]<=0||showSections==0){//未设置预计送达时间
                            if(![itemEntity.upstairs_mark isEqualToString:@"default"]){
                                location_icon=[NSString stringWithFormat:@"%@_%@",location_icon,itemEntity.upstairs_mark];
                            }
                        }
                        else if([itemEntity.predict_time length]>0&&showSections==1){//设置了预计送达时间
                            if([itemEntity.upstairs_mark isEqualToString:@"default"]){//非送货上楼
                                location_icon=@"1_29";
                            }
                            else{//送货上楼
                                location_icon=[NSString stringWithFormat:@"1_29_%@",itemEntity.upstairs_mark];
                            }
                        }
                    }
                    else{
                        location_icon=@"1_29_blue";
                    }
                    mapMaker.image=[UIImage imageNamed:location_icon];
                }
            }
            else{//非时段模式
                if([itemEntity.predict_time length]<=0){//未设置预计送达时间
                    if([itemEntity.upstairs_mark isEqualToString:@"default"]){
                        mapMaker.image=[UIImage imageNamed:@"1_29_blue"];
                    }
                    else{
                        mapMaker.image=[UIImage imageNamed:[NSString stringWithFormat:@"1_29_blue_%@",itemEntity.upstairs_mark]];
                    }
                }
                else{//设置了预计送达时间
                    if([itemEntity.upstairs_mark isEqualToString:@"default"]){//非送货上楼
                        mapMaker.image=[UIImage imageNamed:@"1_29"];
                    }
                    else{//送货上楼
                        mapMaker.image=[UIImage imageNamed:[NSString stringWithFormat:@"1_29_%@",itemEntity.upstairs_mark]];
                    }
                }
            }
            
            if(showSections==2||(showSections!=2&&[self isSectionEnable:[self formatSectionTime:itemEntity.delivery_time]])){//时段模式，并且该时段按钮点亮的情况
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
        }
        else{
            if(showSections==2||(showSections!=2&&[self isSectionEnable:[self formatSectionTime:itemEntity.delivery_time]])){//时段模式，并且该时段按钮点亮的情况
                int n=[((MapMaker *)marker.iconView).markTip intValue];
                if(n<=0){
                    n=1;
                }
                
                ((MapMaker *)marker.iconView).markTip=[NSString stringWithFormat:@"%@",(n+1)>1?[NSString stringWithFormat:@"%d",(n+1)]:@""];
                [((MapMaker *)marker.iconView) loadData];
                
                NSMutableArray *arr=[NSMutableArray arrayWithArray:marker.taskArr];
                [arr addObject:itemEntity];
                marker.taskArr=[[NSMutableArray<TaskItemEntity *> alloc] initWithArray:arr];
                
                //设置预计送达时间状态
                if(showSections==2){//非时间段模式
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
                else{
                    if([self hasMutiTimeSection:marker.taskArr]){
                        ((MapMaker *)marker.iconView).is_muti=YES;
                        ((MapMaker *)marker.iconView).image=[UIImage imageNamed:@"1_29_color_99"];
                    }else{
                        ((MapMaker *)marker.iconView).is_muti=NO;
                    }
                }
            }
        }
    }
}

//MARK: 计算任务队列中是否有多个配送时段
-(BOOL)hasMutiTimeSection:(NSMutableArray<TaskItemEntity *> *)arr{
    NSString *str=@"";
    if(arr&&arr.count>0){
        str=[self formatSectionTime:[arr firstObject].delivery_time];
        for (TaskItemEntity *entity in arr) {
            if(![str isEqualToString:[self formatSectionTime:entity.delivery_time]]){
                return YES;
                break;
            }
        }
    }
    return NO;
}
    
//MARK: 判断某个时间段的按钮是否开启
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


//MARK: 显示停车场的Makers
-(void)showParkingMarkers{
    for (GMSMarker *mk in parkingMarkerArr) {
        mk.map=mapView;
    }
}

//MARK: 隐藏停车场的Makers
-(void)hideParkingMarkers{
    for (GMSMarker *mk in parkingMarkerArr) {
        mk.map= nil;
    }
}

//MARK: 判断是否存在某个Maker
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

//MARK: 选择的预计送达时间的点击事件
-(void)pickerDoneClicked:(id)sender{
    NSInteger row=[predictTimePicker selectedRowInComponent:0];
    predict_select_index=(int)row;
    NSString *valueStr=[predict_time_arr objectAtIndex:row].time_range;
    [self setTaskItemPredictTime:valueStr];
    [_txt_predict resignFirstResponder];
}

//MARK: 设置配送任务的预计送达时间数据到坐标点对象上
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
    [self savePredictTime:ids andPredictTime:t];
}

//MARK: 批量提交订单的预计送达时间的
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
    if(((MapMaker *)marker.iconView).is_muti){
        [self showToastWithText:@"复合订单不能操作"];
        return NO;
    }
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

//MARK: 显示Maker的点击菜单项
- (void)showMaskMenu:(GMSMarker *)marker
{
    selectedMarker=marker;

    UIAlertController *alert_sheet = [UIAlertController alertControllerWithTitle:@"选择操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action_nav = [UIAlertAction actionWithTitle:@"Google导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self runNavigationByGoogle];
    }];
    
    UIAlertAction *action_order = [UIAlertAction actionWithTitle:@"查看订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoOrderDetail];
    }];
    
    UIAlertAction *action_mobile = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TaskItemEntity *item= (TaskItemEntity *)[selectedMarker.taskArr firstObject];
        [self callPhone:item.mobile];
    }];
    
    UIAlertAction *action_order_muti = [UIAlertAction actionWithTitle:@"查看多订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoOrderDetail];
    }];
    
    UIAlertAction *action_address = [UIAlertAction actionWithTitle:@"复制地址" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TaskItemEntity *item= (TaskItemEntity *)[selectedMarker.taskArr firstObject];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = item.address;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showToastWithText:@"复制成功"];
            });
        });
    }];
    
    UIAlertAction *action_sort = [UIAlertAction actionWithTitle:@"配送排序" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPredictTimeView];
    }];
    
    
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了项目1");
    }];
    
    TaskItemEntity *item= (TaskItemEntity *)[selectedMarker.taskArr firstObject];
    BOOL show_predict_menu=true;//是否显示预计配送时间菜单
    if([item.predict_sms_send intValue]>0||[item.status intValue]==2){
        show_predict_menu=false;
    }
    else{
        show_predict_menu=true;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        [alert_sheet addAction:action_nav];
    }
    
    if(marker.taskArr.count<=1){
        if(show_predict_menu){
            [alert_sheet addAction:action_order];
            [alert_sheet addAction:action_mobile];
            [alert_sheet addAction:action_address];
            [alert_sheet addAction:action_sort];
        }
        else{
            [alert_sheet addAction:action_order];
            [alert_sheet addAction:action_mobile];
            [alert_sheet addAction:action_address];
        }
    }
    else{
        if(show_predict_menu){
            [alert_sheet addAction:action_order_muti];
            [alert_sheet addAction:action_address];
            [alert_sheet addAction:action_sort];
        }
        else{
            [alert_sheet addAction:action_order_muti];
            [alert_sheet addAction:action_address];
        }
    }
    
    [self presentViewController:alert_sheet animated:YES completion:nil];
}


//MARK: 显示预计送达时间的选择视图
-(void)showPredictTimeView{
    [_txt_predict becomeFirstResponder];
}

//MARK: 关闭预计送达时间的选择视图
-(void)closePredictTimeView{
    [_txt_predict resignFirstResponder];
}

//MARK: 前往Google地址导航
-(void)runNavigationByGoogle{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@&directionsmode=driving",APP_NAME,APP_SCHEME,selectedMarker.snippet] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else{
        [self showToastBottomWithText:@"您未安装Google Maps"];
    }
}

//MARK: 查看订单详情
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

-(void)clickRefresh:(UIButton *)sender{
    
}

//MARK: 控制时段的订单
-(void)toggleParkMaker:(UIButton *)sender{
    //showSections=0:分时图标不管预计送达的状态 1:分时图标带预计送达的图标 2:关闭分时图标状态
    showSections++;
    if(showSections>2){
        showSections=0;
    }
    [btn_l_2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"section_time_%d",showSections]] forState:UIControlStateNormal];
    
    if(showSections<2){//分时段模式开启
        [self setSectionButtonState:1];//设置时间段为亮起
    }
    else{//分时段模式关闭
        [self setSectionButtonState:0];//设置时间段为熄灭
    }
    
    [self handlerWorkState];
}


-(void)handlerWorkState{
    [self loadTaskMask:0];
//    if(btn_workState.selected){
//
//    }
//    else{
//        [self loadTaskMask:0];
//    }
}

//MARK: 配送数据更新
- (void)onTaskUpdate:(NSNotification*)aNotitification{
    if(isShowing){
        [self createDeliveryTimeSection];
        [self loadTaskMask:0];
    }
}

//MARK: App进入后台事件响应
- (void)onAppEnterBackground:(NSNotification*)aNotitification{
    [self cacheDeliveryData];
}

//MARK: 拨打电话
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

//MARK: 前往预计送达时间短信批量发送界面
-(void)gotoSmsTaskView{
    SmsTaskViewController *svc=[[SmsTaskViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

//MARK: 前往用户个人中心
-(void)gotoMemberView{
    UserCenterViewController *svc=[[UserCenterViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

//MARK: 缓存当前选择的时间段数据
-(void)cacheDeliveryData{
    NSUserDefaults *cache=USER_DEFAULT;
    
    //选择的时间段数据
    [cache setObject:sectionSelArr forKey:@"sectionSelArr"];
    [cache setObject:APP_DELEGATE.booter.sectionArr forKey:@"sectionArr"];
    [cache synchronize];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    isShowing=YES;
    
    //加载配送任务数据
    if([self checkLoginStatus] == YES){
        [APP_DELEGATE.booter loadTaskList];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self cacheDeliveryData];
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
