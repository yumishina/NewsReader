//
//  YMArticleListTableViewController.m
//  NewsReader
//
//  Created by Юлия on 01.08.14.
//  Copyright (c) 2014 YuliaMishina. All rights reserved.
//

#import "YMArticleListTableViewController.h"

@interface YMArticleListTableViewController ()

@end

@implementation YMArticleListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Меняем внешний вид элеметов интерфейса
    //Меняем заголовок верхней панели
    self.navigationItem.title = @"Загружаются данные";
    //Запрещаем касания в TableView
    self.tableView.userInteractionEnabled = NO;
    //Делаем TableView прозрачным на 50%
    self.tableView.alpha = 0.5;
    
    //Вызываем метод модели, для того чтобы произвести загрузку
    //Этот блок выполняется через 1 секунду
    [[YMArticleManager sharedManager] loadArticleFromRSS: ^(BOOL isSucceed){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //меняем внешний вид элеметов интерфейса
            //меняем заголовок верхней панели
            self.navigationItem.title = @"Тест-драйвы";
            //разрешаем касания в TableView
            self.tableView.userInteractionEnabled = YES;
            //Убираем прозорачность TableView
            self.tableView.alpha = 1.0;
        
            //Перезагружаем таблицу
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                            withRowAnimation: UITableViewRowAnimationLeft];
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Возвращаем количество элементов в массиве статей
    return [[YMArticleManager sharedManager] articles].count; 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    //Передаем статью из массива в ячейку
    cell.article = [[[YMArticleManager sharedManager] articles] objectAtIndex:[indexPath row]];
    return cell;
}

#pragma mark - Navigation

// Вызывается при срабатывании связи в Storyboard ( сразу перед тем как происходит переход)

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Проверяем какая связь срабатывает
    if ([segue.identifier isEqualToString:@"go"]) {
        
        //Получаем конечный View Controller
        YMArticleViewController* avc = segue.destinationViewController;
        
        // Получаем индекс выделенного этемента в Table View
        NSInteger index = self.tableView.indexPathForSelectedRow.row;
        
        //Передаем в следующий View Controller  объект - статья
       avc.article = [[YMArticleManager sharedManager] articles][index];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
