//
//  HomeViewObjCViewController.m
//  CurrentConverterApp
//
//  Created by Roman Podymov on 20.01.2025.
//

#import "HomeViewObjCViewController.h"

@interface HomeViewObjCViewController (PrivateSection)

@property (weak) UIButton* convertFromButton;

@end

@implementation HomeViewObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.greenColor;
}

@end
