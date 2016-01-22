//
//  TRKeyChain.m
//  Triathlon
//
//  Created by Антон Дитятив on 22.12.15.
//  Copyright © 2015 LiveTyping. All rights reserved.
//

#import "TRKeyChain.h"

@implementation TRKeyChain {
    NSString *_key;
}

TRKeyChain *sharedKeychain = nil;

+ (TRKeyChain *) sharedKeychain {
    if (sharedKeychain == nil) {
        sharedKeychain = [[TRKeyChain alloc] init];
    }
    return sharedKeychain;
}

- (void)keyChainSaveKey:(NSString *)key data:(id)data
{
    _key = data;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

- (id)keyChainLoadKey:(NSString *)key
{
    if (!_key) {
        id ret = nil;
        NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
        [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
        [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
        CFDataRef keyData = NULL;
        if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
            @try {
                ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
            }
            @catch (NSException *e) {
                //NS Log(@"Unarchive of %@ failed: %@", service, e);
            }
            @finally {}
        }
        if (keyData) CFRelease(keyData);
        
        _key = ret;
    }
    
    return _key;
}

- (void)keyChainDeleteKey:(NSString *)service
{
    _key = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

//helper
- (NSMutableDictionary *)getKeychainQuery:(NSString *)key
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
            key, (__bridge id)kSecAttrService,
            key, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock, (__bridge id)kSecAttrAccessible,
            nil];
}


@end
