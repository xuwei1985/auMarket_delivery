//
//  GoodsCategoryModel.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/12.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "GoodsCategoryModel.h"


@implementation GoodsCategoryModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.shortRequestAddress=@"apiv1.php?act=category_list";
        self.parseDataClassType = [GoodsCategoryListEntity class];
        self.entity.err_msg=@"未获取到有效的分类数据";
    }
    return self;
}

-(void)loadGoodsCategory{
    self.params = @{};
    [self loadInner];
}

-(void)handleParsedData:(SPBaseEntity*)parsedData{
    if ([parsedData isKindOfClass:[GoodsCategoryListEntity class]]) {
        self.entity = (GoodsCategoryListEntity*)parsedData;
        [self classifyCategoryData:self.entity];
    }
}

-(void)classifyCategoryData:(GoodsCategoryListEntity *)data{
    if(data!=nil&&data.categorylist!=nil){
        
        NSMutableArray *_parentArr=[[NSMutableArray alloc] init];
        NSMutableDictionary *_secondDic=[[NSMutableDictionary alloc] init];
        NSMutableDictionary *_thirdDic=[[NSMutableDictionary alloc] init];
        
        NSMutableArray *_secondArr=[[NSMutableArray alloc] init];
        NSMutableArray *_thirdArr=[[NSMutableArray alloc] init];
        
        NSMutableArray <GoodsCategoryEntity *>*categorylist=(NSMutableArray <GoodsCategoryEntity *>*)[[NSMutableArray alloc] initWithArray:data.categorylist];
        
        //处理父分类
        for (int i=(int)categorylist.count-1;i>=0;i--) {
            GoodsCategoryEntity *obj=[categorylist objectAtIndex:i];
            if([obj.parent_id intValue]==0){
                [_parentArr safeAddObject:obj];
                [categorylist removeObjectAtIndex:i];
            }
        }
        
        self.entity.firstCategoryArr=_parentArr;
        
        //处理子分类,二级分类
        for (GoodsCategoryEntity *parentObj in _parentArr) {
            for (int i=(int)categorylist.count-1;i>=0;i--) {
                GoodsCategoryEntity *obj=[categorylist objectAtIndex:i];
                if(obj.parent_id==parentObj.cat_id){
                    [_secondArr addObject:obj];
                    [categorylist removeObjectAtIndex:i];
                }
            }
            [_secondDic setObject:_secondArr forKey:parentObj.cat_id];
            _secondArr=[[NSMutableArray alloc] init];
        }
        self.entity.secondCategoryDic=_secondDic;
        
        //处理子分类,三级分类
        for (NSString *key in _secondDic) {
            NSMutableArray <GoodsCategoryEntity *>*secCategorylist=[_secondDic objectForKey:key];
            for (int i=(int)secCategorylist.count-1;i>=0;i--) {
                GoodsCategoryEntity *secObj=[secCategorylist objectAtIndex:i];
                
                for (int j=(int)categorylist.count-1;j>=0;j--) {
                    GoodsCategoryEntity *obj=[categorylist objectAtIndex:j];
                    
                    if(secObj.cat_id==obj.parent_id){
                        [_thirdArr addObject:obj];
                        [categorylist removeObjectAtIndex:j];
                    }
                }
                [_thirdDic setObject:_thirdArr forKey:secObj.cat_id];
                _thirdArr=[[NSMutableArray alloc] init];
            }
        }
        self.entity.thirdCategoryDic=_thirdDic;
    }
}

-(GoodsCategoryListEntity *)getCategoryCache{
    GoodsCategoryListEntity *_categoryList=(GoodsCategoryListEntity *)[self getItemFromCache:@"goodsCategory"];
    return _categoryList;
}

-(void)setCategoryCache:(GoodsCategoryListEntity *)data{
    [self setItemToCache:data key:@"goodsCategory"];
}

-(GoodsCategoryListEntity *)entity{
    if(!_entity){
        _entity=[[GoodsCategoryListEntity alloc] init];
    }
    
    return _entity;
}
@end
