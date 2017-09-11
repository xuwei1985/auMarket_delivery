//
//  UserCenterViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//
#define ORDER_INFO_PANEL_HEIGHT 364.0
#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}


-(void)initUI{
    [self setNavigation];
    [self createOrderInfoView];
    [self setUpTableView];
}

-(void)initData{
    
}

-(void)setNavigation{
    self.title=@"订单详情";
    UIBarButtonItem *right_Item_cart = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"1_24"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(runNavigationByGoogle)];

    self.navigationItem.rightBarButtonItem=right_Item_cart;
}

-(void)createOrderInfoView{
    UIView *blockView_1=[[UIView alloc] initWithFrame:CGRectMake(0, 10, WIDTH_SCREEN, 75)];
    blockView_1.backgroundColor=COLOR_WHITE;
    UIView *blockView_2=[[UIView alloc] initWithFrame:CGRectMake(0, 97, WIDTH_SCREEN, 160)];
    blockView_2.backgroundColor=COLOR_WHITE;
    UIView *blockView_3=[[UIView alloc] initWithFrame:CGRectMake(0, 274, WIDTH_SCREEN, 90)];
    blockView_3.backgroundColor=COLOR_WHITE;
    
    orderInfoView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, ORDER_INFO_PANEL_HEIGHT)];
    orderInfoView.userInteractionEnabled=YES;
    orderInfoView.backgroundColor=COLOR_CLEAR;
    
    [orderInfoView addSubview:blockView_1];
    [orderInfoView addSubview:blockView_2];
    [orderInfoView addSubview:blockView_3];
    
    
    ////////////////blockView_1///////////////
    UILabel *lbl_tip_1=[[UILabel alloc] init];
    lbl_tip_1.textColor=COLOR_BLACK;
    lbl_tip_1.font=FONT_SIZE_MIDDLE;
    lbl_tip_1.text=@"付款方式";
    lbl_tip_1.textAlignment=NSTextAlignmentLeft;
    [blockView_1 addSubview:lbl_tip_1];
    
    [lbl_tip_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_1.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_payType=[[UILabel alloc] init];
    lbl_payType.textColor=COLOR_MAIN;
    lbl_payType.font=FONT_SIZE_MIDDLE;
    lbl_payType.text=@"货到付款";
    lbl_payType.textAlignment=NSTextAlignmentRight;
    [blockView_1 addSubview:lbl_payType];
    
    [lbl_payType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_1.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(blockView_1.mas_right).offset(-10);
    }];
    
    UILabel *lbl_tip_2=[[UILabel alloc] init];
    lbl_tip_2.textColor=COLOR_BLACK;
    lbl_tip_2.font=FONT_SIZE_MIDDLE;
    lbl_tip_2.text=@"总金额";
    lbl_tip_2.textAlignment=NSTextAlignmentLeft;
    [blockView_1 addSubview:lbl_tip_2];
    
    [lbl_tip_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_1.top).offset(40);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_orderSum=[[UILabel alloc] init];
    lbl_orderSum.textColor=COLOR_MAIN;
    lbl_orderSum.font=FONT_SIZE_MIDDLE;
    lbl_orderSum.text=@"$119.2";
    lbl_orderSum.textAlignment=NSTextAlignmentRight;
    [blockView_1 addSubview:lbl_orderSum];
    
    [lbl_orderSum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_1.top).offset(40);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(blockView_1.mas_right).offset(-10);
    }];
    
    
    ////////////////blockView_2///////////////
    
    UILabel *lbl_tip_3=[[UILabel alloc] init];
    lbl_tip_3.textColor=COLOR_BLACK;
    lbl_tip_3.font=FONT_SIZE_MIDDLE;
    lbl_tip_3.text=@"订单号:";
    lbl_tip_3.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_tip_3];
    
    [lbl_tip_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_orderNo=[[UILabel alloc] init];
    lbl_orderNo.textColor=COLOR_DARKGRAY;
    lbl_orderNo.font=FONT_SIZE_MIDDLE;
    lbl_orderNo.text=@"2017080911232343";
    lbl_orderNo.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_orderNo];
    
    [lbl_orderNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-75, 20));
        make.left.mas_equalTo(lbl_tip_3.mas_left).offset(65);
    }];
    
    UILabel *lbl_tip_4=[[UILabel alloc] init];
    lbl_tip_4.textColor=COLOR_BLACK;
    lbl_tip_4.font=FONT_SIZE_MIDDLE;
    lbl_tip_4.text=@"收货人:";
    lbl_tip_4.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_tip_4];
    
    [lbl_tip_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(35);
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_contact=[[UILabel alloc] init];
    lbl_contact.textColor=COLOR_DARKGRAY;
    lbl_contact.font=FONT_SIZE_MIDDLE;
    lbl_contact.text=@"Wilson";
    lbl_contact.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_contact];
    
    [lbl_contact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(35);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-75, 20));
        make.left.mas_equalTo(lbl_tip_4.mas_left).offset(65);
    }];
    
    UILabel *lbl_tip_5=[[UILabel alloc] init];
    lbl_tip_5.textColor=COLOR_BLACK;
    lbl_tip_5.font=FONT_SIZE_MIDDLE;
    lbl_tip_5.text=@"手机:";
    lbl_tip_5.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_tip_5];
    
    [lbl_tip_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(60);
        make.size.mas_equalTo(CGSizeMake(45, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_mobile=[[UILabel alloc] init];
    lbl_mobile.textColor=COLOR_DARKGRAY;
    lbl_mobile.font=FONT_SIZE_MIDDLE;
    lbl_mobile.text=@"0419234058";
    lbl_mobile.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_mobile];
    
    [lbl_mobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(60);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-70, 20));
        make.left.mas_equalTo(lbl_tip_5.mas_left).offset(50);
    }];
}

-(void)setUpTableView{
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN-64) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    
    [self.tableView setTableHeaderView:orderInfoView];
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ORDER_INFO_PANEL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"MemberCellIdentifier";
    OrderDetailCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.showsReorderControl = NO;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.backgroundColor=COLOR_BG_TABLEVIEWCELL;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font=FONT_SIZE_MIDDLE;
        cell.textLabel.textColor=COLOR_DARKGRAY;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:NO];
}

-(void)runNavigationByGoogle{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",APP_NAME,APP_SCHEME,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else{
        [self showToastBottomWithText:@"您未安装Google Maps"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
