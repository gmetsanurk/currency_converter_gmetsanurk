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

- (void)testExample {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

}

- (void)testLaunchPerformance {
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)) {

        [self measureWithMetrics:@[[[XCTApplicationLaunchMetric alloc] init]] block:^{
            [[[XCUIApplication alloc] init] launch];
        }];
    }
}

@end
#endif
