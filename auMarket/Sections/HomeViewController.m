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
    marker.iconView=mv;
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
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    NSLog(@"didTapInfoWindowOfMarker");
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    
    [self showToastWithText:[NSString stringWithFormat:@"点击了Mark:%@",marker.position]];
    return YES;
}

-(void)unusualList:(UIButton *)sender{
    
}

-(void)toggleParkMaker:(UIButton *)sender{
    sender.selected=!sender.selected;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
