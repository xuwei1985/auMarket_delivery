//
//  SPUploadEntity.h
//  superenglish
//
//  Created by xiaojing on 16/6/1.
//  Copyright © 2016年 com.xuwei. All rights reserved.
//

#import "SPBaseEntity.h"

@interface SPUploadFileEntity : SPBaseEntity

@property (nonatomic, strong) NSString *url; //上传图片的url
@property (nonatomic, strong) NSString *key; //上传图片的key
@property (nonatomic, strong) NSString *filepath; //上传图片的key
@end
