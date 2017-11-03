//
//  API.h
//  iReporter
//
//  Created by Z on 01.11.17.
//  Copyright © 2017 Marin Todorov. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface API : AFHTTPClient
//API call completion block with result as json
typedef void (^JSONResponseBlock)(NSDictionary* json);
//the authorized user
@property(strong, nonatomic) NSDictionary    *user;



+ (API *)sharedInstance;
//check wether there's an authorized user
- (BOOL)isAuthorized;

//send an API command to the server
- (void)commandWithParams:(NSMutableDictionary *)params onCompletition:(JSONResponseBlock)completitionBlock;



@end
