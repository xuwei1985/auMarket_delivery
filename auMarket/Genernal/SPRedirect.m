//
//  SPRedirect.m
//  superenglish
//
//  Created by Mrc.cc on 16/3/31.
//  Copyright © 2016年 com.xuwei. All rights reserved.
//

#import "SPRedirect.h"
#import "AppDelegate.h"
#import "WebViewController.h"

@implementation SPRedirect
DEF_SINGLETON(SPRedirect)

#define LOCALPAGE_SCHEME            @"daao"

#define LOCALPAGE_SQUARE_PROFILE        @"/userPage"
#define LOCALPAGE_FEED_DETAIL           @"/feedDetail"
#define LOCALPAGE_SQUARE_STARBABY       @"/square/starbaby"
#define LOCALPAGE_REPORT_DETAIL         @"/reportDetail"
#define LOCALPAGE_PICTURE_BOOK          @"/pictureBook"
#define LOCALPAGE_HOT_ACTIVITY          @"/activity/hotactivity"
#define LOCALPAGE_ACTIVITY              @"/activity"
#define LOCALPAGE_COURSE_ACTIVITY       @"/course_activity"
#define LOCALPAGE_USER_SUMMARY          @"/os/userSummary"
#define LOCALPAGE_SQUARE_NOW            @"/square/now"
#define LOCALPAGE_COLUMN_LIST           @"/columnlist"
#define LOCALPAGE_COLUMN                @"/column"
#define LOCALPAGE_MSG_DETAIL            @"/msgDetail"
#define LOCALPAGE_SOURCE_CATEGORY       @"/radio"
#define LOCALPAGE_BIND_MOBILE           @"/bindMobile"
#define LOCALPAGE_EPISODE               @"/episode"
#define LOCALPAGE_STUDY_SUMMARY         @"/study_summary"
#define LOCALPAGE_ALL_MEDAL             @"/medal_all"
#define LOCALPAGE_PURCHASE_VIP          @"/vip"
#define LOCALPAGE_SLEEPING_STORY        @"/sleep_story"
#define LOCALPAGE_READING               @"/reading"
#define LOCALPAGE_READING_COURSELIST    @"/readingCourseList"
#define LOCALPAGE_READING_RECORD        @"/readingRecord"

#define LOCALPAGE_KEY_USER_ID           @"user_id"
#define LOCALPAGE_KEY_CID               @"cid"
#define LOCALPAGE_KEY_FID               @"fid"
#define LOCALPAGE_KEY_ACTIVITY          @"key"
#define LOCALPAGE_KEY_CATEGORY_ID       @"category_id"
#define LOCALPAGE_KEY_SUBCATEGORY_ID    @"s_category_id"
#define LOCALPAGE_KEY_EPISODE_ID        @"episode_id"
#define LOCALPAGE_KEY_TYPE              @"type"
#define LOCALPAGE_KEY_RESOURCE_ID       @"resource_id"
#define LOCALPAGE_KEY_STORY_ID          @"story_id"
#define LOCALPAGE_KEY_COURSE_ID         @"course_id"
#define LOCALPAGE_KEY_CHAPTER_ID        @"chapter_id"
#define LOCALPAGE_KEY_CS_ID             @"cs_id"
#define LOCALPAGE_KEY_RECORD_ID         @"record_id"

#define WEB_SQUARE_STARBABY_PATH    @"/c/cm/square/starbaby"
#define WEB_REPORT_DETAIL_PATH      @"/c/os/reportDetail"
#define WEB_PICTURE_BOOK_PATH       @"/c/os/pictureBook"
#define WEB_HOT_ACTIVITY_PATH       @"/c/cm/activity/hotactivity"
#define WEB_USER_SUMMARY_PATH       @"/c/os/userSummary"

