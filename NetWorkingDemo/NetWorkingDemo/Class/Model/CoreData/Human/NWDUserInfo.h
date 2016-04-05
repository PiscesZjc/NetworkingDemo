#import "_NWDUserInfo.h"

@interface NWDUserInfo : _NWDUserInfo {}


/*
 * 返回当前的用户信息
 */
+ (NWDUserInfo *)currentUserInfo;
+ (NWDUserInfo *)updateCurrentUserInfo:(NWDUserInfo *)user;

@end
