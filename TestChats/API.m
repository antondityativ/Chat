//
//  API.m
//  TestChats
//
//  Created by Антон Дитятив on 20.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "API.h"
#import <AFNetworking/AFNetworking.h>

@implementation API

static API *sharedAPI = nil;
+ (API *)shareAPI {
    @synchronized (self) {
        if (sharedAPI == nil) {
            sharedAPI = [[API alloc] init];
        }
    }
    return sharedAPI;
}

- (NSString *)getCurrentUrlApi {

    return @"https://api.chateam.com/v2";
    
}


-(void)loginWithCompletion:(ChatsCompletion)complete {
    
    AFHTTPRequestOperationManager *currentRequestManager = [AFHTTPRequestOperationManager manager];
    [currentRequestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    currentRequestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *urlRequest = [NSString stringWithFormat:@"%@/users/registration",[self getCurrentUrlApi]];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@"a.ditjativ@ltst.ru" forKey:@"email"];
    [dictionary setValue:@"5913269ghjcnjnfr" forKey:@"password"];
    [dictionary setValue:@"ant_dit" forKey:@"nickname"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [currentRequestManager POST:urlRequest parameters:dictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *login = responseObject;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if(complete) {
            [[TRKeyChain sharedKeychain] keyChainSaveKey:@"access_token" data:[responseObject valueForKey:@"access_token"]];
            complete(login, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        complete(nil, error);
//        [self managerErrorWithStatusCode:[[operation response] statusCode] WithResponseObject:operation.responseObject];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

-(void)validationWithCompletion:(ChatsCompletion)complete {
    AFHTTPRequestOperationManager *currentRequestManager = [AFHTTPRequestOperationManager manager];
    [currentRequestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    currentRequestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *urlRequest = [NSString stringWithFormat:@"%@/users/validate",[self getCurrentUrlApi]];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@"7659" forKey:@"code"];
    
    NSString *token = [NSString stringWithFormat:@"%@",[[TRKeyChain sharedKeychain] keyChainLoadKey:@"access_token"]];
    
    [currentRequestManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [currentRequestManager PUT:urlRequest parameters:dictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *login = responseObject;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if(complete) {
            complete(login, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        complete(nil, error);
        //        [self managerErrorWithStatusCode:[[operation response] statusCode] WithResponseObject:operation.responseObject];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    }];
}

-(void)getMessagesWithCompletion:(ChatsCompletion)complete {
    AFHTTPRequestOperationManager *currentRequestManager = [AFHTTPRequestOperationManager manager];
    [currentRequestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    NSString *token = [NSString stringWithFormat:@"%@",[[TRKeyChain sharedKeychain] keyChainLoadKey:@"access_token"]];
    
//    [currentRequestManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    currentRequestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *urlRequest = [NSString stringWithFormat:@"%@/chats/525/messages?acc_token=%@",[self getCurrentUrlApi],token];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:[NSNumber numberWithInteger:10] forKey:@"limit"];
    [dictionary setValue:[NSNumber numberWithInteger:20] forKey:@"offset"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [currentRequestManager POST:urlRequest parameters:dictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *login = responseObject;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if(complete) {
            complete(login, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        complete(nil, error);
        //        [self managerErrorWithStatusCode:[[operation response] statusCode] WithResponseObject:operation.responseObject];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}


@end
