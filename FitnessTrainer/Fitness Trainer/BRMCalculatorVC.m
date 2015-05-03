//
//  BRMCalculatorVC.m
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 04.04.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "BRMCalculatorVC.h"

@interface BRMCalculatorVC ()

@end

@implementation BRMCalculatorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateLabels];
    UIImage *backGroundImage = [UIImage imageNamed:@"blurshvarc1.jpg"];
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    UIImage *resizedImage = [self resizedImage:backGroundImage toSize:newSize];
    
    UIColor *backGroundColor = [UIColor colorWithPatternImage:resizedImage];
    self.view.backgroundColor = backGroundColor;
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

- (IBAction)ageChanged:(id)sender
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

    int gender;
    
    if (self.genderSelector.selectedSegmentIndex == 0) gender = 5;
    else gender = -161; //Самая быстрая операция по смене пола в мире!
    
    self.bodyWeightLabel.text = [NSString stringWithFormat:@"%.f кг.", self.weightSlider.value];
    self.heightLabel.text = [NSString stringWithFormat:@"%.f см.", self.heightSlider.value];
    self.ageLabel.text = [NSString stringWithFormat:@"%.f лет", self.ageSlider.value];
    float BRM = [self getBRMforWeight:self.weightSlider.value andHeight:self.heightSlider.value andAge:self.ageSlider.value andGender:gender];
    self.weihtPercentageLabel.text = [NSString stringWithFormat:@"%.02f ", BRM];
    self.commentLabel.text = [self getCommentForBRM:BRM];

}

- (float)getBRMforWeight:(float)weight andHeight:(float)height andAge:(float)age andGender:(int)gender
{
    // (10 x weight) + (6.25 x height) – (5 x age) + 5
    return (10 * weight) + (6.25f * height) - (5 * age) + gender;
}


- (NSString *)getCommentForBRM:(float)BRM
{
           if (BRM <= 1500) return @"Вкладка Питание (Набор массы)";
        else if (BRM > 1501 & BRM <= 1800) return @"Вкладка Питание (Сушка)";
         return @"Вкладка Питание (Похудение)";
    
}

@end
