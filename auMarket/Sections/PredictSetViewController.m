//
//  PickViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2018/1/4.
//  Copyright © 2018年 daao. All rights reserved.
//
#define CATEGORY_BAR 44.0
#import "PredictSetViewController.h"

@interface PredictSetViewController ()

@end

@implementation PredictSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

-(void)initData{
    [self loadShippingTime];
}

-(void)initUI{
    [self setNavigation];
    [self createHeaderAndFooter];
    [self setUpTableView];
}

-(void)setNavigation{
    self.title=@"送达时间设置";
}

//MARK: 创建列表视图
-(void)setUpTableView{
    float table_height=HEIGHT_SCREEN-HEIGHT_STATUS_AND_NAVIGATION_BAR-HEIGHT_TAB_BAR;
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN,table_height) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    self.tableView.tableHeaderView=headerView;
    self.tableView.footerView=footerView;
    
    [self.tableView setTableHeaderView: headerView];
    [self.tableView setTableFooterView: footerView];
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
}

//MARK: 列表头尾视图
-(void)createHeaderAndFooter{
    headerView=[[PredictTimeSectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 80)];
    headerView.delegate=self;
    
    
    footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 60)];
    postBtn = [[UIButton alloc] init];
    [postBtn addTarget:self action:@selector(doPostPredictSetting) forControlEvents:UIControlEventTouchUpInside];
    [postBtn setTitle:@"提交设置" forState:UIControlStateNormal];
    [postBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [postBtn setTitleColor:COLOR_WHITE forState:UIControlStateHighlighted];
    postBtn.backgroundColor = COLOR_MAIN;
    postBtn.layer.cornerRadius=4;
    postBtn.clipsToBounds=YES;
    postBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    postBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    [footerView addSubview:postBtn];
    
    [postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerView);
        make.centerY.mas_equalTo(footerView);
        make.width.mas_equalTo(WIDTH_SCREEN-24);
        make.height.mas_equalTo(48);
    }];
}

-(void)doPostPredictSetting{
    [[AlertBlockView sharedInstance] showChoiceAlert:@"确认提交配送设置吗？" button1Title:@"确定" button2Title:@"取消" completion:^(int index) {
        if(index==0){
            [self postPredictSetting];
        }
    }];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView=[UIView new];
    UILabel *sectionLbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 30)];
    sectionLbl.font=[UIFont boldSystemFontOfSize:14.0];
    sectionLbl.textColor=COLOR_BLACK;
    sectionLbl.text=@"10-20";
    [sectionView addSubview:sectionLbl];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"PredictSettingCellIdentifier";
    PredictSettingCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PredictSettingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.showsReorderControl = NO;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.backgroundColor= [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.begin_time=@"11:00";
    cell.end_time=@"18:00";
    cell.delegate=self;
    cell.row_index=(int)indexPath.section;
    [cell showData];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:NO];
    PredictSettingCell *cell=[tv cellForRowAtIndexPath:indexPath];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

//MARK: 加载配送员今天的配送时间段
-(void)loadShippingTime{
    [self.model loadDeliveryTimeSection];
}


-(void)postPredictSetting{
    [self startLoadingActivityIndicator];
    //[self.model send_predict_sms:[self getSelectedOrdersId]];
}

-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    [self stopLoadingActivityIndicator];
    
//    if(model==self.model){
//        if(model.requestTag==1001){
//            if(isSuccess){
//                if(self.model.entity.list!=nil){
//                    [self.tableView reloadData];
//                    if([self.model.entity.list count]<=0){
//                        _selectAllBtn.selected=NO;
//                        [_sumBtn setTitle:[NSString stringWithFormat:@"发送"] forState:UIControlStateNormal];
//                        [self showNoContentView];
//                    }else{
//                        [self hideNoContentView];
//                    }
//                }
//            }
//        }
//        else if(model.requestTag==1002){
//            if(isSuccess){
//                [self showToastWithText:@"删除成功"];
//                [self loadOrders];
//            }
//        }
//        else if(model.requestTag==1003){
//            if(isSuccess){
//                [self showToastWithText:@"发送成功"];
//                [self loadOrders];
//            }
//        }
//    }
}

//MARK: 选择的预计送达时间的点击事件
-(void)pickerDoneClicked:(id)sender{
    NSInteger row=[predictTimePicker selectedRowInComponent:0];
    predict_select_index=(int)row;
    NSString *valueStr=[predict_time_arr objectAtIndex:row].time_range;
    [self setTaskItemPredictTime:valueStr];
}

-(TaskModel *)model{
    if(!_model){
        _model=[[TaskModel alloc] init];
        _model.delegate=self;
    }
    return _model;
}

-(void)timeSectionClick{
    NSLog(@"timeSectionClick");
}

-(void)requestNumClick{
    NSLog(@"requestNumClick");
}

-(void)confirmClick{
    
    NSLog(@"confirmClick");
}

-(void)startTimeClick:(int)row_index{
    NSLog(@"startTimeClick:%d",row_index);
}

-(void)endTimeClick:(int)row_index{
    NSLog(@"endTimeClick:%d",row_index);
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
