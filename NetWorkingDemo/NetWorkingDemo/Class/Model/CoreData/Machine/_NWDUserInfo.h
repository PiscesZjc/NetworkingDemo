// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NWDUserInfo.h instead.

#import <CoreData/CoreData.h>


extern const struct NWDUserInfoAttributes {
	__unsafe_unretained NSString *headImage;
	__unsafe_unretained NSString *nickName;
	__unsafe_unretained NSString *oid;
} NWDUserInfoAttributes;

extern const struct NWDUserInfoRelationships {
} NWDUserInfoRelationships;

extern const struct NWDUserInfoFetchedProperties {
} NWDUserInfoFetchedProperties;






@interface NWDUserInfoID : NSManagedObjectID {}
@end

@interface _NWDUserInfo : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NWDUserInfoID*)objectID;





@property (nonatomic, strong) NSString* headImage;



//- (BOOL)validateHeadImage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* nickName;



//- (BOOL)validateNickName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* oid;



//- (BOOL)validateOid:(id*)value_ error:(NSError**)error_;






@end

@interface _NWDUserInfo (CoreDataGeneratedAccessors)

@end

@interface _NWDUserInfo (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveHeadImage;
- (void)setPrimitiveHeadImage:(NSString*)value;




- (NSString*)primitiveNickName;
- (void)setPrimitiveNickName:(NSString*)value;




- (NSString*)primitiveOid;
- (void)setPrimitiveOid:(NSString*)value;




@end
