//
//  TaskListViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2017/9/11.
//  Copyright © 2017年 daao. All rights reserved.
//
#define SEGMENTVIEW_HEIGHT 44
#define TASK_CATEGORY_EDGE 12
#define TASK_CATEGORY_GAP 15
#define TASK_CATEGORY_WIDTH (WIDTH_SCREEN-TASK_CATEGORY_EDGE*2-TASK_CATEGORY_GAP*2)/3
#define CATEGORY_BAR 44.0
#define SECTION_HEADER_HEIGHT 200.0
#define GOODS_ROW_HEIGHT 72.0
#import "TaskListViewController.h"

@interface TaskListViewController ()

@end

@implementation TaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self addNotification];
}


-(void)initData{
    if(self.taskArr){
        list_status_modal=Delivery_Status_Multi;//一个地址多单的模式
    }
    else{
        list_status_modal=Delivery_Status_Delivering;
    }
}

-(void)initUI{
    [self setNavigation];
    [self setUpTableView];
    if(!self.taskArr){//不是从首页的一个坐标多个订单过来的
        [self createTaskCategoryButtons];
    }
    
    [self.tableView reloadData];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskUpdate:) name:TASK_UPDATE_NOTIFICATION object:nil];
}

-(void)setNavigation{
    self.title=@"配送列表";
    
    btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_r.frame= CGRectMake(0, 0, 26, 22);
    [btn_r setImage:[UIImage imageNamed:@"list_model_0"] forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(toggleListShowModel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    self.navigationItem.rightBarButtonItem =btn_right;
}

-(void)toggleListShowModel:(id)sender{
    if(list_show_model==0){
        list_show_model=1;
        [btn_r setImage:[UIImage imageNamed:@"list_model_1"] forState:UIControlStateNormal];
    }
    else{
        list_show_model=0;
        [btn_r setImage:[UIImage imageNamed:@"list_model_0"] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

-(void)createTaskCategoryButtons{
    UIView *taskCategoeryBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, SEGMENTVIEW_HEIGHT)];
    taskCategoeryBar.backgroundColor=RGBCOLOR(255, 255, 255);
    [self.view addSubview:taskCategoeryBar];
    
    btn_waitDelivery=[[UIButton alloc] initWithFrame:CGRectMake(TASK_CATEGORY_EDGE+TASK_CATEGORY_GAP*0+TASK_CATEGORY_WIDTH*0, 0, TASK_CATEGORY_WIDTH, SEGMENTVIEW_HEIGHT)];
    [btn_waitDelivery setTitle:@"待配送(0)" forState:UIControlStateNormal];
    [btn_waitDelivery setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [btn_waitDelivery setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    btn_waitDelivery.titleLabel.font=FONT_SIZE_MIDDLE;
    btn_waitDelivery.titleLabel.textAlignment=NSTextAlignmentCenter;
    btn_waitDelivery.tag=1000;
    [taskCategoeryBar addSubview:btn_waitDelivery];
    [btn_waitDelivery addTarget:self action:@selector(taskCategoryTap:) forControlEvents:UIControlEventTouchUpInside];
    
    if(list_status_modal==Delivery_Status_Delivering){
        btn_waitDelivery.selected=YES;
    }
    
    btn_failedDelivery=[[UIButton alloc] initWithFrame:CGRectMake(TASK_CATEGORY_EDGE+TASK_CATEGORY_GAP*1+TASK_CATEGORY_WIDTH*1, 0, TASK_CATEGORY_WIDTH, SEGMENTVIEW_HEIGHT)];
    [btn_failedDelivery setTitle:@"配送失败(0)" forState:UIControlStateNormal];
    [btn_failedDelivery setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [btn_failedDelivery setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    btn_failedDelivery.titleLabel.font=FONT_SIZE_MIDDLE;
    btn_failedDelivery.titleLabel.textAlignment=NSTextAlignmentCenter;
    btn_failedDelivery.tag=1002;
    [taskCategoeryBar addSubview:btn_failedDelivery];
    [btn_failedDelivery addTarget:self action:@selector(taskCategoryTap:) forControlEvents:UIControlEventTouchUpInside];
    
    if(list_status_modal==Delivery_Status_Failed){
        btn_failedDelivery.selected=YES;
    }
    
    btn_successDelivery=[[UIButton alloc] initWithFrame:CGRectMake(TASK_CATEGORY_EDGE+TASK_CATEGORY_GAP*2+TASK_CATEGORY_WIDTH*2, 0, TASK_CATEGORY_WIDTH, SEGMENTVIEW_HEIGHT)];
    [btn_successDelivery setTitle:@"配送完成(0)" forState:UIControlStateNormal];
    [btn_successDelivery setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [btn_successDelivery setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    btn_successDelivery.titleLabel.font=FONT_SIZE_MIDDLE;
    btn_successDelivery.titleLabel.textAlignment=NSTextAlignmentCenter;
    btn_successDelivery.tag=1001;
    [taskCategoeryBar addSubview:btn_successDelivery];
    [btn_successDelivery addTarget:self action:@selector(taskCategoryTap:) forControlEvents:UIControlEventTouchUpInside];
    
    if(list_status_modal==Delivery_Status_Finished){
        btn_successDelivery.selected=YES;
    }
    
    [self refreshCategoryBtn];
}

-(void)setUpTableView{
    if(!self.taskArr){
        self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, SEGMENTVIEW_HEIGHT, WIDTH_SCREEN, HEIGHT_SCREEN-HEIGHT_STATUS_AND_NAVIGATION_BAR-HEIGHT_TAB_BAR-SEGMENTVIEW_HEIGHT-12) style:UITableViewStyleGrouped];
    }
    else{
        self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN-HEIGHT_STATUS_AND_NAVIGATION_BAR-HEIGHT_TAB_BAR) style:UITableViewStyleGrouped];
    }
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    self.tableView.tag=999;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    [self.tableView setTableFooterView:view];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, CGFLOAT_MIN)];
    
    [self.tableView setEstimatedRowHeight: 0.0];
    [self.tableView setEstimatedSectionHeaderHeight:0.0];
    [self.tableView setEstimatedSectionFooterHeight:0.0];
    [self.view addSubview:self.tableView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadTaskList)];
    
    //    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing]; // 松手刷新
    header.stateLabel.font = FONT_SIZE_SMALL;
    header.stateLabel.textColor = COLOR_DARKGRAY;
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden=YES;
    //    [header beginRefreshing];
    
    self.tableView.mj_header=header;
}



-(UITableView *)getSectionFooterView:(int)section andEntity:(TaskItemEntity *)entity{
    int n=(int)[entity.box_goods count];
    int height=GOODS_ROW_HEIGHT*n;
    UITableView *goodsTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN,height) style:UITableViewStylePlain];
    goodsTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    goodsTableView.separatorColor=COLOR_BG_TABLESEPARATE;
    goodsTableView.backgroundColor=COLOR_BG_TABLEVIEW;
    goodsTableView.tag=5000+section;
    goodsTableView.delegate=self;
    goodsTableView.dataSource=self;
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    
    [goodsTableView setTableHeaderView:view];
    [goodsTableView setTableFooterView:view];
    [goodsTableView reloadData];
    return goodsTableView;
}

