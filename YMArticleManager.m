//
//  YMArticleManager.m
//  NewsReader
//
//  Created by Юлия on 01.08.14.
//  Copyright (c) 2014 YuliaMishina. All rights reserved.
//

#import "YMArticleManager.h"

@implementation YMArticleManager
{
    NSMutableArray* _articlesArray;
    NSXMLParser* _xmlParser;
    YMArticle* _activeArticle;
    NSMutableString* _activeContent; //контент между двумя тегами, которые получили

    BOOL is_Item; // YES - находимся внутри тэга item
    BOOL is_Title; // YES - находимся внутри тэга title
    BOOL is_Link; // YES - находимся внутри тэга link
}


//Возвращаем текущий экземпляр ArticleManager
+(YMArticleManager*) sharedManager
{
    static YMArticleManager* _sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //все внутри этого блока будет выполнено приложением только один раз за время своей работы
        _sharedManager = [YMArticleManager new];
    });
    return _sharedManager;
}

//Возвращает массив из статей
-(NSArray*)articles
{
    //Всегда возвращаем текущий массив статей
    return _articlesArray;
}

//Загружает статьи, вызывает переданный ему блок после того как статьи будут загружены
-(void)loadArticleFromRSS:(void (^) (BOOL isSucceed))completionBlock
{
    //Формируем URL адрес откуда будет осуществляться загрузка
    NSURL *rssURL = [NSURL URLWithString:@"http://static.feed.rbc.ru/rbc/internal/rss.rbc.ru/autonews.ru/testdrives.rss"];
    
    //Создаем объект-запрос для того чтобы начат загрузку с сервера
    NSURLRequest* request = [NSURLRequest requestWithURL:rssURL];
    
    //Отправляем запрос асинхронно
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue new]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //Этот блок будет выполнен когда загрузка завершится
        
        //Выполняем блок с кодом в основном потоке чтобы можно было без глюков обновлять UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            //А этот блок будет выполняться в основном потоке
            //проверяем нету ли ошибок при загрузке
            if (connectionError){
                //Если ошибки есть вызываем наш блок и передаем туда NO то есть загрузка не удалась
                if(completionBlock)
                    completionBlock(NO);
            }else{
                //Создаем XML парсер
                _xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:rssURL];
                
                //Назначаем объект-делегат, который будет получать уведомления от парсера о том, что ему встретилось в процессе разбора
                _xmlParser.delegate = self;
                
                //Обнуляем массив статей
                _articlesArray = [NSMutableArray new];
                _activeContent = [[NSMutableString alloc] init];
                is_Item = NO;
                is_Title = NO;
                is_Link = NO;
                
                //Заупскаем процесс разбора XML
                [_xmlParser parse];
                //вызываем переданный нам блок с параметром YES - загрузка завершилась
                if(completionBlock)
                    completionBlock(YES);
            }
        }];
    }];
}

#pragma mark - Делегат парсера

//Вызывается парсером когда он встречает открывающий тэг
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([[elementName lowercaseString] isEqualToString:@"item"]){
        _activeArticle = [YMArticle new];
        is_Item = YES;
    }
    if([[elementName lowercaseString] isEqualToString:@"title"]){
        is_Title = YES;
    }
    if ([[elementName lowercaseString] isEqualToString:@"link"]) {
        is_Link = YES;
    }
}

//Вызывается парсером тогда, когда он встречает текст между открывающим и закрывающим тэгами
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (is_Item &&  (is_Title || is_Link)) {
        [_activeContent appendString: string];
    }
}

// Вызвыается парсером тогда, когда он встречает закрывающий тэг </tag>
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (is_Item) {
        if(is_Title){
            _activeArticle.name = _activeContent;
            _activeContent = [[NSMutableString alloc] init];
            is_Title = NO;
        }
        
        if (is_Link) {
            _activeArticle.link = _activeContent;
            _activeContent = [[NSMutableString alloc] init];
            is_Link = NO;
        }
        
        if([[elementName lowercaseString] isEqualToString:@"item"]){
            //заполнение объекта закончено
            // добавляем получившуюся статью в массив
            [_articlesArray addObject:_activeArticle];
            is_Item = NO;
        }
    }
}


@end