//"pgy://pgy.cn/columnlist"
- (void)jumpByUrl:(NSString *)url andModal:(int)modal{
        if(url == nil || [url isEmpty])
        {
            return;
        }
        
        NSURL* urlObj = [NSURL URLWithString:url];
        if (!urlObj) {
            return;
        }
        
        UIViewController* vcToPush = nil;
        if ([urlObj.scheme isEqualToString:LOCALPAGE_SCHEME]) {
            NSDictionary* dict = [self getParamFrom:urlObj.query];
        //明星宝贝：
        //pgy://pgy.cn/square/starbaby?sub_star_id=2
        //实际URL : m.primedu.cn/c/cm/square/starbaby?sub_star_id=2
        if ([urlObj.path isEqualToString:LOCALPAGE_SQUARE_STARBABY])
        {
            
//            YPWebViewController* vc = [[YPWebViewController alloc] init];
//            vc.url =[NSString stringWithFormat:@"%@%@?%@",SERVER_ADDRESS,WEB_SQUARE_STARBABY_PATH,urlObj.query];
//            vcToPush = vc;
            
        }
        //课程报告详情页：
        //pgy.cn/reportDetail?report_id=55
        //实际URL :m.primedu.cn/c/os/reportDetail?report_id=55
        else if([urlObj.path isEqualToString:LOCALPAGE_REPORT_DETAIL])
        {
//            YPWebViewController* vc = [[YPWebViewController alloc] init];
//            vc.url =[NSString stringWithFormat:@"%@%@?%@",SERVER_ADDRESS,WEB_REPORT_DETAIL_PATH,urlObj.query];
//            vcToPush = vc;
        }
        //学习记录落地页：
        //pgy:pgy.cn\/pictureBook?record_id=349
        //实际URL : m.primedu.cn/c/os/pictureBook?record_id=349
        else if([urlObj.path isEqualToString:LOCALPAGE_PICTURE_BOOK])
        {
//            YPWebViewController* vc = [[YPWebViewController alloc] init];
//            vc.url =[NSString stringWithFormat:@"%@%@?%@",SERVER_ADDRESS,WEB_PICTURE_BOOK_PATH,urlObj.query];
//            vcToPush = vc;
        }
        //热门活动：
        //pgy://pgy.cn/activity/hotactivity
        //实际URL : m.primedu.cn/c/cm/activity/hotactivity
        else if([urlObj.path isEqualToString:LOCALPAGE_HOT_ACTIVITY])
        {
//            YPWebViewController* vc = [[YPWebViewController alloc] init];
//            vc.url =[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,WEB_HOT_ACTIVITY_PATH];
//            vcToPush = vc;
        }
        //个人学习汇总页面
        //pgy://pgy.cn/os/userSummary
        //实际URL : m.primedu.cn/c/os/userSummary
        else if([urlObj.path isEqualToString:LOCALPAGE_USER_SUMMARY])
        {
//            YPWebViewController* vc = [[YPWebViewController alloc] init];
//            vc.url =[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,WEB_USER_SUMMARY_PATH];
//            vcToPush = vc;
        }
        //此时此刻页面
        //pgy://pgy.cn/square/now
        else if([urlObj.path isEqualToString:LOCALPAGE_SQUARE_NOW])
        {
//            SPSquareNowViewController *vc = [SPSquareNowViewController new];
//            vcToPush = vc;
        }
        //话题页面
        //pgy://pgy.cn/activity?key=%E6%AF%94%E4%B8%80%E6%AF%94
        else if([urlObj.path isEqualToString:LOCALPAGE_ACTIVITY])
        {
//            NSString* key = [[dict objectForKey:LOCALPAGE_KEY_ACTIVITY] URLDecoding];
//            SPTopicViewController* vc = [[SPTopicViewController alloc] init];
//            vc.title = key;
//            vcToPush = vc;
        }
        //别人的资料页面
        //pgy://pgy.cn/userPage?user_id=1
        else if([urlObj.path isEqualToString:LOCALPAGE_SQUARE_PROFILE])
        {
//            NSString* uid = [dict objectForKey:LOCALPAGE_KEY_USER_ID];
//            SPOtherProfileViewController *vc = [SPOtherProfileViewController new];
//            vc.uid = uid;
//            vcToPush = vc;
        }
        //动态详情页面
        //pgy://pgy.cn/feedDetail?fid=18
        else if([urlObj.path isEqualToString:LOCALPAGE_FEED_DETAIL])
        {
//            NSString* fid = [dict objectForKey:LOCALPAGE_KEY_FID];
//            SPSquareFeedDetailViewController *vc = [SPSquareFeedDetailViewController new];
//            vc.fid = fid;
//            if (fid) {
//                [MobClick event:@"feed_detail" attributes:@{@"fid":fid}];
//            }
//            vcToPush = vc;
        //专栏列表
        }
        
    }
    //webview跳转
    else
    {
        //webview跳转
        WebViewController* vc = [[WebViewController alloc] init];
        vc.url =url;
        vcToPush = vc;
    }
    
    if (vcToPush) {
        UINavigationController* navVc = [AppDelegate getNavigationController];
        if(modal<=0){
            [navVc pushViewController:vcToPush animated:YES];
        }
        else{
            [navVc presentViewController:vcToPush animated:YES completion:nil];
        }
    }
}


- (void)jumpByUserId:(NSString *)userId{
//    SPOtherProfileViewController *vc = [SPOtherProfileViewController new];
//    vc.uid = userId;
//    [[AppDelegate getNavigationController] pushViewController:vc animated:YES];
}
- (void)jumpByFid:(NSString *)fid{
//    if (fid) {
//        [MobClick event:@"feed_detail" attributes:@{@"fid":fid}];
//        SPSquareFeedDetailViewController *vc = [SPSquareFeedDetailViewController new];
//        vc.fid = fid;
//        [[AppDelegate getNavigationController] pushViewController:vc animated:YES];
//    }
}
-(NSDictionary*)getParamFrom:(NSString*)str
{
    NSMutableDictionary* mutableDict = [[NSMutableDictionary alloc] init];
    NSArray* separatedArr = [str componentsSeparatedByString:@"&"];
    for (NSString* paramStr in separatedArr) {
        NSArray* paramArr = [paramStr componentsSeparatedByString:@"="];
        if (paramArr.count == 2) {
            NSString* key = [paramArr objectAtIndex:0];
            NSString* value = [paramArr objectAtIndex:1];
            [mutableDict setObject:value forKey:key];
        }
    }
    return [mutableDict copy];
}

- (BOOL)shouldJumpToLocalPage:(NSString *)url{
    NSURL* urlObj = [NSURL URLWithString:url];
    if (urlObj) {
        if ([urlObj.scheme isEqualToString:LOCALPAGE_SCHEME]) {
            return YES;
        }
    }
    return NO;
}
@end
