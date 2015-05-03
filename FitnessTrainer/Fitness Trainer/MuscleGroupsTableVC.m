//
//  MuscleGroupsTableVC.m
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 31.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "MuscleGroupsTableVC.h"
#import "ExerciseData.h"
#import "MusleTableViewCell.h"
#import "ExercisesTableVC.h"

@interface MuscleGroupsTableVC ()

@end

@implementation MuscleGroupsTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.muscleGroups = [ExerciseData getMuscleGroups];
    
    self.navigationItem.title = @"Группы мышц";
    
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
    return [self.muscleGroups count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"muscleGroupCell" forIndexPath:indexPath];
    
    NSDictionary *muscleGroupDictionary = [self.muscleGroups objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [muscleGroupDictionary objectForKey:MUSCLE_GROUP_NAME];
    cell.imageView.image = [UIImage imageNamed:[muscleGroupDictionary objectForKey:MUSCLE_GROUP_PICTURE]];
    cell.muscleGroupNumber = [[muscleGroupDictionary objectForKey:MUSCLE_GROUP_NUMBER] integerValue];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showExercises"])
        if ([segue.destinationViewController isKindOfClass:[ExercisesTableVC class]])
        {
            MusleTableViewCell *senderCell = (MusleTableViewCell *)sender;
            ExercisesTableVC *targetVC = segue.destinationViewController;
            targetVC.muscleGroupNumber = senderCell.muscleGroupNumber;
            targetVC.muscleGroupName = senderCell.textLabel.text;
        }
        
}


@end
