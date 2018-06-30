//
//  PickViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2018/1/4.
//  Copyright © 2018年 daao. All rights reserved.
//

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
    [self setUpTableView];
    [self createBottomView];
}

-(void)setNavigation{
    self.title=@"送达时间提醒";
    
//    UIBarButtonItem *left_Item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"hs"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(gotoPickedGoodsView)];
//    self.navigationItem.leftBarButtonItem=left_Item;
    
    UIBarButtonItem *right_Item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"del"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(gotoPickingGoodsView)];
    self.navigationItem.rightBarButtonItem=right_Item;
}

//-(void)addNotification{
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadOrders) name:TASK_ORDER_NOTIFICATION object:nil];
//}
//
//- (void)removeNotification{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TASK_ORDER_NOTIFICATION" object:nil];
//}

-(void)createBottomView{
    _summaryView_bottom=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 44)];
    _summaryView_bottom.backgroundColor=COLOR_BG_WHITE;
    [self.view addSubview:_summaryView_bottom];
    
    [_summaryView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).offset(-44);
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
    [_sumBtn addTarget:self action:@selector(gotoPickList) forControlEvents:UIControlEventTouchUpInside];
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
    float table_height=HEIGHT_SCREEN-64-48-44;
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN,table_height) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
    
     MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOrders)];
    
//    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing]; // 松手刷新
    header.stateLabel.font = FONT_SIZE_SMALL;
    header.stateLabel.textColor = COLOR_DARKGRAY;
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden=YES;
//    [header beginRefreshing];
    
    self.tableView.mj_header=header;
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
    [cell selDataId:^(NSString *order_id,int action) {
        [self handlerOrdersSelect];
    }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    TaskItemEntity *entity=[self.model.entity.list objectAtIndex:indexPath.row];
    return 175;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:NO];
    predictSmsTaskCell *cell=[tv cellForRowAtIndexPath:indexPath];
    [cell toggleOrderSel];
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
    
    [self.model predict_task_list];
}



-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    [self stopLoadingActivityIndicator];
    
    if(model==self.model){
        if(model.requestTag==1001){
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
