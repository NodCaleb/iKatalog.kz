//
//  ViewController.h
//  Timer2
//
//  Created by Admin on 06.04.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

int CountNumber;

@interface ViewController : UIViewController
{
    IBOutlet UILabel *TimerDisplay;
    
    NSTimer *Timer;

}

-(void)TimerCount;
-(IBAction)Start:(id)sender;
-(IBAction)Stop:(id)sender;
-(IBAction)Restart:(id)sender;
@end

