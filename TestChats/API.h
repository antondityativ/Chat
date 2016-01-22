//
//  API.h
//  TestChats
//
//  Created by Антон Дитятив on 20.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRKeyChain.h"


@interface API : NSObject

+ (API *)shareAPI;

typedef void (^ChatsCompletion)(id response, NSError *error);

-(void)loginWithCompletion:(ChatsCompletion)complete;
-(void)validationWithCompletion:(ChatsCompletion)complete;
-(void)getMessagesWithCompletion:(ChatsCompletion)complete;

@end
