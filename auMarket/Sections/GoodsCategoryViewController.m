//
//  GoodsCategoryViewController.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "GoodsCategoryViewController.h"

@interface GoodsCategoryViewController ()

@end

@implementation GoodsCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

-(void)initUI{
    [self createGoodsCategoryView];
}

-(void)createGoodsCategoryView{
    categoryView=[[GoodsCategoryView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN-64-48)];
    categoryView.delegate=self;
    [self.view addSubview:categoryView];
}

-(void)initData{
    self.title=@"商品分类";
    
    self.goodsCategory=[self.model getCategoryCache];
    [self loadCategoryData];
}

-(void)loadCategoryData{
    categoryView.firstArray=self.goodsCategory.firstCategoryArr;
    categoryView.secondCategoryDic=self.goodsCategory.secondCategoryDic;
    categoryView.thirdCategoryDic=self.goodsCategory.thirdCategoryDic;
    [categoryView reloadParentView];
    [categoryView reloadChildView];
}

-(void)didSelectedThirdCategory:(GoodsCategoryEntity *)entity{
    NSLog(@"entity:%@",entity);
    [self gotoGoodsList:entity];
}

-(void)didSelectedSecondCategory:(GoodsCategoryEntity *)entity{
    
}

-(void)gotoGoodsList:(GoodsCategoryEntity *)entity{
    GoodsListViewController *gvc=[[GoodsListViewController alloc] init];
    gvc.categoryName=entity.cat_name;
    gvc.categoryId=entity.cat_id;
    [self.navigationController pushViewController:gvc animated:YES];
}

-(GoodsCategoryModel *)model{
    if(!_model){
        _model=[[GoodsCategoryModel alloc] init];
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
