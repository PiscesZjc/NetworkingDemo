//
//  WKJSPatchLoader.m
//  NewAnnieDeer
//
//  Created by WeiChengjiongLH on 12/30/15.
//  Copyright © 2015 demo. All rights reserved.
//

#import "WKJSPatchLoader.h"
#import "JPEngine.h"
#import "ZipArchive.h"
#import "RSA.h"
#import <CommonCrypto/CommonDigest.h>


/**
 * 下载过来的脚本文件的目录结构：
 * 1. 下载下来的是一个patch.zip文件
 * 2. 解压patch.zip得到两个文件：
 *   1) script.zip文件，解压之后是该版本的所有补丁脚本，其中必须含有一个main.js文件，其余文件通过include文法进行关联
 *   2) key文件，里面存放script.zip文件的MD5校验值，用于脚本文件真实性校验
 */


#define kJSPatchEntryFile @"main.js"
#define kJSPatchRootDir @"jsPatch"
#define kJSPatchVersion(appVersion) [NSString stringWithFormat:@"WKJSPatchVersion_%@", appVersion]


#pragma mark - Utils

NSString * getAppVersion()
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

NSString * getDirectory()
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

NSString * getScriptPath(NSString *scriptFileName)
{
    if (scriptFileName.length > 0) {
        return [getDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@", kJSPatchRootDir, getAppVersion(), scriptFileName]];
    } else {
        return [getDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", kJSPatchRootDir, getAppVersion()]];
    }
}

NSDictionary * getDictionaryFromConfig(NSString *configFileName)
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:configFileName];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

NSString * getFileMD5(NSString *filePath)
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!handle) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while (!done) {
        NSData *fileData = [handle readDataOfLength:256];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if ([fileData length] == 0) {
            done = YES;
        }
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        digest[0], digest[1],
                        digest[2], digest[3],
                        digest[4], digest[5],
                        digest[6], digest[7],
                        digest[8], digest[9],
                        digest[10], digest[11],
                        digest[12], digest[13],
                        digest[14], digest[15]];
    return result;
}

#pragma mark - Loader Implementation

@implementation WKJSPatchLoader

+ (BOOL)run
{
    NSString *scriptPath = getScriptPath(kJSPatchEntryFile);
    if ([[NSFileManager defaultManager] fileExistsAtPath:scriptPath]) {
        [JPEngine startEngine];
        [JPEngine addExtensions:@[@"WKJSPatchLoaderInclude"]];
        [JPEngine evaluateScriptWithPath:scriptPath];
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)runTestScriptInBundle
{
    [JPEngine startEngine];
    [JPEngine addExtensions:@[@"WKJSPatchLoaderInclude"]];
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"main" ofType:@"js"];
    if (path) {
        NSString *script = [[NSString alloc] initWithData:[[NSFileManager defaultManager] contentsAtPath:path] encoding:NSUTF8StringEncoding];
        [JPEngine evaluateScript:script];
        return YES;
    } else {
        return NO;
    }
}

+ (NSInteger)currentVersion
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kJSPatchVersion(getAppVersion())];
}

+ (void)loadAndRunPatch
{
    NSString *appVersion = getAppVersion();
    NSInteger curPatchVersion = [self currentVersion];
    NSDictionary *config = getDictionaryFromConfig(@"jsPatchConfig.plist");
    NSURL *downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/patch/%@/%@?appid=%@&appsecret=%@", config[@"server"], appVersion, @(curPatchVersion), config[@"appId"], config[@"appSecret"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    // 发起请求下载补丁文件
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSString *versionHeader = [httpResponse allHeaderFields][@"Patch-V"];
            if (versionHeader.length == 0) {
                return;
            }
            NSInteger version = versionHeader.integerValue;
            if (version < curPatchVersion) {
                // 服务器补丁已经删除，应用本地也需要删除补丁
                [self clearPatch];
            } else if (version == curPatchVersion) {
                // 服务器补丁版本和本地补丁版本一样，表示补丁没有修改，则应用本地已有补丁即可
                [self run];
            } else {
                // 更新并应用补丁
                NSError *updateError = nil;
                BOOL updated = [self updatePatch:data version:version error:&updateError];
                if (updated) {
                    [self run];
                } else {
                    [self clearPatch];
                }
            }
        }
    }];
    [task resume];
}

#pragma mark - Private Method

