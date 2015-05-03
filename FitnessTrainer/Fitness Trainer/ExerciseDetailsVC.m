//
//  ExerciseDetailsVC.m
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 04.04.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "ExerciseDetailsVC.h"
#import "ExerciseData.h"

@interface ExerciseDetailsVC ()

@end

@implementation ExerciseDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exerciseDetailsDictionary = [ExerciseData getDetailsForExerciseWithNumber:self.exerciseNumber];
    self.exercisePictureArray = [ExerciseData getPicturesForExercise:self.exerciseNumber];
    
    self.navigationItem.title = [self.exerciseDetailsDictionary objectForKey:EXERCISE_NAME];
    
    //Определяем размеры основного вида и плашек навигации вверху и внизу
    CGRect mainFrame = self.view.frame;
    CGFloat viewTop = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    CGFloat viewBottom = self.navigationController.navigationBar.frame.size.height;
    
    //Создаем прокрутку, куда потом добавим все остальное
    CGRect scrollRect = CGRectMake(mainFrame.origin.x + 8.0f,mainFrame.origin.y + 8.0f, mainFrame.size.width - 16.0f, mainFrame.size.height - 16.0f - viewBottom);
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
    
    //Втыкаем текст
    NSAttributedString *descriptionText = [[NSAttributedString alloc] initWithString:[self.exerciseDetailsDictionary objectForKey:EXERCISE_DESCRIPTION] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    CGRect textRect = CGRectMake(scrollRect.origin.x, scrollRect.origin.y, scrollRect.size.width, [self textViewHeightForAttributedText:descriptionText andWidth:scrollRect.size.width]);
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:textRect];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.attributedText = descriptionText;
    [contentScrollView addSubview:descriptionLabel];
    
    //Определяем куда втыкать картинки по высоте
    CGFloat imageTop = textRect.origin.y + textRect.size.height + 8.0f;
    
    //Втыкаем все картинки, которые есть
    for (UIImage *exerciseImage in self.exercisePictureArray)
    {
        CGRect imageRect = CGRectMake(scrollRect.origin.x, imageTop, scrollRect.size.width, exerciseImage.size.height * (scrollRect.size.width / exerciseImage.size.width));
        UIImageView *exerciseImageView = [[UIImageView alloc] initWithFrame:imageRect];
        exerciseImageView.image = exerciseImage;
        [contentScrollView addSubview:exerciseImageView];
        
        imageTop += imageRect.size.height + 8.0f;
        contentScrollView.contentSize = CGSizeMake(scrollRect.size.width, imageRect.origin.y + imageRect.size.height);
    }
    
    //exerciseDetailsTextView.textContainer.exclusionPaths = exclusionPaths;
    
    [self.view addSubview:contentScrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
