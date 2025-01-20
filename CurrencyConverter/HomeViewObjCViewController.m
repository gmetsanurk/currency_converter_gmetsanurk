//
//  HomeViewObjCViewController.m
//  CurrentConverterApp
//
//  Created by Roman Podymov on 20.01.2025.
//

#import "CurrentConverterApp-Swift.h"
#import "HomeViewObjCViewController.h"

@interface HomeViewObjCViewController (PrivateSection)

@property (weak, nullable) UIButton* convertFromButton;
@property (nonatomic) HomePresenter* presenter;

@end

@implementation HomeViewObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.greenColor;
    // self.presenter = [[HomePresenter alloc] init];
}

@end
