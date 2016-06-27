//
//  Utilities.m
//  PromotionCard
//
//  Created by Home on 2/4/16.
//  Copyright © 2016 Anish Kumar. All rights reserved.
//

#import "Utilities.h"
#import "DataManager.h"

@implementation Utilities

+ (void)downloadImageFromURL:(NSString *)urlStr withCompletionBlock:(void (^) (NSData * imageData))completionBlock {
    
    if (!urlStr || urlStr.length == 0) {
        completionBlock(nil);
        return;
    }
    
    [DataManager GETDataFromURL:[NSURL URLWithString:urlStr] completionHandler:completionBlock];
}

+ (NSDictionary *)getJsonFromFileName:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"feed" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return [self dictionaryFromNSData:data];
}

+ (NSDictionary *)dictionaryFromNSData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    NSError *conversionError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&conversionError];
    if (conversionError) {
        NSLog(@"Error converting received data: %@", conversionError.localizedDescription);
        return nil;
    }
    
    return json;
}

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize {
    if (!image || CGSizeEqualToSize(newSize, CGSizeZero)) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (BOOL)isValidString:(NSString *)string {
    return (string && [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0);
}

@end
