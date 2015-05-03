//
//  LBMCalculatorVC.m
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 04.04.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "LBMCalculatorVC.h"

@interface LBMCalculatorVC ()

@end

@implementation LBMCalculatorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLabels];
    UIImage *backGroundImage = [UIImage imageNamed:@"blurshvarc1.jpg"];
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    UIImage *resizedImage = [self resizedImage:backGroundImage toSize:newSize];
    
    UIColor *backGroundColor = [UIColor colorWithPatternImage:resizedImage];
    self.view.backgroundColor = backGroundColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)weightSliderChanged:(id)sender
{
    [self updateLabels];
}

- (IBAction)heightSliderChanged:(id)sender
{
    [self updateLabels];
}

- (IBAction)genderChanged:(id)sender
{
    [self updateLabels];
}

-(UIImage*) resizedImage:(UIImage*)image toSize:(CGSize)newSize
{
    if (image.size.height < image.size.width)
    {
        newSize.height = (newSize.width / image.size.width) * image.size.height;
    }
    else
    {
        newSize.width = (newSize.height / image.size.height) * image.size.width;
    }
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)updateLabels
{
    int gender = self.genderSelector.selectedSegmentIndex;
    
    
self.bodyWeightLabel.text = [NSString stringWithFormat:@"%.f кг.", self.weightSlider.value];
self.bodyHeightLabel.text = [NSString stringWithFormat:@"%.f см.", self.heightSlider.value];
    float LBM = [self getLBMforWeight:self.weightSlider.value andHeight:self.heightSlider.value andGender:gender];
self.weihtPercentageLabel.text = [NSString stringWithFormat:@"%.02f ", LBM];
    
}


- (float)getLBMforWeight:(float)weight andHeight:(float)height andGender:(int)gender
    {
        
        if (self.genderSelector.selectedSegmentIndex == 0) return (0.407 * weight) + (0.267 * height) -19.2;
        else return (0.252 * weight) + (0.473 * height) - 48.3;
        
    }
    
    
 
    

@end
