#import "NWDUserInfo.h"


@interface NWDUserInfo ()

// Private interface goes here.

@end


@implementation NWDUserInfo


// Custom logic goes here.
+ (NWDUserInfo *)currentUserInfo
{
    NSString *currentUserID = AppContext.currentUserID;
    if (currentUserID.length == 0) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"oid = %@ AND isCurrent = YES", currentUserID];
    NWDUserInfo *currentUser = [NWDUserInfo MR_findFirstWithPredicate:predicate];
    if (!currentUser) {
        // 为了防止数据库数据删除（比如model未匹配而删除数据库数据）之后，取不到数据，就退出登录
//        [[[NADUserLogoutService alloc] initWithDelegate:nil] logoutUser];
//        [AppContext clearCurrentUserData];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [AppContext.rootController showPreHomeScreenWithDelay:NO];
        //        });
        return nil;
    }
    return currentUser;
}

+ (NWDUserInfo *)updateCurrentUserInfo:(NWDUserInfo *)user
{
    NWDUserInfo *currentUser = [self currentUserInfo];
//    if (currentUser && [currentUser.oid isEqualToString:user.oid]) {
//        currentUser.nickName = user.nickName;
//        currentUser.headImage = user.headImage;
//        currentUser.mobile = user.mobile;
//        currentUser.isWxBinding = user.isWxBinding;
//        currentUser.authType = user.authType;
//        [currentUser save];
//    }
    return currentUser;
}

#pragma mark - JSON Parser

+ (id)createModelFromJSONData:(NSDictionary *)json inContext:(NSManagedObjectContext *)context
{
    // 新建当前数据缓存对象
    NWDUserInfo *newObject = [AFCacheManage createNewObjectInClass:self inContext:context];
    [newObject createAttribute:@"oid" data:[WKParserUtil stringValue:json key:@"id"]];
    [newObject createAttribute:@"nickName" data:[WKParserUtil stringValue:json key:@"nick_name"]];
    
    // 将数据同步到拥有相同oid的已缓存对象
    if (newObject.oid.length > 0) {
        NSArray *cachedObjects = [AppCache fetchObjectsByOid:newObject.oid inClass:self inContext:context];
        [cachedObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (obj != newObject) {
                [obj updateModelFromJSONData:json];
            }
        }];
    }
    
    return newObject;
}

- (void)updateModelFromJSONData:(NSDictionary *)json
{
    [self updateAttribute:@"oid" data:[WKParserUtil stringValue:json key:@"id"]];
    [self updateAttribute:@"nickName"  data:[WKParserUtil stringValue:json key:@"nick_name"]];
}

@end
