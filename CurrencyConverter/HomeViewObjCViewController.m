#import "CurrentConverterApp-Swift.h"
#import "HomeViewObjCViewController.h"
#import "Masonry.h"

#include "math.h"

struct SSS {
    int a;
};

typedef struct {
    double selectedCurrencyLabelTop;
} UIConstants;

UIConstants createUIConstants(double selectedCurrencyLabelTop) {
    UIConstants result;
    result.selectedCurrencyLabelTop = selectedCurrencyLabelTop;
    return result;
}

typedef double(^MyCallback)(int);
typedef double(*MyCallback2)(int);

void someFun(int a, MyCallback2 callback) {
    int b = 10;
    b++;
}

double someOtherFunc(int a) {
    return 0;
}

@interface HomeViewObjCViewController () <UITextFieldDelegate, AnyHomeView>

@property (nonatomic) HomePresenter* presenter;
@property (weak, nullable) UIButton *buttonOpenSourceCurrency;
@property (weak, nullable) UILabel *selectedCurrencyLabel;
@property (weak, nullable) UIButton *convertFromButton;
@property (weak, nullable) UIButton *convertToButton;
@property (weak, nullable) UITextField *currencyAmountTextField;
@property (weak, nullable) UIButton *doConvertActionButton;
@property (nullable) NSString* convertFromButtonSelected;
@property (nullable) NSString* convertToButtonSelected;
@property (nonatomic) UIConstants constants;

@property (nonatomic, strong) id keyboardWillShowNotification;
@property (nonatomic, strong) id keyboardWillHideNotification;

@end

@implementation HomeViewObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupConstraints];
    [self setupActions];
    [self setupKeyboardObservers];
    
    self.presenter = [[HomePresenter alloc] initWithView: self];

    _constants = createUIConstants(200);
    int aaa = _constants.selectedCurrencyLabelTop;

    MyCallback2 pointerToFunc = someOtherFunc;
}

- (void)setupView {
    self.view.backgroundColor = UIColor.yellowColor;
    
    [self setupButtonOpenSourceCurrency];
    [self setupSelectedCurrencyLabel];
    [self setupConvertFromButton];
    [self setupConvertToButton];
    [self setupCurrencyAmountTextField];
    [self setupDoConvertActionButton];
}
#pragma mark setup methods
- (void)setupSelectedCurrencyLabel {
    UILabel *label = [UILabel new];
    label.text = @"-";
    label.textAlignment = NSTextAlignmentCenter;
    self.selectedCurrencyLabel = label;

    [self.view addSubview:self.selectedCurrencyLabel];

    //[_presenter handleSelectSourceCurrencyObjC];
    //[_presenter convertCurrencyWithAmountText:nil fromCurrency:nil toCurrency:nil];
}

- (void)setupButtonOpenSourceCurrency {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:NSLocalizedString(@"home_view.select_source_currency", @"Select source curency") forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.buttonOpenSourceCurrency = button;
    [self.view addSubview:button];
}

- (void)setupConvertFromButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:NSLocalizedString(@"home_view.from", @"From button") forState:UIControlStateNormal];
    button.backgroundColor = [UIColor systemBlueColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    self.convertFromButton = button;
    [self.view addSubview:button];
}

- (void)setupConvertToButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:NSLocalizedString(@"home_view.to", @"To button") forState:UIControlStateNormal];
    button.backgroundColor = [UIColor systemBlueColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    self.convertToButton = button;
    [self.view addSubview:button];
}

- (void)setupCurrencyAmountTextField {
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = NSLocalizedString(@"home_view.enter_amount", @"Enter amount textField sign");
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    self.currencyAmountTextField = textField;
    [self.view addSubview:textField];
}

- (void)setupDoConvertActionButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:NSLocalizedString(@"home_view.convert", @"Convert button") forState:UIControlStateNormal];
    button.backgroundColor = [UIColor systemBlueColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    self.doConvertActionButton = button;
    [self.view addSubview:button];
}

- (void)setupConstraints{
    [self setupButtonOpenSourceCurrencyConstraints];
    [self setupSelectedCurrencyLabelConstraints];
    [self setupConvertFromButtonConstraints];
    [self setupConvertToButtonConstraints];
    [self setupCurrencyAmountTextFieldConstraints];
    [self setupDoConvertActionButtonConstraints];
}
#pragma mark constraints
- (void)setupButtonOpenSourceCurrencyConstraints {
    [self.buttonOpenSourceCurrency mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(350);
        make.centerX.equalTo(self.view);
    }];
}

- (void)setupSelectedCurrencyLabelConstraints {
    [self.selectedCurrencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(400);
        make.centerX.equalTo(self.view);
    }];
}

