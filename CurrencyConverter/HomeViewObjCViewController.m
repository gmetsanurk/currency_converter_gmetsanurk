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

    self.view.backgroundColor = UIColor.greenColor;
    // self.presenter = [[HomePresenter alloc] init];
}

@end
