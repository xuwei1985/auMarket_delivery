//
//  goodsBindViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//
#define CATEGORY_BAR 44.0
#define SECTION_HEADER_HEIGHT 190.0
#define GOODS_ROW_HEIGHT 72.0

#import "PickOrderViewController.h"

@interface PickOrderViewController ()

@end

@implementation PickOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}

-(void)initUI{
    [self setNavigation];
    [self createCategoryView];
    [self setUpTableView];
}

-(void)initData{
    self.list_type=0;
    [self loadPickOrderList];
}

-(void)setNavigation{
    self.title=@"上货";
    
    doneBtn=[[UIButton alloc] initWithFrame:CGRectMake(WIDTH_SCREEN-40, 4, 40, 32)];
    [doneBtn addTarget:self action:@selector(finishPicking) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitle:@"批量完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [doneBtn setTitleColor:COLOR_WHITE forState:UIControlStateHighlighted];
    doneBtn.titleLabel.font=FONT_SIZE_BIG;
    doneBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    UIBarButtonItem *right_Item_cart = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem=right_Item_cart;
}

-(void)createCategoryView{
    blockView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, CATEGORY_BAR)];
    blockView.backgroundColor=COLOR_BG_WHITE;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, blockView.frame.size.height-0.5, blockView.frame.size.width, 0.5);
    layer.backgroundColor = COLOR_BG_LINE_DARK.CGColor;
    [blockView.layer addSublayer:layer];
    [self.view addSubview:blockView];
    
    btn_picking=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn_picking setTitle:@"待上货" forState:UIControlStateNormal];
    [btn_picking setTitleColor:COLOR_DARKGRAY forState:UIControlStateNormal];
    [btn_picking setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    btn_picking.titleLabel.textAlignment=NSTextAlignmentCenter;
    btn_picking.tintColor=COLOR_WHITE;
    btn_picking.titleLabel.font=FONT_SIZE_MIDDLE;
    btn_picking.tag=7000;
    [btn_picking addTarget:self action:@selector(changePickState:) forControlEvents:UIControlEventTouchUpInside];
    [blockView addSubview:btn_picking];
    
    [btn_picking mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(WIDTH_SCREEN/2);
        make.height.mas_equalTo(blockView.mas_height);
    }];
    
    btn_picked=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn_picked setTitle:@"已上货" forState:UIControlStateNormal];
    [btn_picked setTitleColor:COLOR_DARKGRAY forState:UIControlStateNormal];
    [btn_picked setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    btn_picked.titleLabel.textAlignment=NSTextAlignmentCenter;
    btn_picked.tintColor=COLOR_WHITE;
    btn_picked.titleLabel.font=FONT_SIZE_MIDDLE;
    btn_picked.tag=7001;
    [btn_picked addTarget:self action:@selector(changePickState:) forControlEvents:UIControlEventTouchUpInside];
    [blockView addSubview:btn_picked];

    [btn_picked mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(WIDTH_SCREEN/2);
        make.width.mas_equalTo(WIDTH_SCREEN/2);
        make.height.mas_equalTo(blockView.mas_height);
    }];
    
    if(self.list_type==0){
        btn_picking.selected=YES;
    }
    else{
        btn_picked.selected=YES;
    }
}

-(void)changePickState:(UIButton *)sender{
    int btn_index=(int)sender.tag-7000;
    if(self.list_type!=btn_index)
    {
        if(!self.model.isLoading){
            self.list_type=btn_index;
            ((UIButton *)[blockView viewWithTag:7000]).selected=NO;
            ((UIButton *)[blockView viewWithTag:7001]).selected=NO;
            sender.selected=YES;
            if(self.list_type==0){
                doneBtn.hidden=NO;
            }
            else{
                doneBtn.hidden=YES;
            }
            [self loadPickOrderList];
        }
    }
}

-(void)setUpTableView{
    float table_height=HEIGHT_SCREEN-64-CATEGORY_BAR-48;
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, CATEGORY_BAR, WIDTH_SCREEN,table_height) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 36)];
    view.backgroundColor = COLOR_CLEAR;
//
//    [self.tableView setTableHeaderView:view];
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadPickOrderList)];

//    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing]; // 松手刷新
    header.stateLabel.font = FONT_SIZE_SMALL;
    header.stateLabel.textColor = COLOR_DARKGRAY;
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden=YES;
//    [header beginRefreshing];

    self.tableView.mj_header=header;
}

