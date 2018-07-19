//
//  SPBaseTableView.m
//  Youpin
//
//  Created by DouJ on 15/3/7.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "SPBaseTableView.h"

@implementation SPBaseTableView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initData];
        self.backgroundColor = COLOR_BG_TABLESEPARATE;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.backgroundColor = COLOR_BG_TABLESEPARATE;
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initData];
        self.backgroundColor = COLOR_BG_TABLESEPARATE;
    }
    return self;
}

-(void)initData{
    self.recordeNum=0;
    self.isFirstLoad=YES;
    self.isLoading=NO;
    self.isPreLoading=NO;
    self.isEmptyLoad=NO;
    self.hasMore=YES;
    
    self.itemArray=[[NSMutableArray alloc] init];
    self.preArray=[[NSMutableArray alloc] init];
}

-(void)resetData{
    [self initData];
    [self stopLoadingActivityIndicatorView:@" "];
    [self reloadData];
}

-(void)showTableFooterView{
    self.tableFooterView = self.footerView;
}

-(void)startLoadingActivityIndicatorView:(NSString *)text{
    if(text!=nil&&text.length>0){
        [self.loadMoreText setText:text];
    }
    else{
        [self.loadMoreText setText:@"正在加载数据..."];
    }
    self.activityIndicator.hidden=NO;
    [self.activityIndicator startAnimating];
}

-(void)stopLoadingActivityIndicatorView:(NSString *)text{
    if(text!=nil&&text.length>0){
        [self.loadMoreText setText:text];
    }
    else{
        if(self.hasMore){
            [self.loadMoreText setText:@"上拉加载更多数据"];
        }
        else{
            if(self.isEmptyLoad){
                [self.loadMoreText setText:@""];
            }
            else{
                [self.loadMoreText setText:@"数据已经全部加载"];
            }
            
        }
    }
    
    [self.activityIndicator stopAnimating];
}

-(UIActivityIndicatorView *)activityIndicator{
    if(!_activityIndicator){
        _activityIndicator=[[UIActivityIndicatorView alloc] init];
        [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped=YES;
        _activityIndicator.opaque=YES;
        [self.footerView addSubview:_activityIndicator];
        
        [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12, 12));
            make.centerY.mas_equalTo(self.footerView);
            make.right.mas_equalTo(self.loadMoreText.mas_left);
        }];
    }
    return _activityIndicator;
}

-(UILabel *)loadMoreText{
    if(!_loadMoreText){
        _loadMoreText = [[UILabel alloc] init];
        [_loadMoreText setFont:DEFAULT_FONT(14)];
        _loadMoreText.textColor=COLOR_GRAY;
        [_loadMoreText setText:@"上拉加载更多数据"];
        _loadMoreText.backgroundColor=[UIColor clearColor];
        _loadMoreText.textAlignment=NSTextAlignmentCenter;
        
        [self.footerView addSubview:_loadMoreText];
        
        [_loadMoreText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(140, 24));
            make.centerY.mas_equalTo(self.tableFooterView);
            make.centerX.mas_equalTo(self.tableFooterView).offset(8);
        }];
    }
    return _loadMoreText;
}

-(UIView *)footerView{
    if(!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ([UIScreen mainScreen].bounds.size.width), 34.0f)];
        _footerView.backgroundColor=COLOR_CLEAR;
    }
    
    return _footerView;
}

@end
