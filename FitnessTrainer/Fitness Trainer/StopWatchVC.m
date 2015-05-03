//
//  StopWatchVC.m
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 27.04.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "StopWatchVC.h"

@interface StopWatchVC ()

@property (strong, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)startButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic) bool running;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval stopTime;

@property (strong, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)resetButton:(id)sender;


@end

@implementation StopWatchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Секундомер";
    
    self.timeLabel.text = @"0:00.0";
    self.running = NO;
    [self.resetButton setHidden:YES];
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

- (void)updateTime
{
    if(!self.running) return;
    
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsedTime = currentTime - self.startTime;
    
    int minutes = (int)(elapsedTime / 60.0);
    elapsedTime -= minutes * 60;
    int seconds = (int)elapsedTime;
    elapsedTime -= seconds;
    int fraction = elapsedTime * 10.0;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%u:%02u.%u", minutes, seconds, fraction];
    
    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
}

- (IBAction)startButtonPressed:(id)sender
{
    if(!self.running)
    {
        self.running = YES;
        self.startTime = [NSDate timeIntervalSinceReferenceDate] - (self.stopTime - self.startTime);
        [self.startButton setTitle:@"Стоп" forState:UIControlStateNormal];
        [self.resetButton setHidden:YES];
        [self updateTime];
    }
    else
    {
        [self.startButton setTitle:@"Старт" forState:UIControlStateNormal];
        self.stopTime = [NSDate timeIntervalSinceReferenceDate];
        [self.resetButton setHidden:NO];
        self.running = NO;
    }
}

- (IBAction)resetButton:(id)sender
{
    self.stopTime = 0;
    self.startTime = 0;
    self.timeLabel.text = @"0:00.0";
    self.running = NO;
    [self.resetButton setHidden:YES];
}
@end
