//
//  NWDContext.m
//  NetWorkingDemo
//
//  Created by zjc on 16/3/1.
//  Copyright © 2016年 zjc. All rights reserved.
//

#import "NWDContext.h"
#import "AFBaseCache.h"

@interface NWDContext () <UINavigationControllerDelegate>
{
    NSMutableArray *_presentedViewControllers;
     NSString *_serverAddress;
     NSString *_currentUserID;
}

@end

@implementation NWDContext

@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootController = _rootController;

+ (id)sharedInstance
{
    static NWDContext *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NWDContext alloc] init];
        
    });
    return sharedInstance;
}


- (NSString *)currentUserID
{
    if (!_currentUserID) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _currentUserID = [defaults objectForKey:@"CurrentUser"];
    }
    return _currentUserID;
}

- (void)setCurrentUserID:(NSString *)currentUserID
{
    if (![_currentUserID isEqualToString:currentUserID]) {
        _currentUserID = [currentUserID copy];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:currentUserID forKey:@"CurrentUser"];
        [defaults synchronize];
    }
}


- (NSString *)serverAddress
{
    if (!_serverAddress) {
        NSDictionary *serverConfig = [WKFileUtil dictionaryFromConfig:@"application.plist"];
        _serverAddress = serverConfig[@"serverBaseURL"];
    }
    return _serverAddress;
}

#pragma mark - Modal View Controller

- (UIViewController *)topPresentedViewController
{
    return _presentedViewControllers.lastObject;
}


- (void)presentViewController:(UIViewController *)viewController
{
    if (!_presentedViewControllers) {
        _presentedViewControllers = [NSMutableArray arrayWithCapacity:4];
    }
    [_presentedViewControllers addObject:viewController];
}

- (UIView*)topMostView
{
    return [[UIApplication sharedApplication] keyWindow];
}

#pragma mark - Public Method

- (void)initializeAppOnLaunching
{
    [self initializeUserInterface];
    [self initializeModel];
}

- (void)initializeModel
{
    // clear database if current db data doesn't match data model
    [MagicalRecord setLoggingLevel:AppMagicalRecordLogLevel];
    [MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"NetWorkingDemo.sqlite"];
    // initialize WKCacheManager
    [AppCache setupCacheImplementation:[[AFBaseCache alloc] init]];
}

- (void)initializeUserInterface
{
    
    // root controller
    NWDRootController *rootController = [[NWDRootController alloc] initWithNibName:@"NWDRootController" bundle:nil];
    _rootController = rootController;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootController];
    navController.delegate = self;
    AppDelegate.window.rootViewController = navController;
    _globalNavigationController = navController;
}

- (void)dismissViewController:(UIViewController *)viewController
{
    UIViewController *presentedController = viewController;
    if (presentedController.navigationController) {
        presentedController = presentedController.navigationController;
    }
    if (_presentedViewControllers.count == 0 || _presentedViewControllers.lastObject != presentedController) {
        DDLogWarn(@"[Modal] Controller %@ is not the toppest one!", presentedController);
        [_presentedViewControllers removeObject:presentedController];
    } else {
        [_presentedViewControllers removeLastObject];
    }
    if (_presentedViewControllers.count == 0) {
        _presentedViewControllers = nil;
    }
}

@end
