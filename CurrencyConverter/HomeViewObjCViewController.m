#import "CurrentConverterApp-Swift.h"
#import "HomeViewObjCViewController.h"

@interface HomeViewObjCViewController (PrivateSection) <UITextFieldDelegate>

//@property (nonatomic) HomePresenter* presenter;
@property (weak, nullable) UILabel *selectedCurrencyLabel;
@property (weak, nullable) UIButton *convertFromButton;
@property (weak, nullable) UIButton *convertToButton;
@property (weak, nullable) UITextField *currencyAmountTextField;
@property (weak, nullable) UIButton *doConvertActionButton;

@end

@implementation HomeViewObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    // self.presenter = [[HomePresenter alloc] init];
}

- (void)setupView {
    self.view.backgroundColor = UIColor.greenColor;
    
    //[self setupSelectedCurrencyLabel];
    //[self setupConvertFromButton];
    //[self setupConvertToButton];
    //[self setupCurrencyAmountTextField];
    //[self setupDoConvertActionButton];
}

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
    //[self setupSelectedCurrencyLabelConstraints];
}

- (void)setupSelectedCurrencyLabelConstraints {
    self.selectedCurrencyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.selectedCurrencyLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:200],
        [self.selectedCurrencyLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}
@end
