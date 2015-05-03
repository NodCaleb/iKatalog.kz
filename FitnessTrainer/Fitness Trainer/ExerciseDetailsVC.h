//
//  ExerciseDetailsVC.h
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 04.04.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseDetailsVC : UIViewController

@property (nonatomic) int exerciseNumber;
@property (strong, nonatomic) NSDictionary *exerciseDetailsDictionary;
@property (strong, nonatomic) NSArray *exercisePictureArray;

@end
