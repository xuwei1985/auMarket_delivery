//
//  PickViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2018/1/4.
//  Copyright © 2018年 daao. All rights reserved.
//
#define CATEGORY_BAR 44.0
#import "SmsTaskViewController.h"

@interface SmsTaskViewController ()

@end

@implementation SmsTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

-(void)initData{
    [self loadOrders];
}

-(void)initUI{
    [self setNavigation];
    [self createCategoryView];
    [self setUpTableView];
    [self createBottomView];
}

-(void)setNavigation{
    self.title=@"送达时间提醒";
    
//    UIBarButtonItem *left_Item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"hs"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(gotoPickedGoodsView)];
//    self.navigationItem.leftBarButtonItem=left_Item;
    
    right_Item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"del"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showDeleteConfirm)];
    self.navigationItem.rightBarButtonItem=right_Item;
}

//-(void)addNotification{
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadOrders) name:TASK_ORDER_NOTIFICATION object:nil];
//}
//
//- (void)removeNotification{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TASK_ORDER_NOTIFICATION" object:nil];
//}

-(void)createCategoryView{
    blockView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, CATEGORY_BAR)];
    blockView.backgroundColor=COLOR_BG_WHITE;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, blockView.frame.size.height-0.5, blockView.frame.size.width, 0.5);
    layer.backgroundColor = COLOR_BG_LINE_DARK.CGColor;
    [blockView.layer addSublayer:layer];
    [self.view addSubview:blockView];
    
    btn_picking=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn_picking setTitle:@"待发送" forState:UIControlStateNormal];
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
    [btn_picked setTitle:@"已发送" forState:UIControlStateNormal];
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
    
    if(btn_index==0){
        self.navigationItem.rightBarButtonItem=right_Item;
        _summaryView_bottom.hidden=NO;
        float table_height=HEIGHT_SCREEN-64-44-CATEGORY_BAR;
        self.tableView.frame=CGRectMake(0, CATEGORY_BAR, WIDTH_SCREEN,table_height);
    }
    else{
        self.navigationItem.rightBarButtonItem=nil;
        _summaryView_bottom.hidden=YES;
        float table_height=HEIGHT_SCREEN-64-CATEGORY_BAR;
        self.tableView.frame=CGRectMake(0, CATEGORY_BAR, WIDTH_SCREEN,table_height);
    }
    
    if(self.list_type!=btn_index)
    {
        if(!self.model.isLoading){
            self.list_type=btn_index;
            ((UIButton *)[blockView viewWithTag:7000]).selected=NO;
            ((UIButton *)[blockView viewWithTag:7001]).selected=NO;
            sender.selected=YES;
            
            [self loadOrders];
        }
    }
}

-(void)createBottomView{
    _summaryView_bottom=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, (IS_IPhoneX?78:44))];
    _summaryView_bottom.backgroundColor=COLOR_BG_WHITE;
    [self.view addSubview:_summaryView_bottom];
    
    [_summaryView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).offset((IS_IPhoneX?-78:-44));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(WIDTH_SCREEN);
        make.height.mas_equalTo(44);
    }];

    UIView *_baseLineView=[[UIView alloc] init];
    _baseLineView.backgroundColor=COLOR_BG_TABLESEPARATE;
    [_summaryView_bottom addSubview:_baseLineView];
    
    [_baseLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_summaryView_bottom.mas_top);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(WIDTH_SCREEN);
        make.height.mas_equalTo(0.5);
    }];
    
    _sumBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _sumBtn.frame=CGRectMake(WIDTH_SCREEN-110, 0,110, 44);
    [_sumBtn setTitle:@"发送" forState:UIControlStateNormal];
    _sumBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    _sumBtn.backgroundColor=COLOR_MAIN;
    _sumBtn.titleLabel.font=FONT_SIZE_BIG;
    [_sumBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [_sumBtn addTarget:self action:@selector(doPredictSmsSending) forControlEvents:UIControlEventTouchUpInside];
    [_summaryView_bottom addSubview:_sumBtn];
    
   
    _selectAllBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _selectAllBtn.frame=CGRectMake(10, 0,72, 44);
    [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    _selectAllBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    _selectAllBtn.backgroundColor=COLOR_CLEAR;
    _selectAllBtn.titleLabel.font=FONT_SIZE_MIDDLE;
    [_selectAllBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [_selectAllBtn setImage:[UIImage imageNamed:@"option_off"] forState:UIControlStateNormal];
    [_selectAllBtn setImage:[UIImage imageNamed:@"option_on"] forState:UIControlStateSelected];
    [_selectAllBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, 0.0)];
    [_selectAllBtn addTarget:self action:@selector(selectAllOrders:) forControlEvents:UIControlEventTouchUpInside];
    [_summaryView_bottom addSubview:_selectAllBtn];
}

-(void)setUpTableView{
    float table_height=HEIGHT_SCREEN-HEIGHT_STATUS_AND_NAVIGATION_BAR-HEIGHT_TAB_BAR-CATEGORY_BAR;
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, CATEGORY_BAR, WIDTH_SCREEN,table_height) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
    
//     MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOrders)];
//
////    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing]; // 松手刷新
//    header.stateLabel.font = FONT_SIZE_SMALL;
//    header.stateLabel.textColor = COLOR_DARKGRAY;
//    header.automaticallyChangeAlpha = YES;
//    header.lastUpdatedTimeLabel.hidden=YES;
////    [header beginRefreshing];
//
//    self.tableView.mj_header=header;
}

