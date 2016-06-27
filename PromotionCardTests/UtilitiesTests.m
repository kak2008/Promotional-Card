//
//  UtilitiesTests.m
//  PromotionCard
//
//  Created by Home on 2/5/16.
//  Copyright © 2016 Anish Kumar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Utilities.h"

@interface UtilitiesTests : XCTestCase

@end

@implementation UtilitiesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - dictionaryFromNSData:

- (void)testDictionaryFromNSData_GivenNilData_ReturnsNil {
    XCTAssertNil([Utilities dictionaryFromNSData:nil]);
}

#pragma mark - resizeImage:toSize

- (void)testResizeImageToSize_GivenInvalidParameters_ReturnNil {
    XCTAssertNil([Utilities resizeImage:nil toSize:CGSizeZero], @"Invalid image parameter!");
    XCTAssertNil([Utilities resizeImage:[UIImage imageNamed:@"sampleImage.jpeg"] toSize:CGSizeZero], @"Invalid size parameter!");
}

- (void)testResizeImageToSize_GivenValidParameters_ReturnNonNilValue {
    XCTAssertNotNil([Utilities resizeImage:[UIImage imageNamed:@"sampleImage.jpeg"] toSize:CGSizeMake(1, 1)]);
}

- (void)testResizeImageToSize_GivenValidParameters_ReturnUIImageWithNewSize {
    CGSize newSize = CGSizeMake(1, 1);
    UIImage *resizedImage = [Utilities resizeImage:[UIImage imageNamed:@"NoImageAvailable.jpg"]
                                            toSize:newSize];
    
    XCTAssertTrue(CGSizeEqualToSize(resizedImage.size, newSize));
}

#pragma mark - downloadImageFromURL:withCompletionBlock:

- (void)testDownloadImageFromURLWithCompletionBlock_GivenInvalidURLString_SetsNilForDataParameterInCompletionBlock {
    [Utilities downloadImageFromURL:nil
                withCompletionBlock:^(NSData *imageData) {
                    XCTAssertNil(imageData, @"Nil URL String");
                }];
    
    [Utilities downloadImageFromURL:@" "
                withCompletionBlock:^(NSData *imageData) {
                    XCTAssertNil(imageData, @"Empty URL String");
                }];
}

@end
