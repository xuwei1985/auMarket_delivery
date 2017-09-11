//
//  GoodsCategoryView.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/13.
//  Copyright © 2016年 daao. All rights reserved.
//
#define PARENT_VIEW_WIDTH WIDTH_SCREEN*0.32
#define CHILD_VIEW_WIDTH WIDTH_SCREEN*0.68
#define ROW_HEIGHT 40
#import "GoodsCategoryView.h"

@implementation GoodsCategoryView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

-(void)initData{
    firstCategoryIndex=0;
}

-(void)initUI{
}

-(void)reloadParentView{
    [self.parentTableView reloadData];
    [self setNeedsDisplay];
}

-(void)reloadChildView{
    [self.childTableView reloadData];
    [self setNeedsDisplay];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.parentTableView){
        return 84;
    }
    else if(tableView==self.childTableView){
        return ROW_HEIGHT;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView==self.childTableView){
        return ROW_HEIGHT;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView==self.parentTableView){
        return 1;
    }
    else if(tableView==self.childTableView){
        NSString *secKey=((GoodsCategoryEntity *)[self.firstArray objectAtIndex:firstCategoryIndex]).cat_id;
        return [[self.secondCategoryDic objectForKey:secKey] count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==self.parentTableView){
        return self.firstArray.count;
    }
    else if(tableView==self.childTableView){
        NSString *secKey=((GoodsCategoryEntity *)[self.firstArray objectAtIndex:firstCategoryIndex]).cat_id;
        NSString *thrKey=((GoodsCategoryEntity *)[[self.secondCategoryDic objectForKey:secKey] objectAtIndex:section]).cat_id;
        return [[self.thirdCategoryDic objectForKey:thrKey] count];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(tableView==self.childTableView){
        NSString *secKey=((GoodsCategoryEntity *)[self.firstArray objectAtIndex:firstCategoryIndex]).cat_id;

        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CHILD_VIEW_WIDTH, ROW_HEIGHT)];
        
        UILabel * secondCategoryLbl = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, CHILD_VIEW_WIDTH-50, ROW_HEIGHT)];
        secondCategoryLbl.textColor = COLOR_FONT_GOODS_CATEGORY;
        secondCategoryLbl.font = FONT_SIZE_MIDDLE;
        secondCategoryLbl.text = ((GoodsCategoryEntity *)[[self.secondCategoryDic objectForKey:secKey] objectAtIndex:section]).cat_name;
        [customView addSubview:secondCategoryLbl];
        
        return customView;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.parentTableView){
        NSString *reuseIdetify = @"ParentCategoryViewCell";
        GoodsCategoryParentCell *cell = [[GoodsCategoryParentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        if (cell == nil) {
            cell.opaque=YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        GoodsCategoryEntity *ct=(GoodsCategoryEntity *)[self.firstArray objectAtIndex:indexPath.row];
        cell.categoryName=ct.cat_name;
        cell.categoryImgUrl=ct.thumb;
        cell.categorySelImgUrl=ct.thumb;
        
        if(indexPath.row==firstCategoryIndex){
            [cell setCellSel];
        }
        else{
            [cell setCellUnSel];
        }
        return cell;
    }
    else if(tableView==self.childTableView){
        NSString *reuseIdetify = @"ChildCategoryViewCell";
        GoodsCategoryChildCell *cell = [[GoodsCategoryChildCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        if (cell == nil) {
            cell.opaque=YES;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        NSString *secKey=((GoodsCategoryEntity *)[self.firstArray objectAtIndex:firstCategoryIndex]).cat_id;
        NSString *thrKey=((GoodsCategoryEntity *)[[self.secondCategoryDic objectForKey:secKey] objectAtIndex:indexPath.section]).cat_id;
       
        cell.categoryName=((GoodsCategoryEntity *)[[self.thirdCategoryDic objectForKey:thrKey] objectAtIndex:indexPath.row]).cat_name;
        return cell;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if(tableView==self.parentTableView){
        GoodsCategoryParentCell *newCell=(GoodsCategoryParentCell *)[tableView cellForRowAtIndexPath:indexPath];
        GoodsCategoryParentCell *oldCell=(GoodsCategoryParentCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:firstCategoryIndex inSection:indexPath.section]];
        [oldCell setCellUnSel];
        [newCell setCellSel];

        firstCategoryIndex=(int)indexPath.row;
        [self reloadChildView];
    }
    else{
        if([self.delegate respondsToSelector:@selector(didSelectedThirdCategory:)]){
            NSString *secKey=((GoodsCategoryEntity *)[self.firstArray objectAtIndex:firstCategoryIndex]).cat_id;
            NSString *thrKey=((GoodsCategoryEntity *)[[self.secondCategoryDic objectForKey:secKey] objectAtIndex:indexPath.section]).cat_id;

            GoodsCategoryEntity *_entity=((GoodsCategoryEntity *)[[self.thirdCategoryDic objectForKey:thrKey] objectAtIndex:indexPath.row]);
            [self.delegate didSelectedThirdCategory:_entity];
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
}

-(void)setParentCellSelState:(GoodsCategoryParentCell *)cell{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = ROW_HEIGHT;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y> 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else
        if(scrollView.contentOffset.y >= sectionHeaderHeight){
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            
        }
}

-(UITableView *)parentTableView{
    if(!_parentTableView){
        _parentTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _parentTableView.dataSource=self;
        _parentTableView.delegate=self;
        _parentTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _parentTableView.separatorColor=COLOR_WHITE;
        _parentTableView.scrollEnabled=YES;
        [self addSubview:_parentTableView];
        
        @weakify(self);
        [_parentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.right.mas_equalTo(self.mas_left).offset(PARENT_VIEW_WIDTH);
        }];
    }
    return _parentTableView;
}

-(UITableView *)childTableView{
    if(!_childTableView){
        _childTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _childTableView.dataSource=self;
        _childTableView.delegate=self;
        _childTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _childTableView.scrollEnabled=YES;
        [self addSubview:_childTableView];
        
        @weakify(self);
        [_childTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(self.parentTableView.mas_right);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.right.mas_equalTo(self.mas_right);
        }];
    }
    return _childTableView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
