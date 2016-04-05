//
//  NSManagedObject+Model.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/17.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Model)


/*
 * 保存对象到CoreData
 * 1. 如果是主线程上的保存，以异步操作进行
 * 2. 如果是子线程上的保存，以同步操作进行
 */
- (void)save;

/*
 * 新建model
 * 子类实现该函数，解析JSON，封装成CoreData
 */
+ (id)createModelFromJSONData:(NSDictionary *)json inContext:(NSManagedObjectContext *)context;

/*
 * 更新model
 * 子类实现该函数，解析JSON，封装成CoreData
 */
- (void)updateModelFromJSONData:(NSDictionary *)json;

/*
 * 更新model的property(attribute和relationship)的方法
 * create系直接赋值，update系只更新有值的property
 * 仅供调用，不能覆写
 */
- (void)createAttribute:(NSString *)name data:(id)data;
- (void)createRelationship:(NSString *)name class:(Class)class data:(id)data;
- (void)createRelationship:(NSString *)name class:(Class)class data:(id)data inverse:(BOOL)inverse;
- (void)updateAttribute:(NSString *)name data:(id)data;
- (void)updateAttribute:(NSString *)name data:(id)data force:(BOOL)force;
- (void)updateRelationship:(NSString *)name class:(Class)class data:(id)data;
- (void)updateRelationship:(NSString *)name class:(Class)class data:(id)data inverse:(BOOL)inverse;
- (void)updateRelationship:(NSString *)name class:(Class)class data:(id)data inverse:(BOOL)inverse force:(BOOL)force;@end
