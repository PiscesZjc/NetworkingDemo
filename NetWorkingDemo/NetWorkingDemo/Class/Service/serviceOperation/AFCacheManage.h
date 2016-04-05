//
//  AFCacheManage.h
//  NetWorkingDemo
//
//  Created by zjc on 16/3/3.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFCacheProtocol.h"

@interface AFCacheManage : NSObject

+ (instancetype)sharedInstance;

- (void)setupCacheImplementation:(id<AFCacheProtocol>)cacheImplementation;

/*
 *根据key和过期时间来获取有效地缓存
 *目前会删除无效缓存
 */
- (id)objectsForCacheKey:(NSString*)key expireDate:(NSDate*)date inContext:(NSManagedObjectContext*)context;

/*
 *清除旧的缓存
 *真正的操作是减少缓存计数，但是不删除缓存本身
 */
- (void)removeObjectsForCacheKey:(NSString *)key inContext:(NSManagedObjectContext *)context;

/*
 *
 *根据key缓存，并设置缓存有效时间
 */
- (void)cacheObjects:(id)objects forKey:(NSString*)key expireDate:(NSDate*)date inContext:(NSManagedObjectContext*)context;

//CoreData

/*
 *Core Data对象和ID之间的转换
 *
 */
+ (id)coreDataObjectIDArrayFromObjects:(id)coreDataObjects;
+ (id)coreDataObjectsFromObjectIDs:(id)coreDataObjectIDs;
+ (NSManagedObject *)coreDataObjectByObjectID:(NSManagedObjectID *)objectID;


/*
 *返回所有拥有参数oid的缓存对象
 */
- (NSArray*)fetchObjectsByOid:(NSString *)oid inClass:(Class)classObject inContext:(NSManagedObjectContext *)context;

/*
 * 生成一个新的Core Data对象
 */
+ (id)createNewObjectInClass:(Class)classObject
                   inContext:(NSManagedObjectContext *)context;

/*
 *清除所有缓存
 *
 */
- (void)clearAllCache;

/*
 *清除已过期缓存
 */
- (void)clearInvalidCache;

@end