-(UITableView *)getSectionFooterView:(int)section andEntity:(PickItemEntity *)entity{
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

-(UIView *)getSectionHeaderView:(PickItemEntity *)entity andSection:(int)section{
    UILabel *lbl_contact;
    UILabel *lbl_package_num;
    UIView *section_view;

    section_view=[[UIView alloc] initWithFrame:CGRectMake(0, 15, WIDTH_SCREEN, SECTION_HEADER_HEIGHT)];
    section_view.userInteractionEnabled=YES;
    section_view.tag=7000+section;
    [section_view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoOrderDetailView:)]];
    
    if([entity.is_ready intValue]==0){//订单未准备好
        section_view.backgroundColor=COLOR_BG_IMAGEVIEW;
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
    lbl_order_region.font=FONT_SIZE_MIDDLE;
    lbl_order_region.text=@"区域：";
    [section_view addSubview:lbl_order_region];
    
    [lbl_order_region mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_view.mas_bottom).offset(15);
        make.left.mas_equalTo(iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(58, 20));
    }];

    UILabel *lbl_order_region_value=[[UILabel alloc] init];
    lbl_order_region_value.textColor=COLOR_DARKGRAY;
    lbl_order_region_value.font=FONT_SIZE_MIDDLE;
    lbl_order_region_value.text=entity.block_name;
    [section_view addSubview:lbl_order_region_value];
    
    [lbl_order_region_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_view.mas_bottom).offset(15);
        make.left.mas_equalTo(lbl_order_region.mas_right);
        make.size.mas_equalTo(CGSizeMake(144, 20));
    }];
    
    UILabel *lbl_order_sn=[[UILabel alloc] init];
    lbl_order_sn.textColor=COLOR_GRAY;
    lbl_order_sn.font=FONT_SIZE_MIDDLE;
    lbl_order_sn.text=@"订单号：";
    [section_view addSubview:lbl_order_sn];
    
    [lbl_order_sn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_region.mas_bottom).offset(5);
        make.left.mas_equalTo(iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(58, 20));
    }];
    
    UILabel *lbl_order_sn_value=[[UILabel alloc] init];
    lbl_order_sn_value.textColor=COLOR_DARKGRAY;
    lbl_order_sn_value.font=FONT_SIZE_MIDDLE;
    lbl_order_sn_value.text=entity.order_sn;
    [section_view addSubview:lbl_order_sn_value];
    
    [lbl_order_sn_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_region.mas_bottom).offset(5);
        make.left.mas_equalTo(lbl_order_region.mas_right);
        make.size.mas_equalTo(CGSizeMake(140, 20));
    }];
    
    UILabel *lbl_order_address=[[UILabel alloc] init];
    lbl_order_address.textColor=COLOR_GRAY;
    lbl_order_address.font=FONT_SIZE_MIDDLE;
    lbl_order_address.text=@"地址：";
    [section_view addSubview:lbl_order_address];
    
    [lbl_order_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_sn.mas_bottom).offset(5);
        make.left.mas_equalTo(iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(58, 20));
    }];
    
    UILabel *lbl_order_address_value=[[UILabel alloc] init];
    lbl_order_address_value.textColor=COLOR_DARKGRAY;
    lbl_order_address_value.font=FONT_SIZE_MIDDLE;
    lbl_order_address_value.text=entity.address;
    lbl_order_address_value.lineBreakMode=NSLineBreakByTruncatingTail;
    [section_view addSubview:lbl_order_address_value];
    
    [lbl_order_address_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_sn.mas_bottom).offset(5);
        make.left.mas_equalTo(lbl_order_address.mas_right);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-116, 20));
    }];
    
    UILabel *lbl_predict_time=[[UILabel alloc] init];
    lbl_predict_time.textColor=COLOR_GRAY;
    lbl_predict_time.font=FONT_SIZE_MIDDLE;
    lbl_predict_time.text=@"预计送达：";
    [section_view addSubview:lbl_predict_time];
    
    [lbl_predict_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_address.mas_bottom).offset(5);
        make.left.mas_equalTo(iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(76, 20));
    }];
    
    UILabel *lbl_predict_time_value=[[UILabel alloc] init];
    lbl_predict_time_value.textColor=COLOR_DARKGRAY;
    lbl_predict_time_value.font=FONT_SIZE_MIDDLE;
    
    if(entity.predict_time!=nil&&![entity.predict_time isEqualToString:@"null"]&&[entity.predict_time length]>0){
        lbl_predict_time_value.text=entity.predict_time;
    }
    else{
        lbl_predict_time_value.text=@"--";
    }
    
    [section_view addSubview:lbl_predict_time_value];
    
    [lbl_predict_time_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_order_address.mas_bottom).offset(5);
        make.left.mas_equalTo(lbl_predict_time.mas_right);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-146, 20));
    }];
    
    UILabel *lbl_shelf_code=[[UILabel alloc] init];
    lbl_shelf_code.textColor=COLOR_GRAY;
    lbl_shelf_code.font=FONT_SIZE_MIDDLE;
    lbl_shelf_code.text=@"货架号：";
    [section_view addSubview:lbl_shelf_code];
    
    [lbl_shelf_code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_predict_time.mas_bottom).offset(5);
        make.left.mas_equalTo(iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(76, 20));
    }];
    
    UILabel *lbl_shelf_code_value=[[UILabel alloc] init];
    lbl_shelf_code_value.textColor=COLOR_MAIN;
    lbl_shelf_code_value.font=FONT_SIZE_MIDDLE;
    
    if(entity.shelf_code!=nil&&![entity.shelf_code isEqualToString:@"null"]&&[entity.shelf_code length]>0){
        lbl_shelf_code_value.text=entity.shelf_code;
    }
    else{
        lbl_shelf_code_value.text=@"--";
    }
    
    [section_view addSubview:lbl_shelf_code_value];
    
    [lbl_shelf_code_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lbl_predict_time.mas_bottom).offset(5);
        make.left.mas_equalTo(lbl_shelf_code.mas_right);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN-146, 20));
    }];
    
