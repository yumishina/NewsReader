//
//  YMArticleViewController.h
//  NewsReader
//
//  Created by Юлия on 02.08.14.
//  Copyright (c) 2014 YuliaMishina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMArticle.h"
@interface YMArticleViewController : UIViewController
@property YMArticle* article; // В этом объекте хранится статья, полученная с предыдущего контроллера
@property (strong, nonatomic) IBOutlet UIWebView *articleWebView;

@end
