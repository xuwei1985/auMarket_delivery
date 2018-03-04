//
//  HomeViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

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
    markerArr=[[NSMutableArray alloc] init];
    parkingMarkerArr=[[NSMutableArray alloc] init];
}

-(void)initUI{
    [self setNavigation];
    [self createMapView];
    [self createParkingMask];
}

-(void)setNavigation{
    UIButton *btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_r.frame= CGRectMake(0, 0, 32, 32);
    [btn_r setImage:[UIImage imageNamed:@"1_09"] forState:UIControlStateNormal];
    [btn_r setImage:[UIImage imageNamed:@"1_21"] forState:UIControlStateSelected];
    [btn_r addTarget:self action:@selector(toggleParkMaker:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    self.navigationItem.rightBarButtonItem =btn_right;
    
    btn_workState = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_workState.frame= CGRectMake(0, 0, 95, 29);
    [btn_workState setBackgroundImage:[UIImage imageNamed:@"1_04"] forState:UIControlStateNormal];
    [btn_workState setBackgroundImage:[UIImage imageNamed:@"1_03"] forState:UIControlStateSelected];
    [btn_workState setTitle:@"休息中" forState:UIControlStateNormal];
    [btn_workState setTitle:@"正在接单" forState:UIControlStateSelected];
    btn_workState.titleLabel.font=FONT_SIZE_MIDDLE;
    [btn_workState setTitleColor:COLOR_GRAY forState:UIControlStateNormal];
    [btn_workState setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    [btn_workState addTarget:self action:@selector(toggleWorkState:) forControlEvents:UIControlEventTouchUpInside];
    btn_workState.selected=APP_DELEGATE.isWorking;
    self.navigationItem.titleView=btn_workState;
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskUpdate:) name:TASK_UPDATE_NOTIFICATION object:nil];
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

-(void)loadTaskMask{
    CLLocationCoordinate2D coordinate;
    TaskItemEntity *itemEntity;
    GMSMarker *marker;

    if(markerArr){
        for(int i=0;i<markerArr.count;i++){
            [markerArr objectAtIndex:i].map=nil;
        }
        [markerArr removeAllObjects];
    }
    else{
        markerArr=[[NSMutableArray alloc] init];
    }
    
    
    //配送失败的
    for(int i=0;i<[APP_DELEGATE.booter.tasklist_failed count];i++){
        itemEntity=[APP_DELEGATE.booter.tasklist_failed objectAtIndex:i];
        coordinate=CLLocationCoordinate2DMake([self reviseDoubleValue:[itemEntity.latitude doubleValue]], [self reviseDoubleValue:[itemEntity.longitude doubleValue]]);
        itemEntity.coordinate=coordinate;//设置配送项目的坐标
        
        //判断某个coordinate的marker是否存在
        marker=[self isExistMarker:itemEntity.coordinate andAddress:itemEntity.address];
        if(marker==nil){
            mapMaker=[[MapMaker alloc] initWithFrame:CGRectMake(0, 0, 34, 48.5)];
            mapMaker.image=[UIImage imageNamed:@"1_29_gray"];
            mapMaker.markTip=@"1";
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
            ((MapMaker *)marker.iconView).markTip=[NSString stringWithFormat:@"%d",[((MapMaker *)marker.iconView).markTip intValue]+1];
            [((MapMaker *)marker.iconView) loadData];
            
            NSMutableArray *arr=[NSMutableArray arrayWithArray:marker.taskArr];
            [arr addObject:itemEntity];
            marker.taskArr=[[NSMutableArray<TaskItemEntity *> alloc] initWithArray:arr];
        }
    }
    
    //等待配送的
    for(int i=0;i<[APP_DELEGATE.booter.tasklist_delivering count];i++){
        itemEntity=[APP_DELEGATE.booter.tasklist_delivering objectAtIndex:i];
        coordinate=CLLocationCoordinate2DMake([self reviseDoubleValue:[itemEntity.latitude doubleValue]], [self reviseDoubleValue:[itemEntity.longitude doubleValue]]);
        itemEntity.coordinate=coordinate;//设置配送项目的坐标
        
        //判断某个coordinate的marker是否存在
        marker=[self isExistMarker:itemEntity.coordinate andAddress:itemEntity.address];
        if(marker==nil){
            mapMaker=[[MapMaker alloc] initWithFrame:CGRectMake(0, 0, 34, 48.5)];
            mapMaker.image=[UIImage imageNamed:@"1_29"];
            mapMaker.markTip=@"1";
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
            ((MapMaker *)marker.iconView).markTip=[NSString stringWithFormat:@"%d",[((MapMaker *)marker.iconView).markTip intValue]+1];
            [((MapMaker *)marker.iconView) loadData];

            NSMutableArray *arr=[NSMutableArray arrayWithArray:marker.taskArr];
            [arr addObject:itemEntity];
            marker.taskArr=[[NSMutableArray<TaskItemEntity *> alloc] initWithArray:arr];
        }
    }
    
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
    NSArray<GMSMarker *> *mArr=[[NSMutableArray alloc] init];
    if(markerArr){
        NSString *filterStr=[NSString stringWithFormat:@"latitude==%f AND longitude==%f",coordinate.latitude,coordinate.longitude];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:filterStr];
        mArr=[markerArr filteredArrayUsingPredicate:predicate];
        
        if(mArr!=nil&&mArr.count>0){
            return [mArr firstObject];
        }
        else{
            mArr=[[NSMutableArray alloc] init];
            filterStr=[NSString stringWithFormat:@"snippet=='%@'",addr];
            predicate=[NSPredicate predicateWithFormat:filterStr];
            mArr=[markerArr filteredArrayUsingPredicate:predicate];
            
            return [mArr firstObject];
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
        [self loadTaskMask];
    }
}

- (void)showMaskMenu:(GMSMarker *)marker
{
    selectedMarker=marker;
    UIActionSheet *actionsheet;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        
        if(marker.appearAnimation==kGMSMarkerAnimationNone){
            if(marker.taskArr.count<=1){
                actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"Google导航", @"查看订单",@"拨打电话",@"复制地址", nil,nil];
            }
            else{
                actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"Google导航", @"查看多个订单",@"复制地址", nil,nil];
            }
        }
        else{
            actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"Google导航", nil,nil];
        }
    }
    else{
        if(marker.appearAnimation==kGMSMarkerAnimationNone){
            if(marker.taskArr.count<=1){
                actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"查看订单",@"拨打电话",@"复制地址",nil,nil];
            }
            else{
                actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"查看多个订单",@"复制地址", nil,nil];
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
        [self callPhone:item.mobile];
    }
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
    sender.selected=!sender.selected;
    [APP_DELEGATE.booter handlerWorkingState:sender.selected];
}

//配送数据更新
- (void)onTaskUpdate:(NSNotification*)aNotitification{
    if(isShowing){
        [self loadTaskMask];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isShowing=YES;
    btn_workState.selected=APP_DELEGATE.isWorking;
    [APP_DELEGATE.booter loadTaskList];
    [self checkLoginStatus];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    isShowing=NO;
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
