//
//  UserCenterViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//
#define DONE_ACTION_BAR (IS_IPhoneX?68.0f:48.0f)
#import "BankListViewController.h"

@interface BankListViewController ()

@end

@implementation BankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}


-(void)initUI{
    [self setNavigation];
    [self setUpTableView];
}

-(void)initData{
    NSDictionary *bank_0,*bank_1,*bank_2,*bank_3;
    _itemArr=[[NSMutableArray alloc] init];
    
    bank_0=[[NSDictionary alloc] initWithObjectsAndKeys:@"01_03",@"bank_icon",@"CommonWealth Bank",@"bank_name",@"1",@"bank_id",@"063109",@"bsb",@"13311157",@"account", nil];
    bank_1=[[NSDictionary alloc] initWithObjectsAndKeys:@"01_10",@"bank_icon",@"ANZ Bank",@"bank_name",@"2",@"bank_id",@"013225",@"bsb",@"425160982",@"account", nil];
    bank_2=[[NSDictionary alloc] initWithObjectsAndKeys:@"01_12",@"bank_icon",@"Westpac Bank",@"bank_name",@"3",@"bank_id",@"033172",@"bsb",@"867082",@"account", nil];
    bank_3=[[NSDictionary alloc] initWithObjectsAndKeys:@"01_15",@"bank_icon",@"NAB Bank",@"bank_name",@"4",@"bank_id",@"083153",@"bsb",@"911104863",@"account", nil];
    [_itemArr addObject:bank_0];
    [_itemArr addObject:bank_1];
    [_itemArr addObject:bank_2];
    [_itemArr addObject:bank_3];
}

-(void)setNavigation{
    self.title=@"选择银行";
}

-(void)setUpTableView{
    float table_height=HEIGHT_SCREEN-HEIGHT_STATUS_AND_NAVIGATION_BAR;
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN,table_height) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    [self.tableView setTableHeaderView:[self createTopView]];
    
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
}

-(UIView *)createTopView{
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 80)];
    topView.backgroundColor=COLOR_BG_VIEW;
    
    UILabel *lbl_1=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, WIDTH_SCREEN, 36)];
    lbl_1.textAlignment=NSTextAlignmentCenter;
    lbl_1.textColor=COLOR_BLACK;
    lbl_1.font=[UIFont boldSystemFontOfSize:18.0f];
    lbl_1.text=@"选择选择支付银行";
    [topView addSubview:lbl_1];
    
    UILabel *lbl_2=[[UILabel alloc] initWithFrame:CGRectMake(0, 46, WIDTH_SCREEN, 20)];
    lbl_2.textAlignment=NSTextAlignmentCenter;
    lbl_2.textColor=COLOR_GRAY;
    lbl_2.font=[UIFont systemFontOfSize:12.0f];
    lbl_2.text=@"(如果没有客户对于的银行就不能转)";
    [topView addSubview:lbl_2];
    return topView;
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [_itemArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

//设置每行每列的值
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"bankCellIdentifier";
    BankCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BankCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.showsReorderControl = NO;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.backgroundColor=COLOR_BG_TABLEVIEWCELL;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font=DEFAULT_FONT(16.0);
        cell.textLabel.textColor=COLOR_DARKGRAY;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.itemName =[[_itemArr objectAtIndex:indexPath.row]  objectForKey:@"bank_name"];
    
    cell.iconImage=[UIImage imageNamed:[[_itemArr objectAtIndex:indexPath.row] objectForKey:@"bank_icon"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:NO];
    PaymentViewController *pvc=[[PaymentViewController alloc] init];
    pvc.bank_info=[_itemArr objectAtIndex:indexPath.row];pvc.task_entity=self.task_entity;
    pvc.task_entity=self.task_entity;
    pvc.order_sn=self.order_sn;
    pvc.payment_type=self.payment_type;
    [self.navigationController pushViewController:pvc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
