//
//  SCMobileIF3.h
//  SmartCondintioner
//
//  Created by 刘向宏 on 14-12-9.
//  Copyright (c) 2014年 刘向宏. All rights reserved.
//

#import "LPBaseHTTPRequestOperationManager.h"

@interface LPMobileRequest : LPBaseHTTPRequestOperationManager
+ (void)smsAccessWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (void)houseAddWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//获取分行网络列表
+ (void)branch_apiWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