//    line_view=[[UIView alloc] init];
//    line_view.backgroundColor=COLOR_BG_VIEW;
//    [section_view addSubview:line_view];
//
//    [line_view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(lbl_predict_time.mas_bottom).offset(12);
//        make.left.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN, 1));
//    }];
    
    return section_view;
}

-(void)reloadPickOrderList{
    if (!self.tableView.isLoading)
    {
        self.model.entity.next=0;
        self.tableView.isFirstLoad=YES;
        [self.tableView reloadData];
        [self loadPickOrderList];
    }
    
}

//请求订单下的要拣货的订单
-(void)loadPickOrderList{
    [self startLoadingActivityIndicator];
    [self.model loadPickOrderWithListType:self.list_type];
}

-(void)finishGoodsPick:(PickItemEntity *)entity{
    [self startLoadingActivityIndicator];
    //current_confirm_path
    NSString *package_type=[[[entity.package_arr objectAtIndex:current_confirm_path.row] objectForKey:@"icon"] stringByReplacingOccurrencesOfString:@"c_" withString:@""];
    [[entity.package_arr objectAtIndex:current_confirm_path.row] setValue:@"1" forKey:@"picked"];
    
    //判断是否这是最后一个上货包裹
    int type=0;
    
    if([self isLastestPackage:entity]){
        type=1;
    }
    else{
        type=0;
    }
    [self.tableView reloadData];
    [self.model finishPickPackage:type andOrderId:entity.order_id andDeliveryId:entity.sid andPackageType:package_type];
}

//判断是否这是最后一个上货包裹
-(BOOL)isLastestPackage:(PickItemEntity *)entity{
    int num_all=0;
    int num_pick=0;
    NSDictionary *dic;
    for (int i=0; i<entity.package_arr.count; i++) {
        dic=[entity.package_arr objectAtIndex:i];
        if([[dic objectForKey:@"number"] intValue]>0){
            if([[dic objectForKey:@"picked"] intValue]==1){
                num_pick++;
            }
            num_all++;
        }
    }
    
    if(num_all-num_pick<=0){
        return YES;
    }
    else{
        return NO;
    }
}


//批量拣货完成
-(void)finishPicking{
    [self showAllPickConfirm];
}

