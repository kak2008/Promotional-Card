//
//  Promotion.m
//  PromotionCard
//
//  Created by Home on 2/4/16.
//  Copyright © 2016 Anish Kumar. All rights reserved.
//

#import "Promotion.h"

static NSString *const kPromotionDetailKeyButton = @"button";
static NSString *const kPromotionDetailKeyDescription = @"description";
static NSString *const kPromotionDetailKeyFooter = @"footer";
static NSString *const kPromotionDetailKeyImage = @"image";
static NSString *const kPromotionDetailKeyTitle = @"title";

@implementation Promotion

- (id)initWithPromotionDetails:(NSDictionary *)details {
    if (!details || details.count == 0) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _button                 = [self parseButtonDetailsFromPromotionDetails:details];
        _footer                 = [details objectForKey:kPromotionDetailKeyFooter];
        _image                  = [details objectForKey:kPromotionDetailKeyImage];
        _title                  = [details objectForKey:kPromotionDetailKeyTitle];
        _promotionDescription   = [details objectForKey:kPromotionDetailKeyDescription];
    }
    
    return self;
}

- (NSDictionary *)parseButtonDetailsFromPromotionDetails:(id)details {
    if ([[details objectForKey:kPromotionDetailKeyButton] isKindOfClass:[NSDictionary class]]) {
        return [details objectForKey:kPromotionDetailKeyButton];
    }
    
    if ([[details objectForKey:kPromotionDetailKeyButton] isKindOfClass:[NSArray class]]) {
        return [[details objectForKey:kPromotionDetailKeyButton] objectAtIndex:0];
    }
    
    return nil;
}

@end
