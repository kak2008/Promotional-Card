//
//  DataManager.h
//  PromotionCard
//
//  Created by Home on 2/5/16.
//  Copyright © 2016 Anish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (void)GETDataFromURL:(NSURL *)url completionHandler:(void (^)(NSData *data))completionHandler;

@end
