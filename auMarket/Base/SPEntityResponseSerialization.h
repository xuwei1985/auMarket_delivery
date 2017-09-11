//
//  YPEntityResponseSerialization.h
//  Youpin
//
//  Created by DouJ on 15/3/8.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFURLResponseSerialization.h>
@interface SPEntityResponseSerialization : AFJSONResponseSerializer

//自动解析的数据类型 可能在不同线程访问  因此设置为 atomic
@property (assign,atomic) Class                      parseDataClassType;

@end
