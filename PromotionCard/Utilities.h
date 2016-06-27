//
//  Utilities.h
//  PromotionCard
//
//  Created by Home on 2/4/16.
//  Copyright © 2016 Anish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

+ (void)downloadImageFromURL:(NSString *)urlStr withCompletionBlock:(void (^) (NSData * imageData))completionBlock;

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize;

+ (NSDictionary *)dictionaryFromNSData:(NSData *)data;

// Extra
+ (NSDictionary *)getJsonFromFileName:(NSString *)fileName;

//TODO: UNIT TEST
+ (BOOL)isValidString:(NSString *)string;

@end
