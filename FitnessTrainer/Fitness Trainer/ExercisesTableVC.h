//
//  ExercisesTableVC.h
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 01.04.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExercisesTableVC : UITableViewController

@property (nonatomic) int muscleGroupNumber;
@property (strong, nonatomic) NSArray *exercises;
@property (strong, nonatomic) NSString *muscleGroupName;

@end
