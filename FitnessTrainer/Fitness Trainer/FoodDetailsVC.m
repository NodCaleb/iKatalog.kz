//
//  FoodDetailsVC.m
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 04.04.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "FoodDetailsVC.h"

@interface FoodDetailsVC ()

@end

@implementation FoodDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.currentFood.title;
    
    //Определяем размеры основного вида и плашек навигации вверху и внизу
    CGRect mainFrame = self.view.frame;
    CGFloat viewTop = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    CGFloat viewBottom = self.navigationController.navigationBar.frame.size.height;
    
    //Вписываем картинку по ширине в размер основного вида с отступами по 8 пунктов, по высоте — подгоняем пропорционально
    UIImage *foodImage = [UIImage imageNamed:self.currentFood.imageName];
    CGRect imageRect = CGRectMake(mainFrame.origin.x + 8.0f, viewTop + 8.0f, mainFrame.size.width - 16.0f, foodImage.size.height * ((mainFrame.size.width - 16.0f) / foodImage.size.width));
    UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:imageRect];
    foodImageView.image = foodImage;
    [self.view addSubview:foodImageView];
    
    //На оставшееся после картинки место втыкаем текст
    CGRect textRect = CGRectMake(8.0f,imageRect.origin.y + imageRect.size.height + 8.0f, mainFrame.size.width - 16.0f, mainFrame.size.height -  imageRect.size.height - viewTop - 16.0f - viewBottom);
    UITextView *foodDetailsTextView = [[UITextView alloc] initWithFrame:textRect];
    foodDetailsTextView.attributedText = [[NSAttributedString alloc] initWithString:self.currentFood.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    foodDetailsTextView.editable = NO;
    
    [self.view addSubview:foodDetailsTextView];
    
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

@end
