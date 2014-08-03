//
//  YMCell.m
//  NewsReader
//
//  Created by Юлия on 01.08.14.
//  Copyright (c) 2014 YuliaMishina. All rights reserved.
//

#import "YMCell.h"

@implementation YMCell

-(void)setArticle:(YMArticle *)article
{
    _article = article;
    
    //Вызываем метод, который обновит содержимое ячейки
    [self upDateCellWithArticle];
}

-(YMArticle*)article
{
    return _article;
}

-(void)upDateCellWithArticle
{
    //переписываем надписи на ячейке
    self.textLabel.text = self.article.name;
}

@end
