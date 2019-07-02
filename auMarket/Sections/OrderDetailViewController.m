//
//  UserCenterViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//
#define ORDER_INFO_PANEL_HEIGHT 494.0
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
    if(self.task_entity!=nil){
        [self createOrderInfoView];
        [self createDoneActionBar];
    }
    
    [self setUpTableView];
}

-(void)initData{
    [self loadGoodsForOrder];
    if(self.task_entity!=nil){
        [self loadDeliveryInfo];
    }
}

-(void)setNavigation{
    self.title=@"订单详情";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        UIBarButtonItem *right_Item_cart = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"1_24"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(runNavigationByGoogle)];
        self.navigationItem.rightBarButtonItem=right_Item_cart;
    }
}

-(void)createOrderInfoView{
    UIView *blockView_1=[[UIView alloc] initWithFrame:CGRectMake(0, 12, WIDTH_SCREEN, 70)];
    blockView_1.backgroundColor=COLOR_WHITE;
    
    UIView *blockView_2=[[UIView alloc] initWithFrame:CGRectMake(0, 92, WIDTH_SCREEN, 210)];
    blockView_2.backgroundColor=COLOR_WHITE;
    blockView_2.userInteractionEnabled=YES;
    
    UIView *blockView_3=[[UIView alloc] initWithFrame:CGRectMake(0, 311, WIDTH_SCREEN, 48)];
    blockView_3.backgroundColor=COLOR_WHITE;
    blockView_3.userInteractionEnabled=YES;
    
    UIView *blockView_4=[[UIView alloc] initWithFrame:CGRectMake(0, 366, WIDTH_SCREEN, 130)];
    blockView_4.clipsToBounds=YES;
    blockView_4.backgroundColor=COLOR_WHITE;
    
    orderInfoView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, ORDER_INFO_PANEL_HEIGHT)];
    orderInfoView.userInteractionEnabled=YES;
    orderInfoView.backgroundColor=COLOR_CLEAR;
    
    [orderInfoView addSubview:blockView_1];
    [orderInfoView addSubview:blockView_2];
    [orderInfoView addSubview:blockView_3];
    [orderInfoView addSubview:blockView_4];
    
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
    lbl_payType.text=@"";
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
    lbl_orderSum.text=@"";
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
    lbl_orderNo.text=@"";
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
        make.top.mas_equalTo(blockView_2.top).offset(38);
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
        make.top.mas_equalTo(blockView_2.top).offset(38);
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
        make.top.mas_equalTo(blockView_2.top).offset(66);
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
        make.top.mas_equalTo(blockView_2.top).offset(66);
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
        make.top.mas_equalTo(blockView_2.top).offset(94);
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
        make.top.mas_equalTo(blockView_2.top).offset(94);
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
        make.top.mas_equalTo(blockView_2.top).offset(122);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_deliverytime=[[UILabel alloc] init];
    lbl_deliverytime.textColor=COLOR_DARKGRAY;
    lbl_deliverytime.font=FONT_SIZE_SMALL;
    lbl_deliverytime.text=@"--";
    lbl_deliverytime.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_deliverytime];
    
    [lbl_deliverytime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(122);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-80, 20));
        make.left.mas_equalTo(lbl_tip_6.mas_left).offset(70);
    }];
    
    UILabel *lbl_tip_11=[[UILabel alloc] init];
    lbl_tip_11.textColor=COLOR_BLACK;
    lbl_tip_11.font=FONT_SIZE_MIDDLE;
    lbl_tip_11.text=@"签收方式:";
    lbl_tip_11.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_tip_11];
    
    [lbl_tip_11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(150);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_putType=[[UILabel alloc] init];
    lbl_putType.textColor=COLOR_MAIN;
    lbl_putType.font=FONT_SIZE_SMALL;
    lbl_putType.text=@"当面签收";
    lbl_putType.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_putType];
    
    [lbl_putType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(150);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-80, 20));
        make.left.mas_equalTo(lbl_tip_7.mas_left).offset(70);
    }];
    
    
    UILabel *lbl_tip_8=[[UILabel alloc] init];
    lbl_tip_8.textColor=COLOR_BLACK;
    lbl_tip_8.font=FONT_SIZE_MIDDLE;
    lbl_tip_8.text=@"地址补充:";
    lbl_tip_8.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_tip_8];
    
    [lbl_tip_8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(178);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_address_replenish=[[UILabel alloc] init];
    lbl_address_replenish.textColor=COLOR_DARKGRAY;
    lbl_address_replenish.font=FONT_SIZE_SMALL;
    lbl_address_replenish.text=@"";
    lbl_address_replenish.textAlignment=NSTextAlignmentLeft;
    [blockView_2 addSubview:lbl_address_replenish];
    
    [lbl_address_replenish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_2.top).offset(178);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-80, 20));
        make.left.mas_equalTo(lbl_tip_7.mas_left).offset(70);
    }];

    ////////////////blockView_3///////////////
    UILabel *lbl_tip_9=[[UILabel alloc] init];
    lbl_tip_9.textColor=COLOR_BLACK;
    lbl_tip_9.font=FONT_SIZE_MIDDLE;
    lbl_tip_9.text=@"送货方式:";
    lbl_tip_9.textAlignment=NSTextAlignmentLeft;
    [blockView_3 addSubview:lbl_tip_9];
    
    [lbl_tip_9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 28));
        make.left.mas_equalTo(10);
    }];
    
    lbl_upstairs=[[UILabel alloc] init];
    lbl_upstairs.textColor=COLOR_DARKGRAY;
    lbl_upstairs.font=FONT_SIZE_SMALL;
    lbl_upstairs.text=@"默认";
    lbl_upstairs.textAlignment=NSTextAlignmentRight;
    [blockView_3 addSubview:lbl_upstairs];
    
    [lbl_upstairs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_3.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 28));
        make.right.mas_equalTo(blockView_3.mas_right).offset(-10);
    }];
    
    ////////////////blockView_4///////////////
    UILabel *lbl_tip_10=[[UILabel alloc] init];
    lbl_tip_10.textColor=COLOR_BLACK;
    lbl_tip_10.font=FONT_SIZE_MIDDLE;
    lbl_tip_10.text=@"打包员备注:";
    lbl_tip_10.textAlignment=NSTextAlignmentLeft;
    [blockView_4 addSubview:lbl_tip_10];
    
    [lbl_tip_10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockView_4.top).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.left.mas_equalTo(10);
    }];
    
    lbl_packagenote=[[UILabel alloc] init];
    lbl_packagenote.textColor=COLOR_DARKGRAY;
    lbl_packagenote.font=FONT_SIZE_SMALL;
    lbl_packagenote.numberOfLines=0;
    lbl_packagenote.text=@"";
    lbl_packagenote.textAlignment=NSTextAlignmentLeft;
    [blockView_4 addSubview:lbl_packagenote];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 35, WIDTH_SCREEN, 0.5)];
    line.backgroundColor=RGBCOLOR(230, 230, 230);
    [blockView_4 addSubview:line];
    
    [lbl_packagenote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-20, 88));
        make.left.mas_equalTo(10);
    }];
    
}

