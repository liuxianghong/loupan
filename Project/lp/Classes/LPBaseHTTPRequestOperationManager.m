//
//  BaseHTTPRequestOperationManager.m
//  DoctorFei_iOS
//
//  Created by GuJunjia on 14/11/30.
//
//
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>
#import "LPBaseHTTPRequestOperationManager.h"
#import "JSONKit.h"

#define kErrorEmpty @"Empty"

@implementation NSString (Crypt)
- (NSString *) stringFromMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString uppercaseString];
}

- (NSString *) stringToImageUrl
{
    NSString *iconStr = [NSString stringWithFormat:@"http://property.mobile-apps.com.hk/realestate/up_file/file_image/%@",self];
    return iconStr;
}
@end

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
