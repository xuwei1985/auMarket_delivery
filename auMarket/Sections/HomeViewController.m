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
    [self loadTaskMask];
}

-(void)initData{
    markerArr=[[NSMutableArray alloc] init];
}

-(void)initUI{
    [self setNavigation];
    [self createMapView];
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

-(void)createMapView{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-37.8274851
                                                            longitude:144.9527565
                                                                 zoom:13];
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
    [mapView clear];//清除所有的maker
    if(markerArr){
        [markerArr removeAllObjects];
    }
    else{
        markerArr=[[NSMutableArray alloc] init];
    }
    
    
    //等待配送的
    for(int i=0;i<[APP_DELEGATE.booter.tasklist_delivering count];i++){
        itemEntity=[APP_DELEGATE.booter.tasklist_delivering objectAtIndex:i];
        coordinate=CLLocationCoordinate2DMake([self reviseDoubleValue:[itemEntity.latitude doubleValue]], [self reviseDoubleValue:[itemEntity.longitude doubleValue]]);
        itemEntity.coordinate=coordinate;//设置配送项目的坐标
        
        //判断某个coordinate的marker是否存在
        marker=[self isExistMarker:itemEntity.coordinate];
        if(marker==nil){
            mapMaker=[[MapMaker alloc] initWithFrame:CGRectMake(0, 0, 34, 48.5)];
            mapMaker.image=[UIImage imageNamed:@"1_29"];
            mapMaker.markTip=@"1";
            [mapMaker loadData];
            
            marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(itemEntity.coordinate.latitude, itemEntity.coordinate.longitude);
            marker.title = itemEntity.consignee;
            marker.snippet = itemEntity.address;
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.iconView=mapMaker;
            marker.map = mapView;
            marker.latitude=[self reviseDoubleValue:itemEntity.coordinate.latitude];
            marker.longitude=[self reviseDoubleValue:itemEntity.coordinate.longitude];
            NSLog(@"marker.latitude:%f",marker.latitude);
            [markerArr addObject:marker];
        }
        else{
            ((MapMaker *)marker.iconView).markTip=[NSString stringWithFormat:@"%d",[((MapMaker *)marker.iconView).markTip intValue]+1];
            [((MapMaker *)marker.iconView) loadData];
        }
        
    }
    
    //配送失败的
//    for(int i=0;i<[APP_DELEGATE.booter.tasklist_failed count];i++){
//        mapMaker.markTip=@"1";
//        [mapMaker loadData];
//        
//        GMSMarker *marker = [[GMSMarker alloc] init];
//        marker.position = CLLocationCoordinate2DMake([[APP_DELEGATE.booter.tasklist_failed objectAtIndex:i].longitude doubleValue], [[APP_DELEGATE.booter.tasklist_failed objectAtIndex:i].latitude doubleValue]);
//        marker.title = [APP_DELEGATE.booter.tasklist_failed objectAtIndex:i].consignee;
//        marker.snippet = [APP_DELEGATE.booter.tasklist_failed objectAtIndex:i].address;
//        marker.appearAnimation = kGMSMarkerAnimationPop;
//        marker.iconView=mapMaker;
//        marker.map = mapView;
//    }
}

-(GMSMarker *)isExistMarker:(CLLocationCoordinate2D)coordinate{
    NSArray<GMSMarker *> *mArr=[[NSMutableArray alloc] init];
    if(markerArr){
        NSString *filterStr=[NSString stringWithFormat:@"latitude==%f AND longitude==%f",coordinate.latitude,coordinate.longitude];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:filterStr];
        mArr=[markerArr filteredArrayUsingPredicate:predicate];
        return [mArr firstObject];
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
    sel_coordinate=marker.position;
    [self showMaskMenu];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    return NO;
}

- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView{
    NSLog(@"mapViewDidFinishTileRendering");
}

- (void)showMaskMenu
{
    UIActionSheet *actionsheet;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"Google导航", @"查看订单", nil,nil];
    }
    else{
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"查看订单", nil,nil];
    }
    
    [actionsheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex=%ld", buttonIndex);

    if (0 == buttonIndex)
    {
        [self runNavigationByGoogle];
    }
    else if (1 == buttonIndex)
    {
        [self gotoOrderDetail];
    }
}

-(void)runNavigationByGoogle{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",APP_NAME,APP_SCHEME,sel_coordinate.latitude, sel_coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else{
        [self showToastBottomWithText:@"您未安装Google Maps"];
    }
}

-(void)gotoOrderDetail{
    
}

-(void)unusualList:(UIButton *)sender{
    
}

-(void)toggleParkMaker:(UIButton *)sender{
    sender.selected=!sender.selected;
    [APP_DELEGATE.booter handlerWorkingState:sender.selected];
}

-(void)toggleWorkState:(UIButton *)sender{
    sender.selected=!sender.selected;
    [APP_DELEGATE.booter handlerWorkingState:sender.selected];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"isWorking:%d",APP_DELEGATE.isWorking);
    btn_workState.selected=APP_DELEGATE.isWorking;
    
    [self checkLoginStatus];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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
