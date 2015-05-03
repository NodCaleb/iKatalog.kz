//
//  CountdownTimerVC.m
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 27.04.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "CountdownTimerVC.h"
#import <AudioToolbox/AudioToolbox.h>

@interface CountdownTimerVC ()

@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)startButtonPressed:(id)sender;

@property (nonatomic) bool running;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval stopTime;

@end

@implementation CountdownTimerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Таймер";
    self.timeLabel.text = @"0:00:00.0";
    self.timePicker.countDownDuration = 60.0f;
}

- (void)didReceiveMemoryWarning
{
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

- (void)updateTime
{
    if(!self.running) return;
    
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval estimstedTime = self.stopTime - currentTime;
    
    if (estimstedTime <= 0)
    {
        [self timerEnd];
        return;
    }
    
    int hours = (int)(estimstedTime / 3600.0);
    estimstedTime -= hours * 3600;
    int minutes = (int)(estimstedTime / 60.0);
    estimstedTime -= minutes * 60;
    int seconds = (int)estimstedTime;
    estimstedTime -= seconds;
    int fraction = estimstedTime * 10.0;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%u:%02u:%02u.%u", hours, minutes, seconds, fraction];
    
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
}

- (IBAction)startButtonPressed:(id)sender
{
    if(!self.running)
    {
        NSLog(@"%f", self.timePicker.countDownDuration);
        self.running = YES;
        self.stopTime = (int)[NSDate timeIntervalSinceReferenceDate] + (int)self.timePicker.countDownDuration;
        [self.startButton setTitle:@"Стоп" forState:UIControlStateNormal];
        [self updateTime];
    }
    else
    {
        [self.startButton setTitle:@"Старт" forState:UIControlStateNormal];
        self.stopTime = [NSDate timeIntervalSinceReferenceDate];
        self.running = NO;
    }
}

-(void)timerEnd
{
    self.running = NO;
    [self.startButton setTitle:@"Старт" forState:UIControlStateNormal];
    AudioServicesPlaySystemSound(1007);
    UIAlertView *timeUpAlert = [[UIAlertView alloc] initWithTitle:@"Время истекло" message:nil delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles:nil];
    
    [timeUpAlert show];
}
@end