-(void)showAllPickConfirm{
    NSString *tip_title=@"确认商品全部上货完成吗？";
    if (_inputAlertView==nil) {
        _inputAlertView = [[UIAlertView alloc] initWithTitle:tip_title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    _inputAlertView.title=tip_title;
    [_inputAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    UITextField *nameField = [_inputAlertView textFieldAtIndex:0];
    nameField.delegate=self;
    nameField.placeholder =[NSString stringWithFormat:@"请输入确认码"];
    nameField.keyboardType=UIKeyboardTypeNumberPad;
    [_inputAlertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        NSString *txt_value=[nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if([txt_value isEqualToString:@"1234"]){
            [self getAllPackageIds];
            if(all_delivery_ids==nil||all_delivery_ids.length<=0){
                [self showToastWithText:@"无有效订单"];
            }
            else{
                [self startLoadingActivityIndicator];
                [self.model finishAllPackagePick:all_order_ids andDeliveryId:all_delivery_ids];
            }
            
        }
        else{
            [self showToastWithText:@"确认码不正确"];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //判断是否为删除字符，如果为删除则让执行
    char c=[string UTF8String][0];
    if (c=='\000') {
        //numberOfCharsLabel.text=[NSString stringWithFormat:@"%d",50-[[self.textView text] length]+1];
        return YES;
    }
    //长度限制
    if([textField.text length] > 10){
        textField.text = [textField.text substringToIndex:10];
        return NO;
    }
    
    return YES;
}


-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    [self stopLoadingActivityIndicator];
    
    if(model==self.model&&self.model.requestTag==1001){
        [self.tableView.mj_header endRefreshing];
        
        
        if(isSuccess){
            [self.tableView reloadData];
            if(self.model.entity.list&&self.model.entity.list.count>0){
                [self hideNoContentView];
            }
            else{
                [self.tableView reloadData];
                [self showNoContentView];
            }
        }
    }
    else if(model==self.model&&self.model.requestTag==1002){
        if(isSuccess){
            if([self isLastestPackage:[self.model.entity.list objectAtIndex:current_confirm_path.section]]){
                [self showToastWithText:@"拣货完成"];
                [self loadPickOrderList];
            }
            else{
                [self showToastWithText:@"保存成功"];
            }
        }
    }
    else if(model==self.model&&self.model.requestTag==1003){
        if(isSuccess){
            [self showToastWithText:@"拣货完成"];
            
            [self.model.entity.list removeAllObjects];
            [self.tableView reloadData];

            btn_picking.selected=NO;
            btn_picked.selected=YES;
            self.list_type=1;
            doneBtn.hidden=YES;

            [self loadPickOrderList];
        }
    }
}


-(void)getAllPackageIds{
    if(self.model.entity.list){
        all_order_ids=[NSMutableString stringWithFormat:@""];
        all_delivery_ids=[NSMutableString stringWithFormat:@""];
        for (PickItemEntity *obj in self.model.entity.list ) {
            if([obj.is_ready intValue]==1){
                [all_order_ids appendFormat:@"%@,",obj.order_id];
                [all_delivery_ids appendFormat:@"%@,",obj.sid];
            }
        }
        
        if(all_order_ids.length>0){
            [all_order_ids deleteCharactersInRange:NSMakeRange((all_order_ids.length-1), 1)];
            [all_delivery_ids deleteCharactersInRange:NSMakeRange((all_delivery_ids.length-1), 1)];
        }
    }
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag<5000){
        return self.model.entity.list.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    if(tv.tag<5000){
        return [[self.model.entity.list objectAtIndex:section].package_arr count];
    }
    int s=(int)tv.tag-5000;
    if([self.model.entity.list objectAtIndex:s].box_goods){
        return [[self.model.entity.list objectAtIndex:s].box_goods count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView.tag<5000){
        return SECTION_HEADER_HEIGHT+15;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(tableView.tag<5000){
        PickItemEntity *entity=[self.model.entity.list objectAtIndex:section];
        return [self getSectionHeaderView:entity andSection:section];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(tableView.tag<5000){
        int n=(int)[self.model.entity.list objectAtIndex:section].box_goods.count;
        float height=GOODS_ROW_HEIGHT*n;
        if(height<=0){
            height=CGFLOAT_MIN;
        }
        return height;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(tableView.tag<5000){
        PickItemEntity *entity=[self.model.entity.list objectAtIndex:section];
        UITableView *goodsTableView=[self getSectionFooterView:(int)section andEntity:entity];
        return goodsTableView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tv.tag<5000){
        NSString *identifier=@"PickCellIdentifier";
        PickOrderCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[PickOrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.showsReorderControl = NO;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.backgroundColor=COLOR_BG_TABLEVIEWCELL;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font=FONT_SIZE_MIDDLE;
            cell.textLabel.textColor=COLOR_DARKGRAY;
        }
        
        PickItemEntity *entity=[self.model.entity.list objectAtIndex:indexPath.section];
        cell.entity=entity;
        cell.row_index=(int)indexPath.row;
        cell.list_type=self.list_type;
        
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
        PackageGoodsEntity *entity=[[self.model.entity.list objectAtIndex:s].box_goods objectAtIndex:indexPath.row];
        cell.entity=entity;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tv.tag<5000){
        return 44;
    }
    return GOODS_ROW_HEIGHT;
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag<5000){
        if(self.list_type==0){
            return YES;
        }
        else{
            return NO;
        }
    }
    return NO;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"完成" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        PickItemEntity *entity=[self.model.entity.list objectAtIndex:indexPath.section];
        current_confirm_path=indexPath;
        [self finishGoodsPick:entity];
        
    }];

    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

-(void)gotoOrderDetailView:(UITapGestureRecognizer *)sender{
    int index=(int)sender.view.tag-7000;
    PickItemEntity *entity=[self.model.entity.list objectAtIndex:index];
    
    OrderDetailViewController *ovc=[[OrderDetailViewController alloc] init];
    ovc.order_id=entity.order_id;
    [self.navigationController pushViewController:ovc animated:YES];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(PickModel *)model{
    if(!_model){
        _model=[[PickModel alloc] init];
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
