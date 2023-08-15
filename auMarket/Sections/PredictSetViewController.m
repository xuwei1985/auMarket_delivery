//
//  PickViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2018/1/4.
//  Copyright © 2018年 daao. All rights reserved.
//
#define CATEGORY_BAR 44.0
#define PREDICT_PICKER_HEIGHT 250

#import "PredictSetViewController.h"

@interface PredictSetViewController ()

@end

@implementation PredictSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

//MARK: 数据初始化
-(void)initData{
    predict_time_arr=[[NSMutableArray alloc] init];
    predict_section_arr=[[NSMutableArray<TimeItemEntity *> alloc] init];
    predict_data_arr=[[NSMutableArray<PredictTimeEntity *> alloc] init];
    request_num_arr=@[@"5",@"10",@"20",@"30",@"40",@"50"];
    request_num=10; //默认的批处理订单预计送达时间的分割数量（即20单为一段批量设置）
    
    [self loadShippingTime];
    [self generatePredictTime];
}

//MARK: 视图初始化
-(void)initUI{
    [self setNavigation];
    [self createHeaderAndFooter];
    [self setUpTableView];
    [self createPredictTimeView];
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
    [self.tableView.footerView setHidden:YES];
    
    [self.tableView setTableHeaderView: headerView];
    [self.tableView setTableFooterView: footerView];
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
}

//MARK: 列表头尾视图
-(void)createHeaderAndFooter{
    headerView=[[PredictTimeSectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 80)];
    headerView.delegate=self;
    headerView.request_num=request_num;
    
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

//MARK: 预计送达时间视图创建
-(void)createPredictTimeView{
    _txt_predict=[[UITextField alloc] initWithFrame:CGRectZero];
    _txt_predict.delegate=self;
    [self.view addSubview:_txt_predict];
    
    predictTimePicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, HEIGHT_SCREEN-64, WIDTH_SCREEN, PREDICT_PICKER_HEIGHT)];
    predictTimePicker.backgroundColor=COLOR_WHITE;
    //设置阴影的颜色
    predictTimePicker.layer.shadowColor=[UIColor blackColor].CGColor;
    //设置阴影的偏移量，如果为正数，则代表为往右边偏移
    predictTimePicker.layer.shadowOffset=CGSizeMake(0, -5);
    //设置阴影的透明度(0~1之间，0表示完全透明)
    predictTimePicker.layer.shadowOpacity=0.4;
    predictTimePicker.showsSelectionIndicator = YES;
    predictTimePicker.backgroundColor=COLOR_BG_WHITE;
    predictTimePicker.delegate=self;
    predictTimePicker.dataSource=self;
    predictTimePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _txt_predict.inputView=predictTimePicker;
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlackTranslucent;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.barTintColor=COLOR_BG_WHITE;
    keyboardDoneButtonView.tintColor = COLOR_MAIN;
    [keyboardDoneButtonView sizeToFit];
    
    UIView  *line=[[UIView alloc] initWithFrame:CGRectMake(0, keyboardDoneButtonView.frame.size.height-0.5, keyboardDoneButtonView.frame.size.width, 0.5)];
    line.backgroundColor=COLOR_BG_VIEW;
    [keyboardDoneButtonView addSubview:line];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                     style:UIBarButtonItemStylePlain target:self
                                                                    action:@selector(closePredictTimeView)];
    cancelButton.tintColor=COLOR_DARKGRAY;
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(pickerDoneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton,fixedButton,doneButton, nil]];
    _txt_predict.inputAccessoryView = keyboardDoneButtonView;
    
}


//MARK: 构造预计送达时间范围的基础数据
-(void)generatePredictTime{
    int start_hour=7;
    int end_hour=23;
    int interval=30;//开始时间的间隔分钟数（2:00 2:30）
    
    while (start_hour<=end_hour) {
        NSString *hour_str=@"";
        PredictTimeEntity *entity=[[PredictTimeEntity alloc] init];
        if(start_hour<10){
            hour_str=[NSString stringWithFormat:@"0%d",start_hour];
        }
        else{
            hour_str=[NSString stringWithFormat:@"%d",start_hour];
        }
        entity.start_time=[NSString stringWithFormat:@"%@:00",hour_str];
        [predict_time_arr addObject:entity];
        
        PredictTimeEntity *entity_step=[[PredictTimeEntity alloc] init];
        if(start_hour<10){
            hour_str=[NSString stringWithFormat:@"0%d",start_hour];
        }
        else{
            hour_str=[NSString stringWithFormat:@"%d",start_hour];
        }
        entity_step.start_time=[NSString stringWithFormat:@"%@:%d",hour_str,interval];
        
        [predict_time_arr addObject:entity_step];
        
        start_hour++;
    }
}

//MARK: 显示预计送达时间的选择视图
-(void)showPredictTimeView{
    [_txt_predict becomeFirstResponder];
}

