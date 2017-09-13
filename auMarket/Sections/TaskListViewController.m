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
    list_status_modal=Delivery_Status_Delivering;
}

-(void)initUI{
    [self setNavigation];
    [self setUpTableView];
    [self createTaskCategoryButtons];
    [self.tableView reloadData];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTaskUpdate:) name:TASK_UPDATE_NOTIFICATION object:nil];
}

-(void)setNavigation{
    btn_workState = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_workState.frame= CGRectMake(0, 0, 95, 29);
    [btn_workState setBackgroundImage:[UIImage imageNamed:@"1_04"] forState:UIControlStateNormal];
    [btn_workState setBackgroundImage:[UIImage imageNamed:@"1_03"] forState:UIControlStateSelected];
    [btn_workState setTitle:@"休息中" forState:UIControlStateNormal];
    [btn_workState setTitle:@"正在接单" forState:UIControlStateSelected];
    btn_workState.titleLabel.font=FONT_SIZE_MIDDLE;
    [btn_workState setTitleColor:COLOR_GRAY forState:UIControlStateNormal];
    [btn_workState setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    [btn_workState addTarget:self action:@selector(toggleWorkState:) forControlEvents:UIControlEventTouchUpInside];
    btn_workState.selected=APP_DELEGATE.isWorking;
    self.navigationItem.titleView=btn_workState;
}


-(void)createTaskCategoryButtons{
    UIView *taskCategoeryBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, SEGMENTVIEW_HEIGHT)];
    taskCategoeryBar.backgroundColor=RGBCOLOR(240, 240, 240);
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
    btn_failedDelivery.tag=1001;
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
    btn_successDelivery.tag=1002;
    [taskCategoeryBar addSubview:btn_successDelivery];
    [btn_successDelivery addTarget:self action:@selector(taskCategoryTap:) forControlEvents:UIControlEventTouchUpInside];
    
    if(list_status_modal==Delivery_Status_Finished){
        btn_successDelivery.selected=YES;
    }
    
    [self refreshCategoryBtn];
}

-(void)setUpTableView{
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, SEGMENTVIEW_HEIGHT, WIDTH_SCREEN, HEIGHT_SCREEN-64-SEGMENTVIEW_HEIGHT) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
}


-(void)taskCategoryTap:(UIButton *)sender{
    btn_waitDelivery.selected=NO;
    btn_failedDelivery.selected=NO;
    btn_successDelivery.selected=NO;
    sender.selected=YES;
    
    list_status_modal=(int)sender.tag-1000;
    [self.tableView reloadData];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(list_status_modal==Delivery_Status_Delivering){
        return [APP_DELEGATE.booter.tasklist_delivering count];
    }
    else if(list_status_modal==Delivery_Status_Finished){
        return [APP_DELEGATE.booter.tasklist_finished count];
    }
    else if(list_status_modal==Delivery_Status_Failed){
        return [APP_DELEGATE.booter.tasklist_failed count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdetify = @"taskListItemCell";
    TaskItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (cell == nil) {
        cell=[[TaskItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.opaque=YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.entity=[APP_DELEGATE.booter.tasklist_delivering objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self gotoOrderDetailView:nil];
}

-(void)refreshCategoryBtn{
    [btn_waitDelivery setTitle:[NSString stringWithFormat:@"待配送(%d)",(int)[APP_DELEGATE.booter.tasklist_delivering count]] forState:UIControlStateNormal];
    [btn_successDelivery setTitle:[NSString stringWithFormat:@"配送完成(%d)",(int)[APP_DELEGATE.booter.tasklist_finished count]] forState:UIControlStateNormal];
    [btn_failedDelivery setTitle:[NSString stringWithFormat:@"配送失败(%d)",(int)[APP_DELEGATE.booter.tasklist_failed count]] forState:UIControlStateNormal];
}

//配送数据更新
- (void)onTaskUpdate:(NSNotification*)aNotitification{
    [self refreshCategoryBtn];
    [self.tableView reloadData];
}

-(void)toggleWorkState:(UIButton *)sender{
    sender.selected=!sender.selected;
    [APP_DELEGATE.booter handlerWorkingState:sender.selected];
}

-(void)gotoOrderDetailView:(TaskEntity *)entity{
    OrderDetailViewController *ovc=[[OrderDetailViewController alloc] init];
    [self.navigationController pushViewController:ovc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    btn_workState.selected=APP_DELEGATE.isWorking;
    
    [self checkLoginStatus];
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
