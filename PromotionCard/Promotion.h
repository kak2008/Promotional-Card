//
//  Promotion.h
//  PromotionCard
//
//  Created by Home on 2/4/16.
//  Copyright © 2016 Anish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Promotion : NSObject

@property (nonatomic, strong) NSDictionary *button;

@property (nonatomic, strong) NSString *promotionDescription;

@property (nonatomic, strong) NSString *footer;

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *title;

- (id)initWithPromotionDetails:(NSDictionary *)details;

@end