-(void)setUpTableView{
    float table_height=HEIGHT_SCREEN-64-DONE_ACTION_BAR;
    if(self.task_entity==nil||[self.task_entity.status intValue]==1||[self.task_entity.status intValue]==2){
        table_height=HEIGHT_SCREEN-64;
    }
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN,table_height) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    
    if(self.task_entity!=nil){
        [self.tableView setTableHeaderView:orderInfoView];
    }
    else{
        [self.tableView setTableHeaderView:view];
    }
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
}

/**
 创建完成操作条
 */
-(void)createDoneActionBar{
    if([self.task_entity.status intValue]!=1&&[self.task_entity.status intValue]!=2){
        _btn_returnAction=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_returnAction setTitle:@"订单返现" forState:UIControlStateNormal];
        _btn_returnAction.titleLabel.textAlignment=NSTextAlignmentCenter;
        [_btn_returnAction setBackgroundColor:COLOR_WHITE];
        [_btn_returnAction setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        _btn_returnAction.titleLabel.font=FONT_SIZE_BIG;
        [_btn_returnAction addTarget:self action:@selector(confirmReturnPrice) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btn_returnAction];
        
        
        @weakify(self);
        [_btn_returnAction mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.view.mas_bottom).offset(-48);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(WIDTH_SCREEN/2);
            make.height.mas_equalTo(DONE_ACTION_BAR);
        }];
        
        _btn_doneAction=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_doneAction setTitle:@"完成配送" forState:UIControlStateNormal];
        _btn_doneAction.titleLabel.textAlignment=NSTextAlignmentCenter;
        if([self.task_entity.is_ready intValue]==1){
            [_btn_doneAction setBackgroundColor:COLOR_MAIN];
            [_btn_doneAction setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        }
        else{
            [_btn_doneAction setBackgroundColor:COLOR_LIGHTGRAY];
            [_btn_doneAction setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        }
        
        _btn_doneAction.titleLabel.font=FONT_SIZE_BIG;
        [_btn_doneAction addTarget:self action:@selector(deliveryFinish) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btn_doneAction];
    
        [_btn_doneAction mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.view.mas_bottom).offset(-48);
            make.left.mas_equalTo(WIDTH_SCREEN/2);
            make.width.mas_equalTo(WIDTH_SCREEN/2);
            make.height.mas_equalTo(DONE_ACTION_BAR);
        }];
    }
}

