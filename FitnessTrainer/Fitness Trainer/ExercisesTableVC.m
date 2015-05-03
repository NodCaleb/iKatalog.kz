//
//  ExercisesTableVC.m
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 01.04.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "ExercisesTableVC.h"
#import "ExerciseData.h"
#import "ExerciseTableViewCell.h"
#import "ExerciseDetailsVC.h"

@interface ExercisesTableVC ()

@end

@implementation ExercisesTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exercises = [ExerciseData getExercisesForGroup:self.muscleGroupNumber];
    self.navigationItem.title = self.muscleGroupName;
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

#pragma mark - Table view data source

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.exercises count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exerciseCell" forIndexPath:indexPath];
    
    NSDictionary *exerciseDictionary = [self.exercises objectAtIndex:indexPath.row];
    
    cell.exerciseNumber = [[exerciseDictionary objectForKey:EXERCISE_NUMBER] integerValue];
    cell.textLabel.text = [exerciseDictionary objectForKey:EXERCISE_NAME];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showExerciseDetails"] && [segue.destinationViewController isKindOfClass:[ExerciseDetailsVC class]])
    {
        ExerciseTableViewCell *senderCell = (ExerciseTableViewCell *)sender;
        ExerciseDetailsVC *targetVC = segue.destinationViewController;
        targetVC.exerciseNumber = senderCell.exerciseNumber;
    }
}


@end
