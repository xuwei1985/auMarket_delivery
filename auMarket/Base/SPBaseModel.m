//
//  TBCBaseModel.m
//  TBClient
//
//  Created by douj on 13-3-26.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import "SPBaseModel.h"
#import <objc/runtime.h>
#import <AFHTTPSessionManager.h>
#import "SPEntityResponseSerialization.h"
#import "AccountManager.h"
#import "CommonCache.h"
#import "SPServerErrorCodeDef.h"
#import "IPManager.h"
#import "SeqIDGenerator.h"
#import <UICKeyChainStore.h>



@interface SPBaseModel ()
//@property AFHTTPRequestOperation* afhttpResquestOperation;
@property NSURLSessionTask* requestTask;

@property (nonatomic) int requestTagInner;
@end

@implementation SPBaseModel

+(NSString*)getSystemVer
{
    static NSString* systemVer;
    static dispatch_once_t once;
    dispatch_once( &once, ^{ systemVer = [UIDevice currentDevice].systemVersion; } );
    return systemVer;
}

+(NSString*)getAppVer
{
    static NSString* appVer;
    static dispatch_once_t once;
    dispatch_once( &once, ^{ appVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];} );
    return appVer;
}

+(NSString*)getDeviceID
{
    //因为在iPhone设置中打开“限制广告追踪”获取不到正确的IDFA，故采用钥匙串和IDFV的方式来设置deviceId
    static NSString *idfv;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:KEYCHAIN_IDENTIFIER];
        idfv = [keychain stringForKey:@"deviceId"];
        if (!idfv) {
            DebugLog(@"IDFV not found on keychain!");
            idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [keychain setString:idfv forKey:@"deviceId"];
        }
    });
    return idfv;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showErrorMsg = YES;
    }
    return self;
}

- (id)initWithDelegate:(id<SPBaseModelProtocol>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
        self.showErrorMsg = YES;
    }
    return self;
}


- (void)dealloc
{
    //先停止网络请求
    [self cancel];
    self.requestTask =nil;
    self.params = nil;
    self.shortRequestAddress = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)isLoading
{
    if(self.requestTask)
    {
        
        if (self.requestTask.state != NSURLSessionTaskStateCanceling && self.requestTask.state != NSURLSessionTaskStateCompleted) {
            return YES;
        }
    }
    return NO;
}

-(void)setRequestTag:(int)requestTag
{
    if ([self isLoading]) {
        return;
    }
    self.requestTagInner = requestTag;
}


-(NSString*)getHost
{
    if(APP_DELEGATE.hotLine!=nil){
        return APP_DELEGATE.hotLine;
    }
    return [[IPManager sharedInstance] getAvaliableIp];
}


//***实现者调用 加载网络请求
- (void)loadInner
{
    if ([self isLoading]) {
        return;
    }
    if (!self.shortRequestAddress) {
        IDPLogWarning(0, @"address is nil");
        return;
    }
    if (!self.params)
    {
        IDPLogWarning(0, @"params is nil");
    }
    
    [self addCommonParams];
    
    NSString* requestAddress =  [NSString stringWithFormat:@"%@/%@", [self getHost], self.shortRequestAddress];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    NSString *sign=[Common getRequestSignature:requestAddress];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000*1000;
    NSString *authorization=[NSString stringWithFormat:@"Signature oauth_signature=\"%@\",oauth_consumer_key=\"%@\",oauth_timestamp=\"%llu\",oauth_version=1.0.0",sign,[[[NSString stringWithFormat:@"%@",[Common getUserKey]] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0],recordTime];
    
    [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:[Common getClientId] forHTTPHeaderField:@"clientid"];
    [manager.requestSerializer setValue:APP_DELEGATE.token forHTTPHeaderField:@"token"];
    
    SPEntityResponseSerialization* serializer = [SPEntityResponseSerialization serializer];
    serializer.parseDataClassType = self.parseDataClassType;
    manager.responseSerializer = serializer;
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];
    manager.requestSerializer.timeoutInterval = 20;
    
    _requestTag = self.requestTagInner;
    
    NSDictionary *params = self.params;
    if (self.contentTypes && self.contentTypes.count > 0) {//二进制提交
        self.requestTask =[manager POST:requestAddress parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (NSString *key in [self.params allKeys]) {
                id value = [self.params objectForKey:key];
                if ([value isKindOfClass:[NSData class]]) {
                    [formData appendPartWithFileData:value name:key fileName:@"file" mimeType:[self.contentTypes objectForKey:key]];
                } else {
                    [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@", value] dataUsingEncoding:NSUTF8StringEncoding] name:key];
                }
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self onSuccess:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self onFailure:task error:error];
        }];
        
//        self.requestTask =[manager POST:requestAddress parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            for (NSString *key in [self.params allKeys]) {
//                id value = [self.params objectForKey:key];
//                if ([value isKindOfClass:[NSData class]]) {
//                    [formData appendPartWithFileData:value name:key fileName:@"file" mimeType:[self.contentTypes objectForKey:key]];
//                } else {
//                    [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@", value] dataUsingEncoding:NSUTF8StringEncoding] name:key];
//                }
//            }
//        } progress:^(NSProgress * _Nonnull uploadProgress) {
//            
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            [self onSuccess:task responseObject:responseObject];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [self onFailure:task error:error];
//        }];
//        
    } else {
        self.requestTask =[manager POST:requestAddress parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self onSuccess:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self onFailure:task error:error];
        }];
//        self.requestTask = [manager POST:requestAddress parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            [self onSuccess:task responseObject:responseObject];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [self onFailure:task error:error];
//        }];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onStartRequest:)])
    {
        [self.delegate onStartRequest:self];
    }
}

