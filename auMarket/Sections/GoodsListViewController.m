//
//  GoodsListViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/15.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "GoodsListViewController.h"

@interface GoodsListViewController ()

@end

@implementation GoodsListViewController

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
    self.title=self.categoryName;
    [self resetData];
    [self loadGoodsList];
}

-(void)resetData{
    _tid=@"0";
    _sortType=@"1";
}

-(void)setNavigation{
    UIBarButtonItem *right_Item_cart = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"cart_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(gotoMyCartView)];
    
    
    self.navigationItem.rightBarButtonItem=right_Item_cart;
}

-(void)setUpTableView{
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN-64) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
}

-(void)loadGoodsList{
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
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 116;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdetify = @"GoodsListItemCell";
//    GoodsListItemCell *cell = [[GoodsListItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
//    if (cell == nil) {
//        cell.opaque=YES;
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    
//    GoodsListItemEntity *obj=(GoodsListItemEntity *)[_goodsList objectAtIndex:indexPath.row];
//    cell.entity=obj;

    return nil;
}

-(void)gotoMyCartView{
    [[AppDelegate getTabbarController] setSelectedIndex:2];
}

//-(GoodsListModel *)model{
//    if(!_model){
//        _model=[[GoodsListModel alloc] init];
//        _model.delegate=self;
//    }
//    
//    return _model;
//}

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