-(void)selectAllOrders:(UIButton *)sender{
    for(int i=0;i<self.model.entity.list.count;i++){
        [self.model.entity.list objectAtIndex:i].selected=!sender.selected;
    }
    
    sender.selected=!sender.selected;
    
    if(sender.selected){
        [_sumBtn setTitle:[NSString stringWithFormat:@"发送(%ld)",self.model.entity.list.count] forState:UIControlStateNormal];
    }
    else{
         [_sumBtn setTitle:[NSString stringWithFormat:@"发送"] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

-(void)handlerOrdersSelect{
    int sel_num=0;
    for(int i=0;i<self.model.entity.list.count;i++){
        if([self.model.entity.list objectAtIndex:i].selected){
            sel_num++;
        }
    }
    
    if(sel_num==0){
        _selectAllBtn.selected=NO;
    }
    else if(sel_num==self.model.entity.list.count){
        _selectAllBtn.selected=YES;
    }
    
    if(sel_num>0){
        [_sumBtn setTitle:[NSString stringWithFormat:@"发送(%d)",sel_num] forState:UIControlStateNormal];
    }
    else{
        [_sumBtn setTitle:[NSString stringWithFormat:@"发送"] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

-(NSString *)getSelectedOrdersId{
    NSString *order_ids=@"";
    for(int i=0;i<self.model.entity.list.count;i++){
        if([self.model.entity.list objectAtIndex:i].selected){
            order_ids=[NSString stringWithFormat:@"%@%@,",order_ids,[self.model.entity.list objectAtIndex:i].order_id];
        }
    }
    if(order_ids.length>0){
        order_ids=[order_ids substringWithRange:NSMakeRange(0, order_ids.length-1)];
    }
    return order_ids;
}

-(void)showDeleteConfirm{
    int n=0;
    for(int i=0;i<self.model.entity.list.count;i++){
        if([self.model.entity.list objectAtIndex:i].selected){
            n++;
            break;
        }
    }
    if(n>0){
        NSString *tip_title=@"确认删除所选发送记录吗？";
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
    else{
        [self showToastWithText:@"请选择要删除的记录"];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        NSString *txt_value=[nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if([txt_value isEqualToString:@"1234"]){
            [self deletePredictSms];
        }
        else{
            [self showToastWithText:@"确认码不正确"];
        }
    }
}

-(void)doPredictSmsSending{
    if([[self getSelectedOrdersId] length]>0){
        [[AlertBlockView sharedInstance] showChoiceAlert:@"确认发送配送信息吗？" button1Title:@"确定" button2Title:@"取消" completion:^(int index) {
            if(index==0){
                [self sendPredictSms];
            }
        }];
    }
    else{
        [self showToastWithText:@"没有选择需要发送的记录"];
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


#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return self.model.entity.list.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"pickCellIdentifier";
    predictSmsTaskCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[predictSmsTaskCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.showsReorderControl = NO;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.backgroundColor=COLOR_BG_TABLEVIEWCELL;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TaskItemEntity *entity=[self.model.entity.list objectAtIndex:indexPath.row];
    cell.entity=entity;
    cell.list_model=self.list_type;
    [cell selDataId:^(NSString *order_id,int action) {
        [self handlerOrdersSelect];
    }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskItemEntity *entity=[self.model.entity.list objectAtIndex:indexPath.row];
    float h=[Common HeightOfLabel:entity.address ForFont:FONT_SIZE_MIDDLE withWidth:(WIDTH_SCREEN-145)];
    return 185+h;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:NO];
    predictSmsTaskCell *cell=[tv cellForRowAtIndexPath:indexPath];
    if(self.list_type==0){
        [cell toggleDataSel];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

-(void)loadOrders{
    if(!self.tableView.mj_header.isRefreshing){
        [self startLoadingActivityIndicator];
    }
    [self.model predict_task_listWithListType:self.list_type];
}

-(void)deletePredictSms{
    [self startLoadingActivityIndicator];
    [self.model delete_predict_sms:[self getSelectedOrdersId]];
}

-(void)sendPredictSms{
    [self startLoadingActivityIndicator];
    [self.model send_predict_sms:[self getSelectedOrdersId]];
}

-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    [self stopLoadingActivityIndicator];
    
    if(model==self.model){
        if(model.requestTag==1001){
            if(isSuccess){
                if(self.model.entity.list!=nil){
                    [self.tableView reloadData];
                    if([self.model.entity.list count]<=0){
                        _selectAllBtn.selected=NO;
                        [_sumBtn setTitle:[NSString stringWithFormat:@"发送"] forState:UIControlStateNormal];
                        [self showNoContentView];
                    }else{
                        [self hideNoContentView];
                    }
                }
            }
        }
        else if(model.requestTag==1002){
            if(isSuccess){
                [self showToastWithText:@"删除成功"];
                [self loadOrders];
            }
        }
        else if(model.requestTag==1003){
            if(isSuccess){
                [self showToastWithText:@"发送成功"];
                [self loadOrders];
            }
        }
    }
}


-(PredictTaskModel *)model{
    if(!_model){
        _model=[[PredictTaskModel alloc] init];
        _model.delegate=self;
    }
    return _model;
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
