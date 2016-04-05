//
//  AFBaseService.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFServiceResponse.h"
#import "AFServiceResult.h"
#import "AFServiceProtocol.h"

@class AFBaseService;

@protocol AFBaseServiceDelegate <NSObject>

@optional

/*
 * Service请求成功后返回整个Response对象，delegate选择实现
 */
- (void)service:(AFBaseService *)service didLoadResponse:(AFServiceResponse *)response;
/*
 * Service请求失败后返回Result对象，delegate选择实现
 */
- (void)service:(AFBaseService *)service failLoadResponse:(AFServiceResult *)result;
/*
 * Service请求因为需要登录而失败后返回Result对象，delegate选择实现
 */
- (void)service:(AFBaseService *)service needLogin:(AFServiceResult *)result;
/*
 * Service请求因为没有操作权限而失败后返回Result对象，delegate选择实现
 */
- (void)service:(AFBaseService *)service needAuth:(AFServiceResult *)result;
/*
 * 网络访问开始之前调用，delegate选择实现
 */
- (void)serviceWillLoadFromServer:(AFBaseService *)service;
/*
 * 网络访问结束之后调用，delegate选择实现
 */
- (void)serviceDidLoadFromServer:(AFBaseService *)service;



@end

@interface AFBaseService : NSObject<AFServiceProtocol>
@property (nonatomic,weak) id<AFBaseServiceDelegate>delegate;
@property (nonatomic,readonly) AFServiceConfig *config;
// only for sub-class to invoke
- (void)load:(AFServiceConfig *)config;
- (AFServiceConfig *)defaultServiceConfig;
- (id)initWithDelegate:(id<AFBaseServiceDelegate>)delegate;
- (void)cancelAllRequestsAndRemoveDelegate;
- (void)cancelRequestAndRemoveDelegate:(AFServiceConfig *)config;

// only for sub-class to implement its own logic
- (id)onParse:(id)response config:(AFServiceConfig *)config inContext:(NSManagedObjectContext *)context;

@end
