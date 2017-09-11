//
//  GoodsCategoryView.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/13.
//  Copyright © 2016年 daao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCategoryParentCell.h"
#import "GoodsCategoryChildCell.h"
#import "GoodsCategoryEntity.h"

@protocol GoodsCategoryViewDelegate
@optional
- (void)didSelectedThirdCategory:(GoodsCategoryEntity *)entity;
- (void)didSelectedSecondCategory:(GoodsCategoryEntity *)entity;
@end
@interface GoodsCategoryView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    int firstCategoryIndex;
}
@property(nonatomic,retain)NSMutableArray <GoodsCategoryEntity *>*firstArray;
@property(nonatomic,assign)NSObject<GoodsCategoryViewDelegate> *delegate;
@property(nonatomic,retain)NSMutableDictionary *secondCategoryDic;
@property(nonatomic,retain)NSMutableDictionary *thirdCategoryDic;
@property(nonatomic,retain)UITableView *parentTableView;
@property(nonatomic,retain)UITableView *childTableView;

-(void)reloadParentView;
-(void)reloadChildView;

@end

