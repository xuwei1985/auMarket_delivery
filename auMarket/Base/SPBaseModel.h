//
//  TBCBaseModel.h
//  TBClient
//
//  Created by douj on 13-3-26.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPBaseEntity.h"
#import "SPServerErrorCodeDef.h"

// 用于serverapi回调的block定义

@class SPBaseModel;
@protocol SPBaseModelProtocol <NSObject>

@required
-(void)onResponse:(SPBaseModel*)model isSuccess:(BOOL)isSuccess;

@optional
-(void)onStartRequest:(SPBaseModel*)model;
-(void)onUserNotLogin;
-(void)onDataChanged;//数据发生改变

@end

@interface SPBaseModel : NSObject

//网络请求参数
@property (nonatomic,strong) NSDictionary*              params;
//请求地址 需要在子类init中初始化
@property (nonatomic,copy)   NSString*                  shortRequestAddress;
//自动解析的数据类型 可能在不同线程访问  因此设置为 atomic
@property (assign,atomic) Class                         parseDataClassType;
//上传文件的contenttype
@property (nonatomic,strong) NSDictionary*              contentTypes;
//delegate
@property (nonatomic, weak) id<SPBaseModelProtocol>     delegate;
@property (nonatomic) BOOL showErrorMsg;
@property (nonatomic) NSInteger errorCode;
//请求tag
@property (nonatomic) int requestTag;
-(id)initWithDelegate:(id<SPBaseModelProtocol>)delegate;

//从缓存读数据
-(id<NSCoding>)getItemFromCache:(NSString*)key;
//将数据设置到缓存
-(void)setItemToCache:(id<NSCoding>)item key:(NSString*)key;
//和用户绑定的缓存
- (void)setUserItemToCache:(id<NSCoding>)item key:(NSString *)key;
- (id<NSCoding>)getUserItemFromCache:(NSString *)key;
-(void)handleParsedData:(SPBaseEntity*)parsedData;
-(void)handleUnParsedData:(id)data;

-(BOOL)isLoading;

- (void)loadInner;
- (void)cancel;
- (void)downFileFromServerWithUrl:(NSString *)url andCategory:(NSString *)category;

-(NSString*)getHost;
+(NSString*)getAppVer;
+(NSString*)getDeviceID;

@end
