//
//  ViewController.m
//  Timer2
//
//  Created by Admin on 06.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
-(IBAction)Start:(id)sender;

{
    
    Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerCount) userInfo:nil repeats:YES];
    
}


-(void)TimerCount

{
    
    CountNumber = CountNumber + 1;
    TimerDisplay.text = [NSString stringWithFormat:@"%i", CountNumber];
    
    
}


-(IBAction)Stop:(id)sender

{
    
    [Timer invalidate];
    
    
}

-(IBAction)Restart:(id)sender

{

    CountNumber = 0;
    TimerDisplay.text = [NSString stringWithFormat:@"0"];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *backGroundImage = [UIImage imageNamed:@"blur.png"];
    
    CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    UIImage *resizedImage = [self resizedImage:backGroundImage toSize:newSize];
    
    UIColor *backGroundColor = [UIColor colorWithPatternImage:resizedImage];
    self.view.backgroundColor = backGroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
