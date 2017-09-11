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
    [self initUI];
}

-(void)initUI{
    [self setNavigation];
    [self setUpTableView];
    [self createTaskCategoryButtons];
    [self.tableView reloadData];
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
    [btn_waitDelivery setTitle:@"待配送(11)" forState:UIControlStateNormal];
    [btn_waitDelivery setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [btn_waitDelivery setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    btn_waitDelivery.titleLabel.font=FONT_SIZE_MIDDLE;
    btn_waitDelivery.titleLabel.textAlignment=NSTextAlignmentCenter;
    [taskCategoeryBar addSubview:btn_waitDelivery];
    
    btn_failedDelivery=[[UIButton alloc] initWithFrame:CGRectMake(TASK_CATEGORY_EDGE+TASK_CATEGORY_GAP*1+TASK_CATEGORY_WIDTH*1, 0, TASK_CATEGORY_WIDTH, SEGMENTVIEW_HEIGHT)];
    [btn_failedDelivery setTitle:@"配送失败(6)" forState:UIControlStateNormal];
    [btn_failedDelivery setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [btn_failedDelivery setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    btn_failedDelivery.titleLabel.font=FONT_SIZE_MIDDLE;
    btn_failedDelivery.titleLabel.textAlignment=NSTextAlignmentCenter;
    [taskCategoeryBar addSubview:btn_failedDelivery];
    
    btn_successDelivery=[[UIButton alloc] initWithFrame:CGRectMake(TASK_CATEGORY_EDGE+TASK_CATEGORY_GAP*2+TASK_CATEGORY_WIDTH*2, 0, TASK_CATEGORY_WIDTH, SEGMENTVIEW_HEIGHT)];
    [btn_successDelivery setTitle:@"配送完成(15)" forState:UIControlStateNormal];
    [btn_successDelivery setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [btn_successDelivery setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
    btn_successDelivery.titleLabel.font=FONT_SIZE_MIDDLE;
    btn_successDelivery.titleLabel.textAlignment=NSTextAlignmentCenter;
    [taskCategoeryBar addSubview:btn_successDelivery];
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
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdetify = @"taskListItemCell";
    TaskItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (cell == nil) {
        cell=[[TaskItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.opaque=YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.entity=nil;
    
    return cell;
}

-(void)toggleWorkState:(UIButton *)sender{
    sender.selected=!sender.selected;
    [APP_DELEGATE.booter handlerWorkingState:sender.selected];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    btn_workState.selected=APP_DELEGATE.isWorking;
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
