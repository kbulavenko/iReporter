//
//  API.m
//  iReporter
//
//  Created by Z on 01.11.17.
//  Copyright © 2017 Marin Todorov. All rights reserved.
//

#import "API.h"

//the web location of the service
#define kAPIHost @"http://iostest.pp.ua"
#define kAPIPath @"upload/"

@implementation API
@synthesize user;

#pragma mark - Singleton methods
/**
  * Singleton methods
**/
+ (API *)sharedInstance {
    static  API  *sharedInstance = nil;
    static  dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc]   initWithBaseURL: [NSURL  URLWithString: kAPIHost]];
    });
    return sharedInstance;
}

#pragma mark - init
//initialize the API class with the destination host name

- (instancetype)init
{
    //call super init
    self = [super init];
    if( self  != nil) {
        //initialize the object
        self.user = nil;
        
        [self registerHTTPOperationClass: [AFJSONRequestOperation class]];
        
        //Accept HTTP Header; see http://www.w3.org/Protocol/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
    
}



//check wether there's an authorized user
- (BOOL)isAuthorized
{
    return ( [[user  objectForKey:@"IdUser"] intValue] > 0 );
}

//send an API command to the server
- (void)commandWithParams:(NSMutableDictionary *)params onCompletition:(JSONResponseBlock)completitionBlock
{
    NSMutableURLRequest  *apiRequest =
    [self multipartFormRequestWithMethod:@"POST"
                                    path:kAPIPath
                              parameters:params
               constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                  //TODO: attach file if needed
               }];
    AFJSONRequestOperation  *operation = [[AFJSONRequestOperation alloc]  initWithRequest: apiRequest];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       //success
        completitionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completitionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
    
}


@end
