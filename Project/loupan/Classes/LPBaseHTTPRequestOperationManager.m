//
//  BaseHTTPRequestOperationManager.m
//  DoctorFei_iOS
//
//  Created by GuJunjia on 14/11/30.
//
//
#import <Foundation/Foundation.h>
#import "LPBaseHTTPRequestOperationManager.h"
#import "JSONKit.h"

#define kErrorEmpty @"Empty"

@implementation LPBaseHTTPRequestOperationManager
+ (LPBaseHTTPRequestOperationManager *)sharedManager
{
    static LPBaseHTTPRequestOperationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self manager]initWithBaseURL:nil];
        _sharedManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_sharedManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    });
    return _sharedManager;
}
- (void)defaultPostWithMethod:(NSString *)method WithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@",method];
    [[LPBaseHTTPRequestOperationManager sharedManager]POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            success(operation, responseObject);
        }
        else{
            NSError *error = [NSError errorWithDomain:kErrorEmpty code:0 userInfo:nil];
            failure(operation, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void)mobileHTTPWithMethod:(NSString *)method WithParameters:(id)parameters  post:(BOOL)bo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@",method];
    if (bo) {
        [self defaultPostWithMethod:method WithParameters:parameters success:success failure:failure];
    }
    else
    {
        [[LPBaseHTTPRequestOperationManager sharedManager]GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject) {
                success(operation, responseObject);
            }
            else{
                NSError *error = [NSError errorWithDomain:kErrorEmpty code:0 userInfo:nil];
                failure(operation, error);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
        }];
    }
    
}

@end
