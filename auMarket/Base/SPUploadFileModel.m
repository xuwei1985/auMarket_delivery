//
//  YPUploadModel.m
//  pgy
//
//  Created by zhanghe on 15/10/31.
//  Copyright © 2015年 com.xuwei. All rights reserved.
//

#import "SPUploadFileModel.h"

@implementation SPUploadFileModel
/**
 上传图片
 */
-(void)uploadImages:(NSData *)data andResourceType:(NSString *)resourceType{
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    self.shortRequestAddress = [NSString stringWithFormat:@"apiv1.php?act=uploadImages&user_id=%@&resource_type=%@",user.user_id,resourceType];
    self.params = @{@"file_content": data};
    self.contentTypes = @{@"file_content": @"image/jpg"};
    self.parseDataClassType = [SPUploadFileEntity class];
    [self loadInner];
    
}

/**
分片上传图片
 */
- (void)upload:(NSString *)resourceId data:(NSData *)data sliceNums:(NSInteger)sliceNums sliceIndex:(NSInteger)sliceIndex isFinish:(BOOL)isFinish fileType:(NSInteger)fileType {
    self.sliceIndex = sliceIndex;
    self.isFinish = isFinish;
    self.fileType = fileType;
    if (fileType == 4) {
        fileType = 1;
    }
    
    //如果resourceId为空，自动生成一个
    if( ! [ self isBlankString:self.resourceId ] ){
        NSString * strResource_id = [data MD5String];
        resourceId = strResource_id;
    }
    
    DebugLog(@"Uploading: %@, %ld/%ld", resourceId, sliceIndex, sliceNums);
    self.shortRequestAddress = @"c/s/uploadfilebatch";
    self.params = @{@"resource_id": resourceId,
                    @"file_content": data,
                    @"slice_nums": [NSString stringWithFormat:@"%ld", sliceNums],
                    @"slice_index": [NSString stringWithFormat:@"%ld", sliceIndex],
                    @"is_finish": isFinish ? @"1": @"0",
                    @"file_type": [NSString stringWithFormat:@"%ld", fileType],
                    @"user_type": @"1"};
    self.contentTypes = @{@"file_content": @"image/jpg"};
    self.parseDataClassType = [SPUploadFileEntity class];
    [self loadInner];
}

//解析上传图片结果
- (void)handleParsedData:(SPBaseEntity *)parsedData {
    if ([parsedData isKindOfClass:[SPUploadFileEntity class]]) {
        self.uploadEntity = (SPUploadFileEntity *)parsedData;
    }
}


//判断字符串是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
