//
//  FatCalculatorVC.h
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 31.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FatCalculatorVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *bodyWieghtLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSelector;
@property (strong, nonatomic) IBOutlet UILabel *weihtPercentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UISlider *weightSlider;
@property (strong, nonatomic) IBOutlet UISlider *heightSlider;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

- (IBAction)weightSliderChanged:(id)sender;
- (IBAction)heightSliderChanged:(id)sender;
- (IBAction)genderChanged:(id)sender;
- (IBAction)ageChanged:(id)sender;



@end
