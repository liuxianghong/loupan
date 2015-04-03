//
//  SCMobileIF3.m
//  SmartCondintioner
//
//  Created by 刘向宏 on 14-12-9.
//  Copyright (c) 2014年 刘向宏. All rights reserved.
//

#import "LPMobileRequest.h"
#import <JSONKit.h>

#define baseURL @"http://property.mobile-apps.com.hk/realestate/"
#define kErrorDomain @"https://api.drkon.net/if3/v1/"

#define kMethodhouseAdd @"house_add_api.php"
#define kMethodbranchApi @"branch_api.php"
#define kMethodhouseApi @"house_api.php"
#define kMethodareaApi @"area_api.php"
#define kMethodspaceApi @"space_api.php"
#define kMethodregionApi @"region_api.php"
#define kMethodhouse_trade_api @"house_trade_api.php"
#define kMethodcollection_api @"collection_api.php"
#define kMethodroll_image_api @"roll_image_api.php"

@interface LPMobileRequest()<NSURLConnectionDataDelegate>
@property (nonatomic,strong) NSData *reciveData;
@property (nonatomic,strong) NSError *reciveError;
@property (nonatomic) NSInteger reciveStatus;
@end

@implementation LPMobileRequest

+ (void)houseAddWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self Request:kMethodhouseAdd WithPost:NO WithParameters:parameters success:success failure:failure];
}

+ (void)branch_apiWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self Request:kMethodbranchApi WithPost:NO WithParameters:parameters success:success failure:failure];
}

+ (void)house_apiWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self Request:kMethodhouseApi WithPost:NO WithParameters:parameters success:success failure:failure];
}

//地区列表获取
+ (void)area_apiWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self Request:kMethodareaApi WithPost:NO WithParameters:parameters success:success failure:failure];
}

//获取间隔列表
+ (void)space_apiWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self Request:kMethodspaceApi WithPost:NO WithParameters:parameters success:success failure:failure];
}

//获取屋苑列表
+ (void)region_apiWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self Request:kMethodregionApi WithPost:NO WithParameters:parameters success:success failure:failure];
}

//成交记录列表
+ (void)house_trade_apiWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self Request:kMethodhouse_trade_api WithPost:NO WithParameters:parameters success:success failure:failure];
}

//查询收藏列表
+ (void)collection_apiWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self Request:kMethodcollection_api WithPost:NO WithParameters:parameters success:success failure:failure];
}

+ (void)roll_image_apiWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self Request:kMethodroll_image_api WithPost:NO WithParameters:parameters success:success failure:failure];
}

+ (void)Request:(NSString *)method WithPost:(BOOL)bo WithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *urls = [NSString stringWithFormat:@"%@%@",baseURL,method];
    [[LPBaseHTTPRequestOperationManager sharedManager] mobileHTTPWithMethod:urls WithParameters:parameters post:bo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *retStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (retStr) {
            retStr = [NSString stringWithString:retStr];
            NSRange range = [retStr rangeOfString:@"{"];
            if(range.location>0)
                retStr = [retStr substringFromIndex:range.location];
            id object = [retStr objectFromJSONString];
            if(!object)
            {
                NSError *error = [NSError errorWithDomain:@"服务器返回数据有误" code:0 userInfo:nil];
                failure(operation,error);
            }
            else
            {
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSNumber *state = nil;
                    NSString *errorStr = nil;
                    NSDictionary* dic = [retStr objectFromJSONString];
                    state = [dic objectForKey:@"state"];
                    if ([state integerValue]!=0) {
                        NSDictionary *msg = [dic[@"data"] firstObject];
                        errorStr = msg[@"msg"];
                        NSError *error = [NSError errorWithDomain:errorStr code:0 userInfo:nil];
                        failure(operation,error);
                    }
                    else
                        success(operation,object);
                }
                else
                {
                    NSError *error = [NSError errorWithDomain:@"服务器返回数据有误" code:0 userInfo:nil];
                    failure(operation,error);
                }
            }
        }
        else
        {
            NSError *error = [NSError errorWithDomain:@"无法连接服务器" code:0 userInfo:nil];
            failure(operation,error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *error2 = [NSError errorWithDomain:@"无法连接服务器" code:0 userInfo:nil];
        failure(operation,error2);
    }];
}

@end
