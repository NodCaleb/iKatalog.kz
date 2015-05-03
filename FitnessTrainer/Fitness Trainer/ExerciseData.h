//
//  ExerciseData.h
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 25.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MUSCLE_GROUP_NUMBER @"Number of mucsle group"
#define MUSCLE_GROUP_NAME @"Name of mucsle group"
#define MUSCLE_GROUP_PICTURE @"Picture of muscle group"
#define EXERCISE_NUMBER @"Number of exercise"
#define EXERCISE_NAME @"Name of exercise"
#define EXERCISE_PICTURE @"Picture of exercise"
#define EXERCISE_DESCRIPTION @"Description of exercise"

@interface ExerciseData : NSObject

+ (NSArray *) getMuscleGroups; //Группы мышц, данные для первой таблицы вкладки Тренировки
+ (NSArray *) getAllExercises;
+ (NSArray *) getExercisesForGroup:(int)groupNumber; //Тренировки для выбранной группы мышц, данные для второй таблицы вкладки Тренировки
+ (NSArray *) getAllExercisePictures;
+ (NSDictionary *) getDetailsForExerciseWithNumber:(int)exerciseNumber;
+ (NSArray *) getPicturesForExercise:(int)exerciseNumber;

@end
