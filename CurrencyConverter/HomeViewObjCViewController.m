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

    
    // self.presenter = [[HomePresenter alloc] init];
}

- (void)setupView {
    self.view.backgroundColor = UIColor.greenColor;
    
    [self setupSelectedCurrencyLabel];
    
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

@end
