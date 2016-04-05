// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NWDUserInfo.m instead.

#import "_NWDUserInfo.h"

const struct NWDUserInfoAttributes NWDUserInfoAttributes = {
	.headImage = @"headImage",
	.nickName = @"nickName",
	.oid = @"oid",
};

const struct NWDUserInfoRelationships NWDUserInfoRelationships = {
};

const struct NWDUserInfoFetchedProperties NWDUserInfoFetchedProperties = {
};

@implementation NWDUserInfoID
@end

@implementation _NWDUserInfo

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"UserInfo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:moc_];
}

- (NWDUserInfoID*)objectID {
	return (NWDUserInfoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic headImage;






@dynamic nickName;






@dynamic oid;











@end