-(UIView *)getSectionHeaderView:(TaskItemEntity *)entity andSection:(int)section{
    if(list_show_model==1){
        return nil;
    }
    UILabel *lbl_contact;
    UILabel *lbl_package_num;
    UIView *section_view;
    
    section_view=[[UIView alloc] initWithFrame:CGRectMake(0, 15, WIDTH_SCREEN, SECTION_HEADER_HEIGHT)];
    section_view.userInteractionEnabled=YES;
    section_view.tag=7000+section;
    [section_view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoOrderDetailView:)]];
    
    if([entity.is_ready intValue]==0){//订单未准备好
        section_view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    }
    else{
        section_view.backgroundColor=COLOR_BG_WHITE;
    }
    
    UIView *line_view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 15)];
    line_view.backgroundColor=COLOR_BG_VIEW;
    [section_view addSubview:line_view];
    
    lbl_contact=[[UILabel alloc] initWithFrame:CGRectMake(10, 24, 160, 20)];
    lbl_contact.textAlignment=NSTextAlignmentLeft;
    lbl_contact.font=DEFAULT_FONT(13);
    lbl_contact.textColor=COLOR_MAIN;
    [section_view addSubview:lbl_contact];
    
    lbl_package_num=[[UILabel alloc] initWithFrame:CGRectMake(WIDTH_SCREEN-130, 24, 120, 20)];
    lbl_package_num.textAlignment=NSTextAlignmentRight;
    lbl_package_num.font=DEFAULT_FONT(13);
    lbl_package_num.textColor=COLOR_MAIN;
    [section_view addSubview:lbl_package_num];
    
    line_view=[[UIView alloc] initWithFrame:CGRectMake(0, 52, WIDTH_SCREEN, 1)];
    line_view.backgroundColor=COLOR_BG_VIEW;
    [section_view addSubview:line_view];
    
    lbl_contact.text=[NSString stringWithFormat:@"收货人：%@",entity.consignee];
    
    int n=0;
    for (int i=0; i<entity.package_arr.count; i++) {
        n+=[[[entity.package_arr objectAtIndex:i] objectForKey:@"number"] intValue];
    }
    
    lbl_package_num.text=[NSString stringWithFormat:@"包裹总数：%d",n];
    
    UIImageView *iconView=[[UIImageView alloc] init];
    iconView.image=[UIImage imageNamed:@"1_45"];
    [section_view addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(74);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    UILabel *lbl_order_region=[[UILabel alloc] init];
    lbl_order_region.textColor=COLOR_GRAY;
    lbl_order_region.font=FONT_SIZE_SMALL;
    lbl_order_region.text=@"区域：";
    [section_view addSubview:lbl_order_region];
    
    [lbl_order_region mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_view.mas_bottom).offset(15);
        make.left.mas_equalTo(iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    UILabel *lbl_order_region_value=[[UILabel alloc] init];
    lbl_order_region_value.textColor=COLOR_BLACK;
    lbl_order_region_value.font=FONT_SIZE_SMALL;
    lbl_order_region_value.text=entity.block_name;
    [section_view addSubview:lbl_order_region_value];
    
    [lbl_order_region_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_view.mas_bottom).offset(15);
        make.left.mas_equalTo(lbl_order_region.mas_right);
        make.size.mas_equalTo(CGSizeMake(144, 20));
    }];
    
    UILabel *lbl_order_sn=[[UILabel alloc] init];
    lbl_order_sn.textColor=COLOR_GRAY;
    lbl_order_sn.font=FONT_SIZE_SMALL;
    lbl_order_sn.text=@"订单号：";
    [section_view addSubview:lbl_order_sn];
    
    [lbl_order_sn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_region.mas_bottom).offset(3);
        make.left.mas_equalTo(iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    UILabel *lbl_order_sn_value=[[UILabel alloc] init];
    lbl_order_sn_value.textColor=COLOR_BLACK;
    lbl_order_sn_value.font=FONT_SIZE_SMALL;
    lbl_order_sn_value.text=entity.order_sn;
    [section_view addSubview:lbl_order_sn_value];
    
    [lbl_order_sn_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_region.mas_bottom).offset(3);
        make.left.mas_equalTo(lbl_order_region.mas_right);
        make.size.mas_equalTo(CGSizeMake(140, 20));
    }];
    
    UILabel *lbl_shelf_code=[[UILabel alloc] init];
    lbl_shelf_code.textColor=COLOR_GRAY;
    lbl_shelf_code.font=FONT_SIZE_SMALL;
    lbl_shelf_code.text=@"货架号：";
    [section_view addSubview:lbl_shelf_code];
    
    [lbl_shelf_code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_sn.mas_bottom).offset(3);
        make.left.mas_equalTo(iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    UILabel *lbl_shelf_code_value=[[UILabel alloc] init];
    lbl_shelf_code_value.textColor=COLOR_MAIN;
    lbl_shelf_code_value.font=FONT_SIZE_SMALL;
    
    if(entity.shelf_code!=nil&&![entity.shelf_code isEqualToString:@"null"]&&[entity.shelf_code length]>0){
        lbl_shelf_code_value.text=entity.shelf_code;
    }
    else{
        lbl_shelf_code_value.text=@"--";
    }
    
    [section_view addSubview:lbl_shelf_code_value];
    
    [lbl_shelf_code_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_sn.mas_bottom).offset(3);
        make.left.mas_equalTo(lbl_shelf_code.mas_right);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-146, 20));
    }];

    
    UILabel *lbl_order_address=[[UILabel alloc] init];
    lbl_order_address.textColor=COLOR_GRAY;
    lbl_order_address.font=FONT_SIZE_SMALL;
    lbl_order_address.text=@"地址：";
    [section_view addSubview:lbl_order_address];
    
    [lbl_order_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_shelf_code.mas_bottom).offset(3);
        make.left.mas_equalTo(iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    UILabel *lbl_order_address_value=[[UILabel alloc] init];
    lbl_order_address_value.textColor=COLOR_BLACK;
    lbl_order_address_value.font=FONT_SIZE_SMALL;
    lbl_order_address_value.text=entity.address;
    lbl_order_address_value.lineBreakMode=NSLineBreakByTruncatingTail;
    [section_view addSubview:lbl_order_address_value];
    
    [lbl_order_address_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_shelf_code.mas_bottom).offset(3);
        make.left.mas_equalTo(lbl_order_address.mas_right);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-122, 20));
    }];
    
    UILabel *lbl_predict_time=[[UILabel alloc] init];
    lbl_predict_time.textColor=COLOR_GRAY;
    lbl_predict_time.font=FONT_SIZE_SMALL;
    lbl_predict_time.text=@"预计送达：";
    [section_view addSubview:lbl_predict_time];
    
    [lbl_predict_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_address.mas_bottom).offset(3);
        make.left.mas_equalTo(iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    UILabel *lbl_predict_time_value=[[UILabel alloc] init];
    lbl_predict_time_value.textColor=COLOR_BLACK;
    lbl_predict_time_value.font=FONT_SIZE_SMALL;
    
    if(entity.predict_time!=nil&&![entity.predict_time isEqualToString:@"null"]&&[entity.predict_time length]>0){
        lbl_predict_time_value.text=entity.predict_time;
    }
    else{
        lbl_predict_time_value.text=@"--";
    }
    
    [section_view addSubview:lbl_predict_time_value];
    
    [lbl_predict_time_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_address.mas_bottom).offset(3);
        make.left.mas_equalTo(lbl_predict_time.mas_right);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-146, 20));
    }];
    
    UILabel *lbl_delivery_info=[[UILabel alloc] init];
    lbl_delivery_info.textColor=COLOR_GRAY;
    lbl_delivery_info.font=FONT_SIZE_SMALL;
    lbl_delivery_info.text=@"上次配送：";
    [section_view addSubview:lbl_delivery_info];
    
    [lbl_delivery_info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_predict_time.mas_bottom).offset(3);
        make.left.mas_equalTo(iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    UILabel *lbl_delivery_value=[[UILabel alloc] init];
    lbl_delivery_value.textColor=COLOR_BLACK;
    lbl_delivery_value.font=FONT_SIZE_SMALL;
    
    if(entity.delivery_info!=nil&&[entity.delivery_info count]>0){
        DeliveryInfoEntity *obj=(DeliveryInfoEntity *)[entity.delivery_info objectAtIndex:0];
        lbl_delivery_value.text=[NSString stringWithFormat:@"%@-%@ [%@]",obj.flow_name,obj.staff,obj.add_time];
    }
    else{
        lbl_delivery_value.text=@"无";
    }
    
    [section_view addSubview:lbl_delivery_value];
    
    [lbl_delivery_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_predict_time.mas_bottom).offset(3);
        make.left.mas_equalTo(lbl_delivery_info.mas_right);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-142, 20));
    }];
    
    UILabel *lbl_serial_num=[[UILabel alloc] init];
    lbl_serial_num.textColor=COLOR_DARKGRAY;
    lbl_serial_num.font=FONT_SIZE_SMALL;
    lbl_serial_num.text=[NSString stringWithFormat:@"%d",section+1];
    lbl_serial_num.textAlignment = NSTextAlignmentCenter;
    if([entity.is_ready intValue]==0){//订单未准备好
        lbl_serial_num.backgroundColor = [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1];
    }
    else{
        lbl_serial_num.backgroundColor = [UIColor colorWithRed:242/255. green:242/255. blue:242/255. alpha:1];
    }
    
    lbl_serial_num.clipsToBounds=YES;
    lbl_serial_num.layer.cornerRadius=14;
    [section_view addSubview:lbl_serial_num];
    
    [lbl_serial_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(section_view.mas_bottom).offset(-15);
        make.centerX.mas_equalTo(iconView.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    return section_view;
}

-(void)taskCategoryTap:(UIButton *)sender{
    btn_waitDelivery.selected=NO;
    btn_failedDelivery.selected=NO;
    btn_successDelivery.selected=NO;
    sender.selected=YES;
    
    list_status_modal=(int)sender.tag-1000;
    if(list_status_modal==Delivery_Status_Delivering){
        //NSLog(@"tasklist_delivering=>%@",APP_DELEGATE.booter.tasklist_delivering);
        if([APP_DELEGATE.booter.tasklist_delivering count]<=0){
            [self showNoContentView];
        }
        else{
            [self hideNoContentView];
        }
    }
    else if(list_status_modal==Delivery_Status_Finished){
        if([APP_DELEGATE.booter.tasklist_finished count]<=0){
            [self showNoContentView];
        }
        else{
            [self hideNoContentView];
        }
    }
    else if(list_status_modal==Delivery_Status_Failed){
        if([APP_DELEGATE.booter.tasklist_failed count]<=0){
            [self showNoContentView];
        }
        else{
            [self hideNoContentView];
        }
    }
    else if(list_status_modal==Delivery_Status_Multi){
        if([self.taskArr count]<=0){
            [self showNoContentView];
        }
        else{
            [self hideNoContentView];
        }
    }
    [self.tableView reloadData];
}

-(void)reloadTaskList{
    APP_DELEGATE.booter.taskModel.entity.nextpage=@"1";
    [APP_DELEGATE.booter loadTaskList];
}

-(void)loadTaskList{
    [self startLoadingActivityIndicator];
}

-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    [self stopLoadingActivityIndicator];
    if(isSuccess){
        //        if(self.model.entity!=nil){
        //            [self handlerListPage:self.model.entity];
        //            [self.tableView reloadData];
        //        }
        //        else{
        //            NSLog(@"未获取到有效商品数据");
        //        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(list_show_model==1){
        return 1;
    }
    if(tableView.tag<5000){
        if(list_status_modal==Delivery_Status_Delivering){
            return [APP_DELEGATE.booter.tasklist_delivering count];
        }
        else if(list_status_modal==Delivery_Status_Finished){
            return [APP_DELEGATE.booter.tasklist_finished count];
        }
        else if(list_status_modal==Delivery_Status_Failed){
            return [APP_DELEGATE.booter.tasklist_failed count];
        }
        else if(list_status_modal==Delivery_Status_Multi){
            return [self.taskArr count];
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    if(list_show_model==1){
        if(list_status_modal==Delivery_Status_Delivering){
            return [APP_DELEGATE.booter.tasklist_delivering count];
        }
        else if(list_status_modal==Delivery_Status_Finished){
            return [APP_DELEGATE.booter.tasklist_finished count];
        }
        else if(list_status_modal==Delivery_Status_Failed){
            return [APP_DELEGATE.booter.tasklist_failed count];
        }
        else if(list_status_modal==Delivery_Status_Multi){
            return [self.taskArr count];;
        }
    }
    if(tv.tag<5000){//订单包含的包裹种类数据
        if(list_status_modal==Delivery_Status_Delivering){
            return [[APP_DELEGATE.booter.tasklist_delivering objectAtIndex:section].package_arr count];
        }
        else if(list_status_modal==Delivery_Status_Finished){
            return [[APP_DELEGATE.booter.tasklist_finished objectAtIndex:section].package_arr count];
        }
        else if(list_status_modal==Delivery_Status_Failed){
            return [[APP_DELEGATE.booter.tasklist_failed objectAtIndex:section].package_arr count];
            
        }
        else if(list_status_modal==Delivery_Status_Multi){
            return [[self.taskArr  objectAtIndex:section].package_arr count];;
        }
    
    }
    else{//包裹种类中商品数据
        int s=(int)tv.tag-5000;
        if(list_status_modal==Delivery_Status_Delivering){
            return [[APP_DELEGATE.booter.tasklist_delivering objectAtIndex:s].box_goods count];
        }
        else if(list_status_modal==Delivery_Status_Finished){
            return [[APP_DELEGATE.booter.tasklist_finished objectAtIndex:s].box_goods count];
        }
        else if(list_status_modal==Delivery_Status_Failed){
            return [[APP_DELEGATE.booter.tasklist_failed objectAtIndex:s].box_goods count];
        }
        else if(list_status_modal==Delivery_Status_Multi){
            return [[self.taskArr  objectAtIndex:s].box_goods count];;
        }
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(list_show_model==1){
        return 0.1;
    }
    if(tableView.tag<5000){
        return SECTION_HEADER_HEIGHT+15;
    }
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(list_show_model==1){
        return nil;
    }
    if(tableView.tag<5000){
        TaskItemEntity *entity;
        if(list_status_modal==Delivery_Status_Delivering){
            entity= [APP_DELEGATE.booter.tasklist_delivering objectAtIndex:section];
        }
        else if(list_status_modal==Delivery_Status_Finished){
            entity= [APP_DELEGATE.booter.tasklist_finished objectAtIndex:section];
        }
        else if(list_status_modal==Delivery_Status_Failed){
            entity= [APP_DELEGATE.booter.tasklist_failed objectAtIndex:section];
        }
        else if(list_status_modal==Delivery_Status_Multi){
            entity= [self.taskArr  objectAtIndex:section];
        }
        
        return [self getSectionHeaderView:entity andSection:(int)section];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(list_show_model==1){
        return 0.1;
    }
    if(tableView.tag<5000){
        int n=0;
        if(list_status_modal==Delivery_Status_Delivering){
            n= (int)[[APP_DELEGATE.booter.tasklist_delivering objectAtIndex:section].box_goods count];
        }
        else if(list_status_modal==Delivery_Status_Finished){
            n= (int)[[APP_DELEGATE.booter.tasklist_finished objectAtIndex:section].box_goods count];
        }
        else if(list_status_modal==Delivery_Status_Failed){
            n= (int)[[APP_DELEGATE.booter.tasklist_failed objectAtIndex:section].box_goods count];
        }
        else if(list_status_modal==Delivery_Status_Multi){
            n= (int)[[self.taskArr  objectAtIndex:section].box_goods count];;
        }
        
        float height=GOODS_ROW_HEIGHT*n;
        if(height<=0){
            height=CGFLOAT_MIN;
        }
        return height;
    }
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(list_show_model==1){
        return nil;
    }
    if(tableView.tag<5000){
        TaskItemEntity *entity;
        if(list_status_modal==Delivery_Status_Delivering){
            entity= [APP_DELEGATE.booter.tasklist_delivering objectAtIndex:section];
        }
        else if(list_status_modal==Delivery_Status_Finished){
            entity= [APP_DELEGATE.booter.tasklist_finished objectAtIndex:section];
        }
        else if(list_status_modal==Delivery_Status_Failed){
            entity= [APP_DELEGATE.booter.tasklist_failed objectAtIndex:section];
        }
        else if(list_status_modal==Delivery_Status_Multi){
            entity= [self.taskArr  objectAtIndex:section];
        }
        UITableView *goodsTableView=[self getSectionFooterView:(int)section andEntity:entity];
        return goodsTableView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(list_show_model==1){
        NSString *reuseIdetify = @"taskconciseItemCell";
        TaskConciseItemCell *cell = [tv dequeueReusableCellWithIdentifier:reuseIdetify];
        if (cell == nil) {
            cell=[[TaskConciseItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
            cell.opaque=YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if(list_status_modal==Delivery_Status_Delivering){
            cell.entity=[APP_DELEGATE.booter.tasklist_delivering objectAtIndex:indexPath.row];
        }
        else if(list_status_modal==Delivery_Status_Finished){
            cell.entity=[APP_DELEGATE.booter.tasklist_finished objectAtIndex:indexPath.row];
        }
        else if(list_status_modal==Delivery_Status_Failed){
            cell.entity=[APP_DELEGATE.booter.tasklist_failed objectAtIndex:indexPath.row];
        }
        else if(list_status_modal==Delivery_Status_Multi){
            cell.entity=[self.taskArr objectAtIndex:indexPath.row];
        }
        return cell;
    }
    else{
        if(tv.tag<5000){
            NSString *reuseIdetify = @"taskListItemCell";
            TaskItemCell *cell = [tv dequeueReusableCellWithIdentifier:reuseIdetify];
            if (cell == nil) {
                cell = [[TaskItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdetify];
                cell.showsReorderControl = NO;
                cell.accessoryType=UITableViewCellAccessoryNone;
                cell.backgroundColor=COLOR_BG_TABLEVIEWCELL;
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.textLabel.font=FONT_SIZE_MIDDLE;
                cell.textLabel.textColor=COLOR_DARKGRAY;
            }
            
            TaskItemEntity *entity;
            if(list_status_modal==Delivery_Status_Delivering){
                entity=[APP_DELEGATE.booter.tasklist_delivering objectAtIndex:indexPath.section];
            }
            else if(list_status_modal==Delivery_Status_Finished){
                entity=[APP_DELEGATE.booter.tasklist_finished objectAtIndex:indexPath.section];
            }
            else if(list_status_modal==Delivery_Status_Failed){
                entity=[APP_DELEGATE.booter.tasklist_failed objectAtIndex:indexPath.section];
            }
            else if(list_status_modal==Delivery_Status_Multi){
                entity=[self.taskArr objectAtIndex:indexPath.section];
            }
            cell.entity=entity;
            cell.row_index=(int)indexPath.row;
            
            return cell;
        }
        else{
            NSString *identifier=@"GoodsCellIdentifier";
            GoodsListItemCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[GoodsListItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
                cell.showsReorderControl = NO;
                cell.accessoryType=UITableViewCellAccessoryNone;
                cell.backgroundColor=COLOR_BG_TABLEVIEWCELL;
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.textLabel.font=FONT_SIZE_MIDDLE;
                cell.textLabel.textColor=COLOR_DARKGRAY;
            }
            int s=(int)tv.tag-5000;
            pGoodsEntity *entity;
            if(list_status_modal==Delivery_Status_Delivering){
                entity=[[APP_DELEGATE.booter.tasklist_delivering objectAtIndex:s].box_goods objectAtIndex:indexPath.row];
            }
            else if(list_status_modal==Delivery_Status_Finished){
                entity=[[APP_DELEGATE.booter.tasklist_finished objectAtIndex:s].box_goods objectAtIndex:indexPath.row];
            }
            else if(list_status_modal==Delivery_Status_Failed){
                entity=[[APP_DELEGATE.booter.tasklist_failed objectAtIndex:s].box_goods objectAtIndex:indexPath.row];
            }
            else if(list_status_modal==Delivery_Status_Multi){
                entity=[[self.taskArr objectAtIndex:s].box_goods objectAtIndex:indexPath.row];
            }
            cell.entity=(PackageGoodsEntity*)entity;
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(list_show_model==1){
        return 54;
    }
    if(tv.tag<5000){
        return 44;
    }
    return GOODS_ROW_HEIGHT;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
    if(list_show_model==1){
        TaskItemEntity *entity;
        if(list_status_modal==Delivery_Status_Delivering){
            entity=[APP_DELEGATE.booter.tasklist_delivering objectAtIndex:indexPath.row];
        }
        else if(list_status_modal==Delivery_Status_Finished){
            entity=[APP_DELEGATE.booter.tasklist_finished objectAtIndex:indexPath.row];
        }
        else if(list_status_modal==Delivery_Status_Failed){
            entity=[APP_DELEGATE.booter.tasklist_failed objectAtIndex:indexPath.row];
        }
        else if(list_status_modal==Delivery_Status_Multi){
            entity=[self.taskArr objectAtIndex:indexPath.row];
        }
        [self gotoOrderDetailView:entity];
    }
}

-(void)refreshCategoryBtn{
    [btn_waitDelivery setTitle:[NSString stringWithFormat:@"待配送(%d)",(int)[APP_DELEGATE.booter.tasklist_delivering count]] forState:UIControlStateNormal];
    [btn_successDelivery setTitle:[NSString stringWithFormat:@"配送完成(%d)",(int)[APP_DELEGATE.booter.tasklist_finished count]] forState:UIControlStateNormal];
    [btn_failedDelivery setTitle:[NSString stringWithFormat:@"配送失败(%d)",(int)[APP_DELEGATE.booter.tasklist_failed count]] forState:UIControlStateNormal];
}

//配送数据更新
- (void)onTaskUpdate:(NSNotification*)aNotitification{
    [self stopLoadingActivityIndicator];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshCategoryBtn];
        [self.tableView reloadData];
        if(btn_waitDelivery.selected){
            [btn_waitDelivery sendActionsForControlEvents:UIControlEventTouchUpInside];
        }else if(btn_successDelivery.selected){
            [btn_successDelivery sendActionsForControlEvents:UIControlEventTouchUpInside];
        }else if(btn_failedDelivery.selected){
            [btn_failedDelivery sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    });
    [self.tableView.mj_header endRefreshing];
}


-(void)gotoOrderDetailView:(id)sender{
    TaskItemEntity *entity;
    if([sender isKindOfClass:[UIGestureRecognizer class]]){
        int row=(int)((UIGestureRecognizer *)sender).view.tag-7000;
        if(list_status_modal==Delivery_Status_Delivering){
            entity=[APP_DELEGATE.booter.tasklist_delivering objectAtIndex:row];
        }
        else if(list_status_modal==Delivery_Status_Finished){
            entity=[APP_DELEGATE.booter.tasklist_finished objectAtIndex:row];
        }
        else if(list_status_modal==Delivery_Status_Failed){
            entity=[APP_DELEGATE.booter.tasklist_failed objectAtIndex:row];
        }
        else if(list_status_modal==Delivery_Status_Multi){
            entity=[self.taskArr objectAtIndex:row];
        }
    }else{
        entity=(TaskItemEntity *)sender;
    }
    
    OrderDetailViewController *ovc=[[OrderDetailViewController alloc] init];
    ovc.task_entity=entity;
    [self.navigationController pushViewController:ovc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if([self checkLoginStatus] == YES){
        if(!self.taskArr){//不是从首页的一个坐标多个订单过来的
            if(APP_DELEGATE.booter.taskModel.entity.list.count<=0){
                [self startLoadingActivityIndicator];
                APP_DELEGATE.booter.taskModel.entity.nextpage=@"1";
                [APP_DELEGATE.booter loadTaskList];
            }
        }
    }
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
