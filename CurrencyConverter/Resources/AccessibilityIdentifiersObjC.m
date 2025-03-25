#import <Foundation/Foundation.h>
#if USING_OBJC
#import "AccessibilityIdentifiersObjC.h"

@interface AccessibilityIdentifiersObjC ()


@property (nonatomic, strong) NSString *selectSourceCurrency;
@property (nonatomic, strong) NSString *fromButton;
@property (nonatomic, strong) NSString *toButton;
@property (nonatomic, strong) NSString *convertButton;
@property (nonatomic, strong) NSString *currencyAmountTextField;
@property (nonatomic, strong) NSString *keyboardDone;

- (NSString *)selectSourceCurrency;
- (NSString *)fromButton;
- (NSString *)toButton;
- (NSString *)convertButton;
- (NSString *)currencyAmountTextField;
- (NSString *)keyboardDone;

@end

@implementation AccessibilityIdentifiersObjC

- (NSString *)selectSourceCurrency {
    return @"home_view.select_source_currency";
}

- (NSString *)fromButton {
    return @"home_view.from";
}

- (NSString *)toButton {
    return @"home_view.to";
}

- (NSString *)convertButton {
    return @"home_view.convert";
}

- (NSString *)currencyAmountTextField {
    return @"home_view.currency_amount_text_field";
}

- (NSString *)keyboardDone {
    return @"home_view.keyboard_done";
}

@end
#endif
