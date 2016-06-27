//
//  DataManager.m
//  PromotionCard
//
//  Created by Home on 2/5/16.
//  Copyright © 2016 Anish Kumar. All rights reserved.
//

#import "DataManager.h"

static NSTimeInterval reqTimeoutInterval = 20;

@implementation DataManager

+ (void)GETDataFromURL:(NSURL *)url completionHandler:(void (^)(NSData *data))completionHandler {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:reqTimeoutInterval];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Error on retrieving data: %@", error.localizedDescription);
                        completionHandler(nil);
                        return;
                    }
                    
                    completionHandler(data);
                    
                }] resume];
}

@end
