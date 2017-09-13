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
}

-(void)initData{

}

-(void)initUI{
    [self setNavigation];
    [self createMapView];
}

-(void)setNavigation{
    UIButton *btn_l = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_l.frame= CGRectMake(0, 0, 32, 32);
    [btn_l setImage:[UIImage imageNamed:@"1_06"] forState:UIControlStateNormal];
    [btn_l addTarget:self action:@selector(unusualList:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btn_left = [[UIBarButtonItem alloc] initWithCustomView:btn_l];
    self.navigationItem.leftBarButtonItem =btn_left;
    
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
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-37.819575
                                                            longitude:144.945466
                                                                 zoom:13];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.delegate=self;
    [[mapView settings] setMyLocationButton:YES];
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    MapMaker *mv=[[MapMaker alloc] initWithFrame:CGRectMake(0, 0, 34, 48.5)];
    mv.image=[UIImage imageNamed:@"1_29"];
    mv.markTip=@"8";
    [mv loadData];
    
    MapMaker *mv2=[[MapMaker alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    mv2.image=[UIImage imageNamed:@"1_45"];
    [mv2 loadData];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-37.819575, 144.945466);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.iconView=mv;
    marker.map = mapView;
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-37.729575, 144.947466);
    marker.title = @"Sydney2";
    marker.snippet = @"Australia";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.iconView=mv2;
    marker.map = mapView;
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-37.229575, 144.947466);
    marker.title = @"Sydney3";
    marker.snippet = @"Australia";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.iconView=mv;
    marker.map = mapView;
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-37.529575, 144.947466);
    marker.title = @"Sydney4";
    marker.snippet = @"Australia";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.iconView=mv;
    marker.map = mapView;
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-37.829575, 144.957466);
    marker.title = @"Sydney5";
    marker.snippet = @"Australia";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.iconView=mv;
    marker.map = mapView;
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-37.829575, 144.147466);
    marker.title = @"Sydney6";
    marker.snippet = @"Australia";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.iconView=mv;
    marker.map = mapView;
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    NSLog(@"didTapInfoWindowOfMarker");
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    sel_coordinate=marker.position;
    [self showMaskMenu];
    return YES;
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
