//
//  YMCell.h
//  NewsReader
//
//  Created by Юлия on 01.08.14.
//  Copyright (c) 2014 YuliaMishina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMArticle.h"

@interface YMCell : UITableViewCell
{
    YMArticle* _article;
}

//Свойство будет хранить название статьи, которое будет отображать ячейка
@property YMArticle* article;

//Будет вызываться из кода ячейки при изменении свойства article, и  обновлять надписи на ней
//В наследниках можно будет переопределить этот метод чтобы изменить поведение ячейки
-(void)upDateCellWithArticle;

@end


