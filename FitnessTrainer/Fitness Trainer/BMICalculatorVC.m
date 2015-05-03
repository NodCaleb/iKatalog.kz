//
//  BMICalculatorVC.m
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 29.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "BMICalculatorVC.h"

@interface BMICalculatorVC ()

@end

@implementation BMICalculatorVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateBMILabels];
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

- (IBAction)massChanged:(id)sender
{
    [self updateBMILabels];
}

- (IBAction)heightCahnged:(id)sender
{
    [self updateBMILabels];
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
- (void)updateBMILabels
{
    self.bodyMassLabel.text = [NSString stringWithFormat:@"%.f кг.", self.weightSlider.value];
    self.heightLabel.text = [NSString stringWithFormat:@"%.f см.", self.heightSlider.value];
    float BMI = [self getBMIforWeight:self.weightSlider.value andHeight:self.heightSlider.value];
    self.BMILabel.text = [NSString stringWithFormat:@"%.02f", BMI];
    self.commentLabel.text = [self getCommentForBMI:BMI];
}

- (float)getBMIforWeight:(float)weight andHeight:(float)height
{
    return weight / (height * height / 10000);
}

- (NSString *)getCommentForBMI:(float)BMI
{
    if (BMI <= 16) return @"Выраженный дефицит массы тела";
    else if (BMI > 16 & BMI <= 18.5) return @"Недостаточная масса тела";
    else if (BMI > 18.5 & BMI <= 25) return @"Норма";
    else if (BMI > 25 & BMI <= 30) return @"Избыточная масса тела";
    else if (BMI > 30 & BMI <= 35) return @"Ожирение первой степени";
    else if (BMI > 35 & BMI <= 40) return @"Ожирение второй степени";
    else return @"Ожирение третьей степени";
}
@end
