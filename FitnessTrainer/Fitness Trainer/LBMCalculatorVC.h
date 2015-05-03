//
//  LBMCalculatorVC.h
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 04.04.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMCalculatorVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *bodyWeightLabel;
@property (strong, nonatomic) IBOutlet UISlider *weightSlider;
@property (strong, nonatomic) IBOutlet UILabel *bodyHeightLabel;
@property (strong, nonatomic) IBOutlet UISlider *heightSlider;
@property (strong, nonatomic) IBOutlet UILabel *weihtPercentageLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSelector;


- (IBAction)weightSliderChanged:(id)sender;
- (IBAction)heightSliderChanged:(id)sender;
- (IBAction)genderChanged:(id)sender;


@end
