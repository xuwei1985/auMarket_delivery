//
//  UserCenterViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "UserCenterViewController.h"

@interface UserCenterViewController ()

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
    [self initUI];
    [self initData];
    [self onAccountUpdate:nil];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccountUpdate:) name:ACCOUNT_UPDATE_NOTIFICATION object:nil];
}

-(void)initUI{
    [self setNavigation];
    [self createMemberInfoView];
    [self setUpTableView];
}

-(void)initData{
    NSDictionary *dic1,*dic2,*dic3,*dic4,*dic5,*dic6,*dic7;
    _itemArr=[[NSMutableArray alloc] init];
    
    dic1=[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_order",@"item_icon",@"我的订单",@"item_name",@"我的订单",@"item_controller", nil];
    [_itemArr addObject:[NSArray arrayWithObjects:dic1, nil]];

    dic2=[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_favorite",@"item_icon",@"我的收藏",@"item_name",@"我的收藏",@"item_controller", nil];
    dic3=[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_setting",@"item_icon",@"地址管理",@"item_name",@"地址管理",@"item_controller", nil];
    dic4=[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_user",@"item_icon",@"账户设置",@"item_name",@"账户设置",@"item_controller", nil];
    dic5=[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_cache",@"item_icon",@"清除缓存",@"item_name",@"清除缓存",@"item_controller", nil];
    dic6=[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_mail",@"item_icon",@"联系大澳网",@"item_name",@"联系大澳网",@"item_controller", nil];
    dic7=[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_comment",@"item_icon",@"常见问题",@"item_name",@"常见问题",@"item_controller", nil];
    [_itemArr addObject:[NSArray arrayWithObjects:dic2,dic3,dic4,dic5,dic6,dic7, nil]];
}


-(void)setNavigation{
    UIBarButtonItem *right_Item_cart = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"cart_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(gotoMyCartView)];
    
    
    self.navigationItem.rightBarButtonItem=right_Item_cart;
}

-(UIImage *)createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)createMemberInfoView{
    _userInfoView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, WIDTH_SCREEN*0.6)];
    _userInfoView.image=[UIImage imageNamed:@"memberBg.jpg"];
    _userInfoView.userInteractionEnabled=YES;
    
    _headView=[[UIImageView alloc] init];
    _headView.image=[UIImage imageNamed:@"default_head.jpg"];
    _headView.clipsToBounds=YES;
    _headView.backgroundColor=COLOR_WHITE;
    [_headView.layer setCornerRadius:38];
    [_userInfoView addSubview:_headView];
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_userInfoView);
        make.size.mas_equalTo(CGSizeMake(76, 76));
    }];
    
    
    _nicknameLbl=[[UILabel alloc] init];
    _nicknameLbl.textColor=COLOR_WHITE;
    _nicknameLbl.font=FONT_SIZE_BIG;
    _nicknameLbl.text=@"";
    _nicknameLbl.hidden=YES;
    _nicknameLbl.userInteractionEnabled=YES;
    _nicknameLbl.textAlignment=NSTextAlignmentCenter;
    [_userInfoView addSubview:_nicknameLbl];
    
    [_nicknameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.centerX.mas_equalTo(_userInfoView.mas_centerX);
    }];
    
    [_nicknameLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMemberLogin)]];
    
    _loginLbl=[[UILabel alloc] init];
    _loginLbl.textColor=COLOR_WHITE;
    _loginLbl.font=FONT_SIZE_BIG;
    _loginLbl.text=@"立即登录>>";
    _loginLbl.hidden=NO;
    _loginLbl.userInteractionEnabled=YES;
    _loginLbl.textAlignment=NSTextAlignmentCenter;
    [_userInfoView addSubview:_loginLbl];
    
    [_loginLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.centerX.mas_equalTo(_userInfoView.mas_centerX);
    }];
    
    [_loginLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMemberLogin)]];
}

-(void)setUpTableView{
    self.tableView=[[SPBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN-64) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=COLOR_BG_TABLESEPARATE;
    self.tableView.backgroundColor=COLOR_BG_TABLEVIEW;
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_CLEAR;
    
    [self.tableView setTableHeaderView:_userInfoView];
    [self.tableView setTableFooterView:view];
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _itemArr.count;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return [[_itemArr objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==_itemArr.count-1){
        return 20;
    }
    return 0;
}

//设置每行每列的值
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"MemberCellIdentifier";
    MemberCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MemberCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.showsReorderControl = NO;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor=COLOR_BG_TABLEVIEWCELL;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font=DEFAULT_FONT(16.0);
        cell.textLabel.textColor=COLOR_DARKGRAY;
    }
    
    cell.itemName =[[[_itemArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_name"];
    cell.iconImage=[UIImage imageNamed:[[[_itemArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item_icon"]];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tv deselectRowAtIndexPath:[tv indexPathForSelectedRow] animated:NO];
}

- (void)onAccountUpdate:(NSNotification*)aNotitification{
    BOOL login = [aNotitification.object boolValue];
    if(aNotitification==nil){
        login=[[AccountManager sharedInstance] isLogin];
    }
    if (login) {
        _loginLbl.hidden=YES;
        _nicknameLbl.hidden=NO;
        
        SPAccount *_account = [AccountManager sharedInstance].getCurrentUser;
        _nicknameLbl.text=_account.user_nickname;
        [_headView sd_setImageWithURL:[NSURL URLWithString:_account.user_avatar] placeholderImage:[UIImage imageNamed:@"default_head.jpg"]];
    }
    else{
        _loginLbl.hidden=NO;
        _nicknameLbl.hidden=YES;
    }
}

-(void)gotoMyCartView{
    [[AppDelegate getTabbarController] setSelectedIndex:2];
}

-(void)gotoMemberLogin{
    [[AccountManager sharedInstance] showLoginWithModalState];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar  setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    [self.navigationController.navigationBar  setTranslucent:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
