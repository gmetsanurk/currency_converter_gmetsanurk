#if USING_OBJC
#import <XCTest/XCTest.h>
#import "AccessibilityIdentifiersObjC.h"

@interface HomeViewObjCUITests : XCTestCase

@end

@implementation HomeViewObjCUITests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;

}

- (void)tearDown {
    [super tearDown];
}

- (void)testHomeViewElementsExist {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    XCTAssertTrue([app.buttons[[AccessibilityIdentifiersObjC selectSourceCurrency]] exists], @"selectSourceCurrency button should exist");
    XCTAssertTrue([app.buttons[[AccessibilityIdentifiersObjC fromButton]] exists], @"fromButton should exist");
    XCTAssertTrue([app.buttons[[AccessibilityIdentifiersObjC toButton]] exists], @"toButton should exist");
    XCTAssertTrue([app.textFields[[AccessibilityIdentifiersObjC currencyAmountTextField]] exists], @"currencyAmountTextField should exist");
    XCTAssertTrue([app.buttons[[AccessibilityIdentifiersObjC convertButton]] exists], @"convertButton should exist");
}


@end
#endif