//请求订单下的商品信息
-(void)loadGoodsForOrder{
    [self startLoadingActivityIndicator];
    if(self.task_entity!=nil){
        [self.model loadGoodsListForOrder:self.task_entity.order_id];
    }
    else{
        [self.model loadGoodsListForOrder:self.order_id];
    }
}

-(void)setDeliveryDone:(NSString *)status andPayType:(NSString *)pay_type{
    [self startLoadingActivityIndicator];
    
    if(lbl_orderNo.text.length>0){
        [self.model order_delivery_done:self.task_entity.delivery_id andStatus:status andPayType:pay_type andImgPath:@"" andOrderSn:lbl_orderNo.text];
    }
    else{
        [self showToastTopWithText:@"没有配送订单信息"];
    }
}

-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    [self stopLoadingActivityIndicator];
    if(model==self.model&&self.model.requestTag==3002){
        if(isSuccess){
            [self.tableView reloadData];
        }
    }
    else if(model==self.model&&self.model.requestTag==3003){
        if(isSuccess){
            [self showSuccesWithText:@"操作成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(model==self.model&&self.model.requestTag==3004){
        if(isSuccess){
            [self showSuccesWithText:@"保存成功"];
        }
    }
}

-(void)loadDeliveryInfo{
    if(self.task_entity){
        lbl_payType.text=self.task_entity.pay_name;
        lbl_orderSum.text=[NSString stringWithFormat:@"$%@",self.task_entity.order_amount];
        lbl_orderNo.text=self.task_entity.order_sn;
        lbl_contact.text=self.task_entity.consignee;
        lbl_mobile.text=self.task_entity.mobile;
        lbl_address.text=self.task_entity.address;
        lbl_deliverytime.text=self.task_entity.delivery_time;
        if([self.task_entity.put_type intValue]==1){
            lbl_putType.text=@"放门口";
        }
        else{
            lbl_putType.text=@"当面签收";
        }
        
        lbl_address_replenish.text=self.task_entity.address_replenish;
        lbl_upstairs.text=self.task_entity.option_title;
        if(self.task_entity.package_note.length>0){
            lbl_packagenote.textColor=COLOR_MAIN;
            lbl_packagenote.text=self.task_entity.package_note;
        }
        else{
            lbl_packagenote.textColor=COLOR_DARKGRAY;
            lbl_packagenote.text=@"无备注信息";
        }
    }
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return [self.model.goods_entity.goods_list_normal count];
    }
    else if(section==1){
        return [self.model.goods_entity.goods_list_alone count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0&&[self.model.goods_entity.goods_list_normal count]>0){
        return 38;
    }
    else if(section==1&&[self.model.goods_entity.goods_list_alone count]>0){
        return 38;
    }
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *packageCategory=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 150, 20)];
    packageCategory.font=FONT_SIZE_MIDDLE;
    packageCategory.textColor=COLOR_BLACK;
    if(section==0){
        packageCategory.text=@"  通用打包商品";
    }
    else if(section==1){
        packageCategory.text=@"  单独打包商品";
    }
    return packageCategory;
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
    if(indexPath.section==0){
        cell.itemName=[self.model.goods_entity.goods_list_normal objectAtIndex:indexPath.row].goods_name;
        cell.itemNum=[self.model.goods_entity.goods_list_normal objectAtIndex:indexPath.row].goods_number;
        cell.itemImage=[self.model.goods_entity.goods_list_normal objectAtIndex:indexPath.row].thumb_url;
    }
    else if(indexPath.section==1){
        cell.itemName=[self.model.goods_entity.goods_list_alone objectAtIndex:indexPath.row].goods_name;
        cell.itemNum=[self.model.goods_entity.goods_list_alone objectAtIndex:indexPath.row].goods_number;
        cell.itemImage=[self.model.goods_entity.goods_list_alone objectAtIndex:indexPath.row].thumb_url;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITableView *tableview = (UITableView *)scrollView;
    CGFloat sectionHeaderHeight = 40;
    CGFloat sectionFooterHeight = 0;
    
    
    CGFloat offsetY = tableview.contentOffset.y;
    NSLog(@"offsetY:%f",offsetY);
    
    if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
    {
        tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
    {
        tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
    {
        if(offsetY>0){
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
        }
    }
    
}


-(void)confirmReturnPrice{
    if(self.task_entity!=nil){
        [self showReturnMenu];
    }
    else{
        [self showToastWithText:@"缺少订单数据"];
    }
}

- (void)showReturnMenu
{
    UIActionSheet *actionsheet;
    if([self.task_entity.return_price intValue]>=5){
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择返现金额" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"返现5澳币", @"返现2澳币", nil,nil];
        actionsheet.tag=3888;
    }
    else if([self.task_entity.return_price intValue]>=2&&[self.task_entity.return_price intValue]<5){
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择返现金额" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"返现2澳币", nil,nil];
        actionsheet.tag=3889;
    }
    else if([self.task_entity.return_price intValue]<=0){
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择返现金额" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"无返现", nil,nil];
        actionsheet.tag=3890;
    }
    
    
    [actionsheet showInView:self.view];
}

-(void)deliveryFinish{
    if([self.task_entity.is_ready intValue]==1){
        [self showFinishMenu];
//        if([self.task_entity.pay_type intValue]==4){//如果是货到付款，则须先选择结算方式
//            [self showFinishMenu];
//        }
//        else{//如果是线上支付，直接调用配送完成接口
//            [[AlertBlockView sharedInstance] showChoiceAlert:@"确认完成订单配送吗？" button1Title:@"确定" button2Title:@"取消" completion:^(int index) {
//                if(index==0){
//                    [self setDeliveryDone:@"1" andPayType:@"0"];//0代表线上支付 1现金 2转账
//                }
//            }];
//        }
    }
    else{
        [self showToastWithText:@"订单尚未发货"];
    }
    
}

- (void)showFinishMenu
{
    UIActionSheet *actionsheet;
    if([self.task_entity.pay_type intValue]==4){//如果是货到付款，则须先选择结算方式
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"现金结算", @"转账结算",@"无法配送", nil,nil];
    }
    else{
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"配送完成",@"无法配送", nil,nil];
    }
    actionsheet.tag=3999;
    [actionsheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==3999){
        if([self.task_entity.pay_type intValue]==4){//如果是货到付款
            if (0 == buttonIndex)//现金结算
            {
                [[AlertBlockView sharedInstance] showChoiceAlert:@"确认完成订单配送吗？" button1Title:@"确定" button2Title:@"取消" completion:^(int index) {
                    if(index==0){
                        [self setDeliveryDone:@"1" andPayType:@"1"];//0代表线上支付 1现金 2转账
                    }
                }];
            }
            else if (1 == buttonIndex)//转账结算
            {
                if(lbl_orderNo.text.length>0){
                    PaymentViewController *pvc=[[PaymentViewController alloc] init];
                    pvc.task_entity=self.task_entity;
                    pvc.order_sn=lbl_orderNo.text;
                    [self.navigationController pushViewController:pvc animated:YES];
                }
                else{
                    [self showToastTopWithText:@"没有配送订单信息"];
                }
                
            }
            else if (2 == buttonIndex)//无法配送
            {
                [self setDeliveryDone:@"2" andPayType:@"-1"];//0代表线上支付 1现金 2转账 -1未配送结算
            }
        }
        else{//显示支付
            if (0 == buttonIndex)//完成配送
            {
                [[AlertBlockView sharedInstance] showChoiceAlert:@"确认完成订单配送吗？" button1Title:@"确定" button2Title:@"取消" completion:^(int index) {
                    if(index==0){
                        [self setDeliveryDone:@"1" andPayType:@"0"];//0代表线上支付 1现金 2转账
                    }
                }];
            }
            else if (1 == buttonIndex)//无法配送
            {
                [self setDeliveryDone:@"2" andPayType:@"-1"];//0代表线上支付 1现金 2转账 -1未配送结算
                
            }
        }
    }
    else if(actionSheet.tag==3888){
        if (0 == buttonIndex){//5
            [self saveOrderReturnInfo:self.task_entity.order_id andReturnPrice:5];
        }
        else{//2
             [self saveOrderReturnInfo:self.task_entity.order_id andReturnPrice:2];
        }
    }
    else if(actionSheet.tag==3889){
        if (0 == buttonIndex){//2
             [self saveOrderReturnInfo:self.task_entity.order_id andReturnPrice:2];
        }
    }
    else if(actionSheet.tag==3890){
        if (0 == buttonIndex){//0
             [self saveOrderReturnInfo:self.task_entity.order_id andReturnPrice:0];
        }
    }
}

-(void)saveOrderReturnInfo:(NSString *)order_id andReturnPrice:(int)price{
    [self startLoadingActivityIndicator];
    [self.model saveOrderReturnInfo:order_id andReturnPrice:price];
}


-(void)runNavigationByGoogle{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@,%@&directionsmode=driving",APP_NAME,APP_SCHEME,self.task_entity.latitude, self.task_entity.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

-(TaskModel *)model{
    if(!_model){
        _model=[[TaskModel alloc] init];
        _model.delegate=self;
    }
    return _model;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
