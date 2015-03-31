//
//  SCMobileIF3.m
//  SmartCondintioner
//
//  Created by 刘向宏 on 14-12-9.
//  Copyright (c) 2014年 刘向宏. All rights reserved.
//

#import "LPMobileRequest.h"
#import <JSONKit.h>

#define baseURL @"http://property.mobile-apps.com.hk/"
#define kErrorDomain @"https://api.drkon.net/if3/v1/"

#define kMethodsms_access @"area_api.php"
#define kMethodhouseAdd @"house_add_api.php"
#define kMethodbranchApi @"branch_api.php"

@interface LPMobileRequest()<NSURLConnectionDataDelegate>
@property (nonatomic,strong) NSData *reciveData;
@property (nonatomic,strong) NSError *reciveError;
@property (nonatomic) NSInteger reciveStatus;
@end

@implementation LPMobileRequest

+ (void)smsAccessWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self Request:kMethodsms_access WithPost:NO WithParameters:parameters success:success failure:failure];
}

+ (void)houseAddWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self Request:kMethodhouseAdd WithPost:YES WithParameters:parameters success:success failure:failure];
}

+ (void)branch_apiWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self Request:kMethodbranchApi WithPost:NO WithParameters:parameters success:success failure:failure];
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
                        errorStr = dic[@"data"];
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
