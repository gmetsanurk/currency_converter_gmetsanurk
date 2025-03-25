#if USING_OBJC
#import <XCTest/XCTest.h>

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

     /*XCTAssertTrue([app.buttons[AccessibilityIdentifiersObjC.selectSourceCurrency] exists], @"selectSourceCurrency button should exist");
    XCTAssertTrue([app.buttons[AccessibilityIdentifiers.fromButton] exists], @"fromButton should exist");
    XCTAssertTrue([app.buttons[AccessibilityIdentifiers.toButton] exists], @"toButton should exist");
    XCTAssertTrue([app.textFields[AccessibilityIdentifiers.currencyAmountTextField] exists], @"currencyAmountTextField should exist");
    XCTAssertTrue([app.buttons[AccessibilityIdentifiers.convertButton] exists], @"convertButton should exist");*/
}


@end
#endif
