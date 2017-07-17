//
//  StoryPageViewController.m
//  AV Storybook
//
//  Created by Errol Cheong on 2017-07-14.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "StoryPageViewController.h"
#import "StoryPartViewController.h"

@interface StoryPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *numberOfPages;
@property (assign, nonatomic) NSUInteger pagesDeleted;
@property (assign, nonatomic) NSUInteger currentPage;

@end

@implementation StoryPageViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = 0;
    self.pagesDeleted = 0;
    self.numberOfPages = [@[] mutableCopy];
    StoryPartViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"storyPart"];
    view.pageIndex = self.numberOfPages.count;
//    StoryPartViewController *view1 = [self.storyboard instantiateViewControllerWithIdentifier:@"storyPart"];
//    view1.pageIndex = 1;
//    StoryPartViewController *view2 = [self.storyboard instantiateViewControllerWithIdentifier:@"storyPart"];
//    view2.pageIndex = 2;
//    StoryPartViewController *view3 = [self.storyboard instantiateViewControllerWithIdentifier:@"storyPart"];
//    view3.pageIndex = 3;
//    StoryPartViewController *view4 = [self.storyboard instantiateViewControllerWithIdentifier:@"storyPart"];
//    view4.pageIndex = 4;
    
    [self.numberOfPages addObject:view];
    
    self.dataSource = self;
    self.delegate = self;
    
    self.navigationItem.title = [NSString stringWithFormat:@"Page #1"];
    [self setViewControllers:@[view] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - UIPageViewController Data Source Methods

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger currentIndex = [self.numberOfPages indexOfObject:viewController];
    NSInteger prevIndex = (currentIndex - 1) % self.numberOfPages.count;
    
    self.navigationItem.title = [NSString stringWithFormat:@"Page #%lu", prevIndex + 1];
    self.currentPage = prevIndex;
    return self.numberOfPages[prevIndex];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger currentIndex = [self.numberOfPages indexOfObject:viewController];
    
    if (currentIndex + 1 >= self.numberOfPages.count)
    {
        StoryPartViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"storyPart"];
        view.pageIndex = self.numberOfPages.count + self.pagesDeleted;
        [self.numberOfPages addObject:view];
    }
    
    NSInteger nextIndex = currentIndex + 1;
    self.navigationItem.title = [NSString stringWithFormat:@"Page #%lu", nextIndex + 1];
    self.currentPage = nextIndex;
    return self.numberOfPages[nextIndex];
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.numberOfPages.count;
}

#pragma mark - UINavigation Bar Button Methods

- (IBAction)deleteButton:(UIBarButtonItem *)sender {
    [self.numberOfPages removeObjectAtIndex:self.currentPage];
    if (self.currentPage == 0)
    {
        if (self.numberOfPages.count == 0)
        {
            StoryPartViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"storyPart"];
            view.pageIndex = self.numberOfPages.count + self.pagesDeleted;
            [self.numberOfPages addObject:view];
            [self setViewControllers:@[self.numberOfPages[self.currentPage]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        } else {
            [self setViewControllers:@[self.numberOfPages[self.currentPage]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
        self.navigationItem.title = [NSString stringWithFormat:@"Page #%lu", self.currentPage + 1];
    }else {
        [self setViewControllers:@[self.numberOfPages[self.currentPage-1]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        self.navigationItem.title = [NSString stringWithFormat:@"Page #%lu", self.currentPage];
    }
        
    self.pagesDeleted++;
}


@end
