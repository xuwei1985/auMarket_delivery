//
//  SPBaseTableView.h
//  Youpin
//
//  Created by DouJ on 15/3/7.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPBaseTableView : UITableView

@property(nonatomic,assign) int recordeNum;
@property(nonatomic,assign) Boolean isFirstLoad;//是否正在请求数据
@property(nonatomic,assign) Boolean isEmptyLoad;//是否第一次就是空加载，即数据列表没有数据
@property(nonatomic,assign) Boolean isLoading;//是否正在请求数据
@property(nonatomic,assign) Boolean isPreLoading;//是否正在请求预加载数据
@property(nonatomic,assign) Boolean hasMore;//是否有更多数据
@property(nonatomic,retain) NSMutableArray<id> *itemArray;//已加载数据源
@property(nonatomic,retain) NSMutableArray<id> *preArray;//预加载数据源

@property(nonatomic,retain) UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) UILabel *loadMoreText;
@property(nonatomic,retain) UIView *footerView;

-(void)showTableFooterView;
-(void)resetData;
-(void)startLoadingActivityIndicatorView:(NSString *)text;
-(void)stopLoadingActivityIndicatorView:(NSString *)text;
@end
