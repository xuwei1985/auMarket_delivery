//
//  UserCenterViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//
#define ORDER_INFO_PANEL_HEIGHT 345.0
#define DONE_ACTION_BAR 48.0
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
    [self createDoneActionBar];
}

-(void)initData{
    
}

-(void)setNavigation{
    self.title=@"订单详情";
    UIBarButtonItem *right_Item_cart = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"1_24"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(runNavigationByGoogle)];

    self.navigationItem.rightBarButtonItem=right_Item_cart;
}

-(void)createOrderInfoView{
    UIView *blockView_1=[[UIView alloc] initWithFrame:CGRectMake(0, 10, WIDTH_SCREEN, 70)];
    blockView_1.backgroundColor=COLOR_WHITE;
    UIView *blockView_2=[[UIView alloc] initWithFrame:CGRectMake(0, 92, WIDTH_SCREEN, 146)];
    blockView_2.backgroundColor=COLOR_WHITE;
    blockView_2.userInteractionEnabled=YES;
    UIView *blockView_3=[[UIView alloc] initWithFrame:CGRectMake(0, 250, WIDTH_SCREEN, 95)];
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
    lbl_orderNo.font=FONT_SIZE_SMALL;
    lbl_orderNo.text=@"2017080911232343";
    lbl_orderNo.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_orderNo];
    
    [lbl_orderNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-70, 20));
        make.left.mas_equalTo(lbl_tip_3.mas_left).offset(60);
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
    lbl_contact.font=FONT_SIZE_SMALL;
    lbl_contact.text=@"Wilson";
    lbl_contact.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_contact];
    
    [lbl_contact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(35);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-70, 20));
        make.left.mas_equalTo(lbl_tip_4.mas_left).offset(60);
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
    lbl_mobile.textColor=RGBCOLOR(15, 34, 177);
    lbl_mobile.font=FONT_SIZE_SMALL;
    lbl_mobile.text=@"0419234058";
    lbl_mobile.textAlignment=NSTextAlignmentLeft;
    lbl_mobile.userInteractionEnabled=YES;
    [blockView_2 addSubview:lbl_mobile];
    [lbl_mobile addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeCall:)]];
    
    [lbl_mobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(60);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-65, 20));
        make.left.mas_equalTo(lbl_tip_5.mas_left).offset(45);
    }];
    
    UILabel *lbl_tip_6=[[UILabel alloc] init];
    lbl_tip_6.textColor=COLOR_BLACK;
    lbl_tip_6.font=FONT_SIZE_MIDDLE;
    lbl_tip_6.text=@"地址:";
    lbl_tip_6.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_tip_6];
    
    [lbl_tip_6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(85);
        make.size.mas_equalTo(CGSizeMake(45, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_address=[[UILabel alloc] init];
    lbl_address.textColor=COLOR_DARKGRAY;
    lbl_address.font=FONT_SIZE_SMALL;
    lbl_address.text=@"1/22 Oakleigh Road, Carnegie, Melbourne, Australia";
    lbl_address.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_address];
    
    [lbl_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(85);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-65, 20));
        make.left.mas_equalTo(lbl_tip_6.mas_left).offset(45);
    }];
    
    UILabel *lbl_tip_7=[[UILabel alloc] init];
    lbl_tip_7.textColor=COLOR_BLACK;
    lbl_tip_7.font=FONT_SIZE_MIDDLE;
    lbl_tip_7.text=@"配送时间:";
    lbl_tip_7.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_tip_7];
    
    [lbl_tip_7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(110);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_deliverytime=[[UILabel alloc] init];
    lbl_deliverytime.textColor=COLOR_DARKGRAY;
    lbl_deliverytime.font=FONT_SIZE_SMALL;
    lbl_deliverytime.text=@"08月27日[星期日] 17:30-22:30";
    lbl_deliverytime.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_deliverytime];
    
    [lbl_deliverytime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(110);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-80, 20));
        make.left.mas_equalTo(lbl_tip_6.mas_left).offset(70);
    }];
    
    ////////////////blockView_3///////////////
    UILabel *lbl_tip_8=[[UILabel alloc] init];
    lbl_tip_8.textColor=COLOR_BLACK;
    lbl_tip_8.font=FONT_SIZE_MIDDLE;
    lbl_tip_8.text=@"打包员备注:";
    lbl_tip_8.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_tip_8];
    
    [lbl_tip_8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_packagenote=[[UILabel alloc] init];
    lbl_packagenote.textColor=COLOR_DARKGRAY;
    lbl_packagenote.font=FONT_SIZE_SMALL;
    lbl_packagenote.numberOfLines=3;
    lbl_packagenote.text=@"以上用户言论只代表其个人观点，不代表CSDN网站的观点或立场；";
    lbl_packagenote.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_packagenote];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 35, WIDTH_SCREEN, 0.5)];
    line.backgroundColor=RGBCOLOR(230, 230, 230);
    [blockView_3 addSubview:line];
    
    [lbl_packagenote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(40);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-20, 50));
        make.left.mas_equalTo(10);
    }];
    
}

-(void)setUpTableView{
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN-64-DONE_ACTION_BAR) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    
    [self.tableView setTableHeaderView:orderInfoView];
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
}

-(void)createDoneActionBar{
    _btn_doneAction=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn_doneAction setTitle:@"完成配送" forState:UIControlStateNormal];
    _btn_doneAction.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_btn_doneAction setBackgroundColor:COLOR_MAIN];
    _btn_doneAction.tintColor=COLOR_WHITE;
    _btn_doneAction.titleLabel.font=FONT_SIZE_BIG;
    [_btn_doneAction addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_doneAction];
    
    
    @weakify(self);
    [_btn_doneAction mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.view.mas_bottom).offset(-48);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(WIDTH_SCREEN);
        make.height.mas_equalTo(DONE_ACTION_BAR);
    }];
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
    return 40;
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
    return 70;
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

-(void)makeCall:(UIGestureRecognizer *)sender{
    UILabel *lbl_sender=(UILabel *)sender.view;
    if(lbl_sender){
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",lbl_sender.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
