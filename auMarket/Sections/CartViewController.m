//
//  CartViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "CartViewController.h"

@interface CartViewController ()

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

-(void)initUI{
    [self createSummaryView];
    [self setUpTableView];
}

-(void)initData{
    self.title=@"购物车";
    [self loadMyCart];
}

-(void)loadMyCart{
    [self startLoadingActivityIndicator];
    [self.model loadGoodsCart];
}

-(void)createSummaryView{
    _summaryView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 74)];
    
    _appNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 50, 20)];
    _appNameLbl.text=@"大澳网";
    _appNameLbl.font=FONT_SIZE_BIG;
    _appNameLbl.textColor=COLOR_DARKGRAY;
    
    [_summaryView addSubview:_appNameLbl];
}

-(void)setUpTableView{
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN-64) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    
    [self.tableView setTableHeaderView:_summaryView];
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
}

-(void)onResponse:(SPBaseModel *)model isSuccess:(BOOL)isSuccess{
    [self stopLoadingActivityIndicator];
    if(isSuccess){
        if(self.model.entity!=nil&&self.model.entity.cartlist.count>0){
            self.tableView.hidden=NO;
            [self.tableView reloadData];
        }
        else{
            self.tableView.hidden=YES;
            [self showNoContentViewWithTitle:@"空空也如此，赶快去选择喜爱的商品吧！" icon:nil button:nil];
            NSLog(@"未获取到有效商品数据");
        }
    }
}


#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [self.model.entity.cartlist count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

//设置每行每列的值
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"GoodsCartItemCell";
    GoodsCartItemCell *cell = [[GoodsCartItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
    if (cell == nil) {
        cell.opaque=YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    GoodsCartItemEntity *obj=(GoodsCartItemEntity*)[self.model.entity.cartlist objectAtIndex:indexPath.row];
    cell.entity=obj;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:NO];
}

-(GoodsCartModel *)model{
    if(!_model){
        _model=[[GoodsCartModel alloc] init];
        _model.delegate=self;
    }
    return _model;
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