//MARK: 关闭预计送达时间的选择视图
-(void)closePredictTimeView{
    [_txt_predict resignFirstResponder];
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
    if(predict_time_arr==nil){
        return 0;
    }
    return predict_data_arr.count;
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
    sectionLbl.text=[predict_data_arr objectAtIndex:section].section_range;
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
    cell.begin_time=[predict_data_arr objectAtIndex:indexPath.section].start_time;
    cell.end_time=[predict_data_arr objectAtIndex:indexPath.section].end_time;
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
    //PredictSettingCell *cell=[tv cellForRowAtIndexPath:indexPath];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}


#pragma mark - picker view delegate
/* return column of pickerview*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/*return row number*/
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (predict_model==1){
        return predict_section_arr.count;
    }else if (predict_model==2){
        return request_num_arr.count;
    }else if (predict_model==3){
        return predict_time_arr.count;
    }
    return 0;
}

/*return component row str*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (predict_model==1){
        return [predict_section_arr objectAtIndex:row].receiving_time;
    }else if (predict_model==2){
        return [request_num_arr objectAtIndex:row];
    }else if (predict_model==3){
        return [predict_time_arr objectAtIndex:row].start_time;
    }
    return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor=16.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:DEFAULT_FONT(18)];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return WIDTH_SCREEN;
}

-(CGFloat) pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component{
    return 48;
}

/*choose com is component,row's function*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    predict_select_index=(int)row;//保存区域类型
    NSString *valueStr=[predict_time_arr objectAtIndex:row].start_time;
}


//MARK: 加载配送员今天的配送时间段
-(void)loadShippingTime{
    [self startLoadingActivityIndicator];
    [self.model loadDeliveryTimeSection];
}

//MARK: 获取配送员某时间段所有订单数和未设置排序的订单数
-(void)getPredictOrderData{
    [self startLoadingActivityIndicator];
    [self.model loadPredictOrderData:shipping_date_id];
}

//MARK: 提交配送员的订单预计送达时间的配置
-(void)postPredictSetting{
    if([self checkPredictSetData]){
        [self startLoadingActivityIndicator];
        
        NSString *jsonStr=@"";
        if(predict_data_arr!=nil&& predict_data_arr.count>0){
            for (PredictTimeEntity *obj in predict_data_arr) {
                jsonStr=[NSString stringWithFormat:@"%@{\"begin\":\"%@\",\"end\":\"%@\"}",jsonStr,obj.start_time,obj.end_time];
            }
        }
        
        jsonStr=[NSString stringWithFormat:@"[%@]",jsonStr];
        [self.model predictOrderSet:[NSString stringWithFormat:@"%d",shipping_date_id] andSize:[NSString stringWithFormat:@"%d",request_num] andList:jsonStr];
    }else{
        [self showToastWithText:@"请先设置好预计送达时间"];
    }
    
}

-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    [self stopLoadingActivityIndicator];
    
    if(model==self.model){
        if(model.requestTag==3007){
            if(isSuccess){
                if(self.model.time_entity.list!=nil){
                    if([self.model.time_entity.list count]>0){
                        predict_section_arr = self.model.time_entity.list;
                    }
                }
            }
        }
        else if(model.requestTag==3010){
            if(isSuccess){
                if([self.model.predict_order_entity.error_count intValue]>0){
                    [self showFailWithText:@"时间段内任务中有未设置配送顺序的订单"];
                }else if([self.model.predict_order_entity.total_count intValue]<=0){
                    [self showFailWithText:@"时间段内没有任务订单"];
                }else{
                    //组织分段数据
                    [self handlerPredict:[self.model.predict_order_entity.total_count intValue]];
                    [self.tableView reloadData];
                    if(predict_data_arr==nil||predict_data_arr.count<=0){
                        [self.tableView.footerView setHidden:YES];
                    }else {
                        [self.tableView.footerView setHidden:NO];
                    }
                }
            }
        }
        else if(model.requestTag==3011){
            if(isSuccess){
                [self showSuccesWithText:@"设置成功"];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:DELIVERY_STATE_UPDATE_NOTIFICATION object:nil];
            }
        }
    }
}


//MARK: 组织分段数据
-(void)handlerPredict:(int)num{
    if(num<0){
        [self showToastWithText:@"数据非法"];
        return;
    }
    
    int section_num=ceil((float)num/request_num);
    int current_num=1;
    int end_num=0;
    
    [predict_data_arr removeAllObjects];
    for (int i=0; i<section_num; i++) {
        if((current_num+request_num-1)>num){
            end_num=num;
        }else{
            end_num=current_num+request_num-1;
        }
        PredictTimeEntity *entity=[[PredictTimeEntity alloc] init];
        entity.section_range=[NSString stringWithFormat:@"%d-%d",current_num,end_num];
        entity.start_time=@"选择时间";
        entity.end_time=@"选择时间";
        entity.time_range=@"";
        [predict_data_arr addObject:entity];
        
        current_num+=request_num;
    }
}

//MARK: Pickview的完成点击事件
-(void)pickerDoneClicked:(id)sender{
    NSInteger row=[predictTimePicker selectedRowInComponent:0];
    predict_select_index=(int)row;
    NSString *valueStr=@"";
    
    if(predict_model==1){
        shipping_date_id=[[predict_section_arr objectAtIndex:row].shipping_date_id intValue];
        valueStr=[predict_section_arr objectAtIndex:row].receiving_time;
        NSArray *array = [valueStr componentsSeparatedByString:@" "];
        if(array.count==2){
            valueStr=[array lastObject];
        }
    }else if(predict_model==2){
        request_num=[[request_num_arr objectAtIndex:row] intValue];
        valueStr=[request_num_arr objectAtIndex:row];
    }else if(predict_model==3){
        valueStr=[predict_time_arr objectAtIndex:row].start_time;
    }
    [_txt_predict resignFirstResponder];
    [self setTaskItemPredictTime:valueStr];
    
}

//MARK: 设置配送任务的预计送达时间数据到坐标点对象上
-(void)setTaskItemPredictTime:(NSString *)str{
    if(predict_model==3){
        if(predict_data_arr.count>current_row_index){
            PredictTimeEntity *entity = [predict_data_arr objectAtIndex:current_row_index];
            if(current_time_mode==1){
                entity.start_time=str;
            }else if(current_time_mode==2){
                entity.end_time=str;
            }
            
            //判断时间的合法性
            if(entity.start_time.length>0 && entity.end_time.length>0){
                int start_t=[[[entity.start_time stringByReplacingOccurrencesOfString:@":" withString:@""] stringByReplacingOccurrencesOfString:@"选择时间" withString:@""] intValue];
                int end_t=[[[entity.end_time stringByReplacingOccurrencesOfString:@":" withString:@""] stringByReplacingOccurrencesOfString:@"选择时间" withString:@""] intValue];;
                
                if(start_t>=end_t && start_t!=0 && end_t!=0){
                    if(current_time_mode==1){
                        entity.start_time=@"选择时间";
                        [self showToastWithText:@"开始时间要小于结束时间"];
                    }else if(current_time_mode==2){
                        entity.end_time=@"选择时间";
                        [self showToastWithText:@"结束时间要大于开始时间"];
                    }
                }
            }
        }
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:current_row_index], nil] withRowAnimation:UITableViewRowAnimationNone];
        
    }else{
        if(_focus_predict!=nil && str.length>0){
            _focus_predict.text=str;
        }else{
            [self showToastWithText:@"目标对象无效"];
        }
    }
}

//MARK: 检查请求发送预计送达时间的批量设置数据
-(Boolean)checkPredictSetData{
    for (PredictTimeEntity *obj in predict_data_arr) {
        if([obj.start_time stringByReplacingOccurrencesOfString:@"选择时间" withString:@""].length<=0 || [obj.end_time stringByReplacingOccurrencesOfString:@"选择时间" withString:@""].length<=0){
            return NO;
            break;
        }
    }
    return YES;
}

//MARK: 检查请求配送员时间段的配送任务分段数据
-(Boolean)checkRequestData{
    if(shipping_date_id>0 && request_num>0){
        return YES;
    }else{
        return NO;
    }
}

-(TaskModel *)model{
    if(!_model){
        _model=[[TaskModel alloc] init];
        _model.delegate=self;
    }
    return _model;
}

#pragma mark - PredictTimeSectionViewDelegate
-(void)timeSectionClick:(UITextField *)sender{
    predict_model=1;
    _focus_predict=sender;
    [self showPredictTimeView];
    //[self getPredictOrderData];
    NSLog(@"timeSectionClick");
}

-(void)requestNumClick:(UITextField *)sender{
    predict_model=2;
    _focus_predict=sender;
    [self showPredictTimeView];
    NSLog(@"requestNumClick");
}

-(void)confirmClick{
    if([self checkRequestData]){
        [self getPredictOrderData];
    }else{
        [self showToastWithText:@"请先选择时间段和请求量"];
    }
    NSLog(@"confirmClick");
}

#pragma mark - TextfieldViewDelegate
-(void)startTimeClick:(int)row_index fromTextField:(UITextField *)sender{
    predict_model=3;
    current_row_index=row_index;
    current_time_mode=1;
    _focus_predict=nil;
    [self showPredictTimeView];
    NSLog(@"startTimeClick:%d",row_index);
}

-(void)endTimeClick:(int)row_index fromTextField:(UITextField *)sender{
    predict_model=3;
    current_row_index=row_index;
    current_time_mode=2;
    _focus_predict=nil;
    [self showPredictTimeView];
    NSLog(@"endTimeClick:%d",row_index);
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