- (void)onSuccess:(NSURLSessionDataTask *)operation responseObject:(id)responseObject {
    BOOL isSuccess = YES;
    if (self.parseDataClassType) {
        SPBaseEntity *entity = responseObject;
        self.errorCode =[entity isKindOfClass:[SPBaseEntity  class]]?[entity.code integerValue]:0;
        if (self.errorCode!=0) {
            isSuccess = NO;
            
            if (SPServerErrorCodeDefUserNotLogin == self.errorCode||SPServerErrorCodeDefTokenExpired== self.errorCode) {
                if ([[AccountManager sharedInstance] isLogin]) {
                    [[AccountManager sharedInstance] unRegisterLoginUser];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(onUserNotLogin)]) {
                    [self.delegate onUserNotLogin];
                }
            }
            else if (self.showErrorMsg) {
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                [SVProgressHUD showErrorWithStatus:entity.err_msg];
            }
            
        }
        [self onParseData:responseObject];
    }
    else {
        // 不解析
        [self handleUnParsedData:responseObject];
    }
    if (self.delegate) {
        [self.delegate onResponse:self isSuccess:isSuccess];
    }
}

- (void)onFailure:(NSURLSessionDataTask *)operation error:(NSError *)error {
    BOOL isIgnore=NO;//是否对取消请求，忽略错误提示
    if (self.showErrorMsg) {
        if (error.userInfo && [error.userInfo objectForKey:NSLocalizedDescriptionKey]) {
            if([[error.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:@"cancelled"]){
                isIgnore=YES;
            }
            else{
                [SVProgressHUD showErrorWithStatus:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
    }
    [self onNetError];
    if (self.delegate&&!isIgnore) {
        [self.delegate onResponse:self isSuccess:NO];
    }
}

-(void)addCommonParams
{
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if (self.params) {
        [dict addEntriesFromDictionary:self.params];
    }
    [dict setObject:[NSNumber numberWithInt:(int)[UIScreen mainScreen].scale] forKey:@"scale"];
    [dict setObject:[SPBaseModel getAppVer] forKey:@"app_ver"];
    [dict setObject:[SPBaseModel getSystemVer] forKey:@"sys_ver"];
    [dict setObject:@"ios" forKey:@"client_type"];
    [dict setObject:@"ps" forKey:@"client_source"];//标注来自配送员App
    [dict setObject:[[SeqIDGenerator sharedInstance] seqId] forKey:@"seqid"];
    
    NSString* uToken = [[AccountManager sharedInstance] getCurrentUser].user_token;
    if (uToken && ![uToken isEmpty]) {
        [dict setObject:uToken forKey:@"token"];
    }
    
    [dict setObject:[SPBaseModel getDeviceID] forKey:@"devid"];
    
    self.params = dict;
}

- (void)setItemToCache:(id<NSCoding>)item key:(NSString *)key {
    if (item == nil) {
        [[[CommonCache sharedInstance] getCache:NSStringFromClass(self.class)] removeObjectForKey:key block:nil];
    }
    else
    {
        [[[CommonCache sharedInstance] getCache:NSStringFromClass(self.class)] setObject:item forKey:key block:nil];
    }
}

- (void)setUserItemToCache:(id<NSCoding>)item key:(NSString *)key
{
    SPAccount* currentUser = [[AccountManager sharedInstance] getCurrentUser];
    if (currentUser) {
        [self setItemToCache:item key:[NSString stringWithFormat:@"%@_%@",currentUser.user_id,key]];
    }
}

- (id<NSCoding>)getItemFromCache:(NSString *)key {
    return [[[CommonCache sharedInstance] getCache:NSStringFromClass(self.class)] objectForKey:key];
}


- (id<NSCoding>)getUserItemFromCache:(NSString *)key {
    SPAccount* currentUser = [[AccountManager sharedInstance] getCurrentUser];
    if (currentUser) {
        
        return [[[CommonCache sharedInstance] getUserCache:NSStringFromClass(self.class)] objectForKey:[NSString stringWithFormat:@"%@_%@",currentUser.user_id,key]];
    }
    return nil;
}

//***实现者重载处理数据的逻辑
-(void)handleParsedData:(SPBaseEntity*)parsedData
{
    
}

//***重载者实现处理未做parse的data
-(void)handleUnParsedData:(id)data
{
    
}

//***重载者实现网络请求失败时候的处理逻辑
-(void)onNetError
{
    
}


//内部方法
-(void)onParseData:(id)parsedData
{
    // 可以解析
    if (![self.parseDataClassType isSubclassOfClass:[SPBaseEntity class]])
    {
        if([parsedData isKindOfClass:[NSDictionary class]]){
            [self handleParsedData:parsedData];
        }
        else{
            IDPLogWarning(0, @"parseDataType is not TBCBaseItem class");
            return;
        }
    }
    if(![parsedData isKindOfClass:self.parseDataClassType])
    {
        return;
    }
    [self handleParsedData:parsedData];
    
}
// 停止加载
- (void)cancel
{
    [self.requestTask cancel];
}


- (void)downFileFromServerWithUrl:(NSString *)url andCategory:(NSString *)category{
    NSURLSessionDownloadTask *_downloadTask;
    //远程地址
    NSURL *URL = [NSURL URLWithString:url];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        
        // 给Progress添加监听 KVO
        //NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            // 设置进度条的百分比
        //
        //            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        //        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",category,response.suggestedFilename]];
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",cachesPath,category]])
        {
            [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",cachesPath,category] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        NSLog(@"下载完成:%@",imgFilePath);
        
    }];
    
    [_downloadTask resume];
}

@end
