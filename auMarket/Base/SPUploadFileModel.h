//
//  YPUploadModel.h
//  pgy
//
//  Created by zhanghe on 15/10/31.
//  Copyright © 2015年 com.xuwei. All rights reserved.
//

#import "SPBaseModel.h"
#import "SPUploadFileEntity.h"

@interface SPUploadFileModel : SPBaseModel

@property (nonatomic, strong) SPUploadFileEntity *uploadEntity;

@property (nonatomic, assign) NSString * resourceId;
@property (nonatomic, assign) NSData * data;
@property (nonatomic, assign) NSInteger sliceNums;
@property (nonatomic, assign) NSInteger sliceIndex;
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, assign) NSInteger fileType;

- (void)upload:(NSString *)resourceId data:(NSData *)data sliceNums:(NSInteger)sliceNums sliceIndex:(NSInteger)sliceIndex isFinish:(BOOL)isFinish fileType:(NSInteger)fileType;
-(void)uploadImages:(NSData *)data andResourceType:(NSString *)resourceType;
@end
