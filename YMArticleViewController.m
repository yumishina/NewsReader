//
//  YMArticleViewController.m
//  NewsReader
//
//  Created by Юлия on 02.08.14.
//  Copyright (c) 2014 YuliaMishina. All rights reserved.
//

#import "YMArticleViewController.h"

@interface YMArticleViewController ()

@end

@implementation YMArticleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.article.name;
    [self.articleWebView setScalesPageToFit:YES];
    [self.articleWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.article.link]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