- (void)setupConvertFromButtonConstraints {
    [self.convertFromButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(450);
        make.centerX.equalTo(self.view).offset(-55);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
}

- (void)setupConvertToButtonConstraints {
    [self.convertToButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(450);
        make.centerX.equalTo(self.view).offset(55);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
}

- (void)setupCurrencyAmountTextFieldConstraints {
    [self.currencyAmountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(510);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@210);
    }];
}

- (void)setupDoConvertActionButtonConstraints {
    [self.doConvertActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(560);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@210);
    }];
}
#pragma mark action setup
- (void)setupActions {
    [self configureActionButtonOpenSourceCurrency];
    [self configureActionFromCurrencyButton];
    [self configureActionToCurrencyButton];
    [self configureDoConvertActionButton:self.doConvertActionButton];
}
- (void)configureActionButtonOpenSourceCurrency {
    __weak HomeViewObjCViewController *weakSelf = self;
    [self.buttonOpenSourceCurrency addAction:[UIAction actionWithHandler:^(UIAction* _Nonnull action) {
        [weakSelf.presenter handleSelectSourceCurrencyObjC];
    }] forControlEvents:UIControlEventPrimaryActionTriggered];
}

- (void)configureActionFromCurrencyButton {
    __weak HomeViewObjCViewController *weakSelf = self;
    [self.convertFromButton addAction:[UIAction actionWithHandler:^(UIAction* _Nonnull action) {
        [weakSelf.presenter handleSelectFromCurrencyObjC];
    }] forControlEvents:UIControlEventPrimaryActionTriggered];
}
- (void)configureActionToCurrencyButton{
    __weak HomeViewObjCViewController *weakSelf = self;
    [self.convertToButton addAction:[UIAction actionWithHandler:^(UIAction* _Nonnull action) {
        [weakSelf.presenter handleSelectToCurrencyObjC];
    }] forControlEvents:UIControlEventPrimaryActionTriggered];
}

- (void)configureDoConvertActionButton:(UIButton *)button {
    [button addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        NSString *amountTextString = self.currencyAmountTextField.text;
        if (amountTextString.length == 0) {
            return; 
        }
        [self.presenter convertCurrencyObjCWithAmountText:amountTextString fromCurrency:_convertFromButtonSelected toCurrency:_convertToButtonSelected];
    }] forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - methods for actions

- (NSString *)currencySelected:(CoreDataCurrency *)currency button:(UIButton *)button {
    if (!currency) {
        [button setTitle:@"Select source currency" forState:UIControlStateNormal];
        self.selectedCurrencyLabel.text = @"";
        return @"";
    }
    
    [button setTitle:currency.code forState:UIControlStateNormal];
    self.selectedCurrencyLabel.text = currency.fullName;
    return currency.code ?: @"";
}

- (void)presentWithScreen:(id<AnyScreen> _Nonnull) screen {
    [self presentViewController:(UIViewController*)screen animated:YES completion:^{
        
    }];
}

- (void)conversionCompletedWithResult:(NSString * _Nonnull)result { 
    dispatch_async(dispatch_get_main_queue(), ^{
        self.selectedCurrencyLabel.text = result;
    });
}

- (void)fromCurrencySelectedWithCurrency:(CoreDataCurrency * _Nullable)currency {
    if (currency) {
        NSString* selectedValue = [self currencySelected:currency button:self.convertFromButton];
        _convertFromButtonSelected = selectedValue;
    } else {
        NSLog(@"Error selecting FromButton currency");
    }
}

- (void)toCurrencySelectedWithCurrency:(CoreDataCurrency * _Nullable)currency { 
    if (currency) {
        NSString* selectedValue = [self currencySelected:currency button:self.convertToButton];
        _convertToButtonSelected = selectedValue;
    } else {
        NSLog(@"Error selecting ToButton currency");
    }
}

# pragma mark - keybord creation

/*- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing called: %@", textField);
}*/

- (void)setupKeyboardObservers {
    __weak typeof(self) weakSelf = self;
    
    self.keyboardWillShowNotification = [[NSNotificationCenter defaultCenter]
            addObserverForName:UIKeyboardWillShowNotification
            object:nil
            queue:[NSOperationQueue mainQueue]
            usingBlock:^(NSNotification * _Nonnull note) {
                NSLog(@"UIKeyboardWillShowNotification received");
                [weakSelf setupKeyboardWillShow];
    }];

    self.keyboardWillHideNotification = [[NSNotificationCenter defaultCenter]
            addObserverForName:UIKeyboardWillHideNotification
            object:nil
            queue:[NSOperationQueue mainQueue]
            usingBlock:^(NSNotification * _Nonnull note) {
                NSLog(@"UIKeyboardWillHideNotification received");
                [weakSelf setupKeyboardWillHide];
    }];
}

- (void)setupKeyboardWillShow {
    CGRect frame = self.view.frame;
    frame.origin.y = -200;
    self.view.frame = frame;
}

- (void)setupKeyboardWillHide {
    CGRect frame = self.view.frame;
    frame.origin.y = 0.0;
    self.view.frame = frame;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
