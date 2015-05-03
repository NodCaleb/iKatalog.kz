//
//  SupplementDetailsVC.m
//  Fitness Trainer
//
//  Created by Eugene Rozhkov on 04.04.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "SupplementDetailsVC.h"

@interface SupplementDetailsVC ()

@end

@implementation SupplementDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.currentSupplement.title;
    
    //Определяем размеры основного вида и плашек навигации вверху и внизу
    CGRect mainFrame = self.view.frame;
    CGFloat viewTop = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    CGFloat viewBottom = self.navigationController.navigationBar.frame.size.height;
    
    //Текст втыкаем на всю площадь основного вида
    CGRect textRect = CGRectMake(mainFrame.origin.x + 8.0f,mainFrame.origin.y + 8.0f, mainFrame.size.width - 16.0f, mainFrame.size.height - 16.0f - viewBottom);
    UITextView *supplementDetailsTextView = [[UITextView alloc] initWithFrame:textRect];
    supplementDetailsTextView.attributedText = [[NSAttributedString alloc] initWithString:self.currentSupplement.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    supplementDetailsTextView.editable = NO;
    
    //Картинки для добавок малеьнькие — поэтому втыкаем их прямо в текст
    UIImage *supplementImage = [UIImage imageNamed:self.currentSupplement.imageName];
    CGRect imageRect = CGRectMake(textRect.origin.x, textRect.origin.y, supplementImage.size.width, supplementImage.size.height);
    UIImageView *supplementImageView = [[UIImageView alloc] initWithFrame:imageRect];
    supplementImageView.image = supplementImage;
    
    //Добавляем область обтекания
    supplementDetailsTextView.textContainer.exclusionPaths = @[[UIBezierPath bezierPathWithRect:imageRect]];
    
    //Добавляем на основной вид текст, а туда в свою очередь — картинку (яйцо в утке, утка в зайце, заяц в шоке)
    [self.view addSubview:supplementDetailsTextView];
    [supplementDetailsTextView addSubview:supplementImageView];
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
