#import "CurrentConverterApp-Swift.h"
#import "HomeViewObjCViewController.h"

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

@interface HomeViewObjCViewController () <UITextFieldDelegate>

//@property (nonatomic) HomePresenter* presenter;
@property (weak, nullable) UILabel *selectedCurrencyLabel;
@property (weak, nullable) UIButton *convertFromButton;
@property (weak, nullable) UIButton *convertToButton;
@property (weak, nullable) UITextField *currencyAmountTextField;
@property (weak, nullable) UIButton *doConvertActionButton;
@property (nonatomic) UIConstants constants;

@end

@implementation HomeViewObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupConstraints];
    [self setupActions];
    
    // self.presenter = [[HomePresenter alloc] init];

    _constants = createUIConstants(100);
    int aaa = _constants.selectedCurrencyLabelTop;

    MyCallback2 pointerToFunc = someOtherFunc;
}

- (void)setupView {
    self.view.backgroundColor = UIColor.greenColor;
    
    [self setupSelectedCurrencyLabel];
    [self setupConvertFromButton];
    [self setupConvertToButton];
    [self setupCurrencyAmountTextField];
    [self setupDoConvertActionButton];
}
#pragma mark setup methods
- (void)setupSelectedCurrencyLabel {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"-";
    label.textAlignment = NSTextAlignmentCenter;
    self.selectedCurrencyLabel = label;

    [self.view addSubview:self.selectedCurrencyLabel];
}

- (void)setupConvertFromButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"From" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor systemBlueColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    self.convertFromButton = button;
    [self.view addSubview:button];
}

- (void)setupConvertToButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"To" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor systemBlueColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    self.convertToButton = button;
    [self.view addSubview:button];
}

- (void)setupCurrencyAmountTextField {
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"Enter Amount";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    self.currencyAmountTextField = textField;
    [self.view addSubview:textField];
}

- (void)setupDoConvertActionButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Convert" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor systemBlueColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    self.doConvertActionButton = button;
    [self.view addSubview:button];
}

- (void)setupConstraints{
    [self setupSelectedCurrencyLabelConstraints];
    [self setupConvertFromButtonConstraints];
    [self setupConvertToButtonConstraints];
    [self setupCurrencyAmountTextFieldConstraints];
    [self setupDoConvertActionButtonConstraints];
}
#pragma mark constraints
- (void)setupSelectedCurrencyLabelConstraints {
    self.selectedCurrencyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.selectedCurrencyLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:_constants.selectedCurrencyLabelTop],
        [self.selectedCurrencyLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}

- (void)setupConvertFromButtonConstraints {
    self.convertFromButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.convertFromButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:250],
        [self.convertFromButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-55],
        [self.convertFromButton.widthAnchor constraintEqualToConstant:100],
        [self.convertFromButton.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (void)setupConvertToButtonConstraints {
    self.convertToButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.convertToButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:250],
        [self.convertToButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:55],
        [self.convertToButton.widthAnchor constraintEqualToConstant:100],
        [self.convertToButton.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (void)setupCurrencyAmountTextFieldConstraints {
    self.currencyAmountTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.currencyAmountTextField.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:310],
        [self.currencyAmountTextField.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.currencyAmountTextField.widthAnchor constraintEqualToConstant:210]
    ]];
}

- (void)setupDoConvertActionButtonConstraints {
    self.doConvertActionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.doConvertActionButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:360],
        [self.doConvertActionButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.doConvertActionButton.widthAnchor constraintEqualToConstant:210]
    ]];
}
#pragma mark action setup
- (void)setupActions {
    [self.convertFromButton addTarget:self action:@selector(convertFromButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.convertToButton addTarget:self action:@selector(convertToButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.doConvertActionButton addTarget:self action:@selector(doConvertActionTapped) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - methods for actions

- (void)convertFromButtonTapped {
    NSLog(@"ConvertFrom button tapped");
}

- (void)convertToButtonTapped {
    NSLog(@"ConvertTo button tapped");
}

- (void)doConvertActionTapped {
    NSLog(@"DoConvertAction button tapped");
}
@end
