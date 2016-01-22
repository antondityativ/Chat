//
//  TRKeyChain.h
//  Triathlon
//
//  Created by Антон Дитятив on 22.12.15.
//  Copyright © 2015 LiveTyping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRKeyChain : NSObject


+(TRKeyChain *)sharedKeychain;

- (void)keyChainSaveKey:(NSString *)key data:(id)data;
- (id)keyChainLoadKey:(NSString *)key;
- (void)keyChainDeleteKey:(NSString *)service;

@end