+ (BOOL)updatePatch:(NSData *)patch version:(NSInteger)version error:(NSError **)error
{
    NSString *appVersion = getAppVersion();
    // 解压校验完成之后，存放补丁脚本的目录
    NSString *scriptDirectory = getScriptPath(nil);
    // 存放下载下来的patch.zip文件的临时目录
    NSString *downloadTmpPath = [NSString stringWithFormat:@"%@/patch_%@_%@", NSTemporaryDirectory(), appVersion, @(version)];
    // 存放从patch.zip解压出来的文件的临时目录，用来做校验
    NSString *unzipVerifyDirectory = [NSString stringWithFormat:@"%@/patch_%@_%@_unzipTest/", NSTemporaryDirectory(), appVersion, @(version)];
    // 存放从script.zip解压出来的补丁脚本的临时目录
    NSString *unzipTmpDirectory = [NSString stringWithFormat:@"%@/patch_%@_%@_unzip/", NSTemporaryDirectory(), appVersion, @(version)];
    // 将patch.zip存入临时目录
    [patch writeToFile:downloadTmpPath atomically:YES];
    // 解压patch.zip
    NSString *scriptZipFilePath;
    NSString *keyFilePath;
    ZipArchive *verifyZipArchive = [[ZipArchive alloc] init];
    [verifyZipArchive UnzipOpenFile:downloadTmpPath];
    BOOL verifyUnzipSuccess = [verifyZipArchive UnzipFileTo:unzipVerifyDirectory overWrite:YES];
    if (verifyUnzipSuccess) {
        for (NSString *filePath in verifyZipArchive.unzippedFiles) {
            NSString *filename = [filePath lastPathComponent];
            if ([filename isEqualToString:@"key"]) {
                // 记录校验文件路径
                keyFilePath = filePath;
            } else if ([[filename pathExtension] isEqualToString:@"zip"]) {
                // 记录补丁脚本压缩包路径
                scriptZipFilePath = filePath;
            }
        }
    } else {
        *error = [NSError errorWithDomain:@"com.weichengjiong.patch" code:WKJSPatchUpdateErrorUnzipFailed userInfo:nil];
        return NO;
    }
    // 校验key和script.zip
    NSString *md5 = getFileMD5(scriptZipFilePath);
    NSString *publicKeyFilePath = [[NSBundle mainBundle] pathForResource:@"jsPatchSSL.pub" ofType:nil];
    NSString *publickKey = [NSString stringWithContentsOfFile:publicKeyFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *encryptedMD5 = [NSString stringWithContentsOfFile:keyFilePath encoding:NSUTF8StringEncoding error:nil];
//    NSData *encryptedMD5 = [RSA decryptData:[NSData dataWithContentsOfFile:keyFilePath] publicKey:publickKey];
    NSString *decryptedMD5 = [RSA decryptString:encryptedMD5 publicKey:publickKey];
//    NSString *decryptedMD5 = [[NSString alloc] initWithData:encryptedMD5 encoding:NSUTF8StringEncoding];
    if (![decryptedMD5 isEqualToString:md5]) {
        *error = [NSError errorWithDomain:@"com.weichengjiong.patch" code:WKJSPatchUpdateErrorVerifyFailed userInfo:nil];
        return NO;
    }
    // 解压script.zip并将js文件拷贝到补丁脚本目录
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    [zipArchive UnzipOpenFile:scriptZipFilePath];
    BOOL unzipSuccess = [zipArchive UnzipFileTo:unzipTmpDirectory overWrite:YES];
    if (unzipSuccess) {
        // 清空原来的脚本目录内容
        [[NSFileManager defaultManager] removeItemAtPath:scriptDirectory error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:scriptDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        // 拷贝js文件
        for (NSString *filePath in zipArchive.unzippedFiles) {
            NSString *filename = [filePath lastPathComponent];
            // 只关心.js文件
            if ([[filename pathExtension] isEqualToString:@"js"]) {
                NSString *newFilePath = [scriptDirectory stringByAppendingPathComponent:filename];
                [[NSData dataWithContentsOfFile:filePath] writeToFile:newFilePath atomically:YES];
            }
        }
    } else {
        *error = [NSError errorWithDomain:@"com.weichengjiong.patch" code:WKJSPatchUpdateErrorUnzipFailed userInfo:nil];
        return NO;
    }
    // 清除临时目录
    [[NSFileManager defaultManager] removeItemAtPath:downloadTmpPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:unzipVerifyDirectory error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:unzipTmpDirectory error:nil];
    // 更新补丁版本信息
    [[NSUserDefaults standardUserDefaults] setInteger:version forKey:kJSPatchVersion(appVersion)];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

+ (void)clearPatch
{
    [[NSFileManager defaultManager] removeItemAtPath:getScriptPath(nil) error:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kJSPatchVersion(getAppVersion())];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

#pragma mark - Extension

@interface WKJSPatchLoaderInclude : JPExtension
@end

@implementation WKJSPatchLoaderInclude

+ (void)main:(JSContext *)context
{
    context[@"include"] = ^(NSString *fileName) {
        if (!fileName.length || [fileName rangeOfString:@".js"].location == NSNotFound) {
            return;
        }
        NSString *scriptPath = getScriptPath(fileName);
        if ([[NSFileManager defaultManager] fileExistsAtPath:scriptPath]) {
            [JPEngine startEngine];
            [JPEngine evaluateScriptWithPath:scriptPath];
        }
    };
}

@end
