//
//  BaseHTTPRequestOperationManager.h
//  DoctorFei_iOS
//
//  Created by GuJunjia on 14/11/30.
//
//

#import "AFHTTPRequestOperationManager.h"

@interface NSString (Crypt)
- (NSString *) stringFromMD5;
- (NSString *) stringToImageUrl;
@end

@interface LPBaseHTTPRequestOperationManager : AFHTTPRequestOperationManager
+ (LPBaseHTTPRequestOperationManager *)sharedManager;
- (void)defaultPostWithMethod:(NSString *)method WithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)mobileHTTPWithMethod:(NSString *)method WithParameters:(id)parameters post:(BOOL)bo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
