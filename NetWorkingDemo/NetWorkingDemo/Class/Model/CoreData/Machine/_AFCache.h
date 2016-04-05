// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AFCache.h instead.

#import <CoreData/CoreData.h>


extern const struct AFCacheAttributes {
	__unsafe_unretained NSString *expireTime;
	__unsafe_unretained NSString *isSingleObject;
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *objectClassName;
	__unsafe_unretained NSString *objects;
} AFCacheAttributes;

extern const struct AFCacheRelationships {
} AFCacheRelationships;

extern const struct AFCacheFetchedProperties {
} AFCacheFetchedProperties;






@class NSObject;

@interface AFCacheID : NSManagedObjectID {}
@end

@interface _AFCache : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AFCacheID*)objectID;





@property (nonatomic, strong) NSDate* expireTime;



//- (BOOL)validateExpireTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isSingleObject;



@property BOOL isSingleObjectValue;
- (BOOL)isSingleObjectValue;
- (void)setIsSingleObjectValue:(BOOL)value_;

//- (BOOL)validateIsSingleObject:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* key;



//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* objectClassName;



//- (BOOL)validateObjectClassName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id objects;



//- (BOOL)validateObjects:(id*)value_ error:(NSError**)error_;






@end

@interface _AFCache (CoreDataGeneratedAccessors)

@end

@interface _AFCache (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveExpireTime;
- (void)setPrimitiveExpireTime:(NSDate*)value;




- (NSNumber*)primitiveIsSingleObject;
- (void)setPrimitiveIsSingleObject:(NSNumber*)value;

- (BOOL)primitiveIsSingleObjectValue;
- (void)setPrimitiveIsSingleObjectValue:(BOOL)value_;




- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;




- (NSString*)primitiveObjectClassName;
- (void)setPrimitiveObjectClassName:(NSString*)value;




- (id)primitiveObjects;
- (void)setPrimitiveObjects:(id)value;




@end
