//
//  YMArticleManager.h
//  NewsReader
//
//  Created by Юлия on 01.08.14.
//  Copyright (c) 2014 YuliaMishina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMArticle.h"

@interface YMArticleManager : NSObject <NSXMLParserDelegate>


//Возвращаем текущий экземпляр ArticleManager
+(YMArticleManager*) sharedManager;

//Возвращает массив из статей
-(NSArray*)articles;

//Загружает статьи
-(void)loadArticleFromRSS:(void (^) (BOOL isSucceed))completionBlock;


@end
