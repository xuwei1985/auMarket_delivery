//
//  UserCenterViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "LineViewController.h"

@interface LineViewController ()

@end

@implementation LineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
    [self.tableView reloadData];
}

-(void)initData{
    if(APP_DELEGATE.booter.lineEntity.list==nil){
        LineItemEntity *line_1=[[LineItemEntity alloc] init];
        line_1.title=@"主力线路";
        line_1.url=@"http://api.bigau.com";
        
        LineItemEntity *line_2=[[LineItemEntity alloc] init];
        line_2.title=@"备用线路";
        line_2.url=@"http://api.bigausyd.com";
        
        NSArray<LineItemEntity*> *list=[[NSArray<LineItemEntity*> alloc] initWithObjects:line_1,line_2, nil];
        LineEntity *entity=[LineEntity new];
        entity.list=list;
        APP_DELEGATE.booter.lineEntity=entity;
    }
}

-(void)initUI{
    [self setNavigation];
    [self setUpTableView];
}


-(void)setNavigation{
    self.title=@"线路选择";
}


-(void)setUpTableView{
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN-HEIGHT_STATUS_AND_NAVIGATION_BAR) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    
    UIView*view = [UIView new];
    view.backgroundColor= [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
}


//注销
-(void)changeLine:(long)row{
    [[AlertBlockView sharedInstance] showChoiceAlert:@"您确定要切换线路吗？" button1Title:@"确认" button2Title:@"取消" completion:^(int index) {
        if(index==0){
            APP_DELEGATE.hotLine=[APP_DELEGATE.booter.lineEntity.list objectAtIndex:row].url;
            [self.tableView reloadData];
            [[AlertBlockView sharedInstance] showTipAlert:@"切换成功"];
        }
    }];
    
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [APP_DELEGATE.booter.lineEntity.list count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

//设置每行每列的值
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"LineCellIdentifier";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.showsReorderControl = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor=COLOR_BG_TABLEVIEWCELL;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font=DEFAULT_FONT(16.0);
        cell.textLabel.textColor=COLOR_DARKGRAY;
    }
    if([APP_DELEGATE.hotLine isEqualToString:[APP_DELEGATE.booter.lineEntity.list objectAtIndex:indexPath.row].url]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text =[APP_DELEGATE.booter.lineEntity.list objectAtIndex:indexPath.row].title;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:NO];
    
    [self changeLine:indexPath.row];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
