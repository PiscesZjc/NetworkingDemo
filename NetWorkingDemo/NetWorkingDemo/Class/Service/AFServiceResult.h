//
//  AFServiceResult.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/2.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFServiceResult : NSObject

/*
 * code表示当次请求在服务器端的处理结果，code为0表示请求成功，其它均为请求出错。
 */
@property (nonatomic) NSInteger code;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,strong) NSDictionary *info;

+ (AFServiceResult *)resultWithCode:(NSInteger)code message:(NSString*)message info:(NSDictionary*)info;

@end
