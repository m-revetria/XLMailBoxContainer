//
//  XLButtonBarSwipeContainerController.m
//  XLMailBoxContainer
//
//  Created by Martin Barreto on 9/19/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//
#import "XLSwipeButtonBarViewCell.h"
#import "XLButtonBarSwipeContainerController.h"

@interface XLButtonBarSwipeContainerController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) IBOutlet XLSwipeButtonBarView * swipeBar;

@end

@implementation XLButtonBarSwipeContainerController
{
    XLSwipeButtonBarViewCell * _sizeCell;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.swipeBar.superview){
        [self.view addSubview:self.swipeBar];
    }
    if (!self.swipeBar.delegate){
        self.swipeBar.delegate = self;
    }
    if (!self.swipeBar.dataSource){
        self.swipeBar.dataSource = self;
    }
    self.swipeBar.labelFont = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    self.swipeBar.leftRightMargin = 8;
    UICollectionViewFlowLayout * flowLayout = (id)self.swipeBar.collectionViewLayout;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.swipeBar setShowsHorizontalScrollIndicator:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.swipeBar moveToIndex:self.currentIndex animated:NO swipeDirection:XLSwipeDirectionNone];

    
}


-(XLSwipeButtonBarView *)swipeBar
{
    if (_swipeBar) return _swipeBar;
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 35, 0, 35)];
    _swipeBar = [[XLSwipeButtonBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0f) collectionViewLayout:flowLayout];
    _swipeBar.backgroundColor = [UIColor orangeColor];
    _swipeBar.selectedBar.backgroundColor = [UIColor blackColor];
    _swipeBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return _swipeBar;
}

#pragma mark - XLSwipeContainerControllerDelegate

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController willShowViewController:(UIViewController *)controller withDirection:(XLSwipeDirection)direction fromViewController:(UIViewController *)previousViewController
{
    [self.swipeBar moveToIndex:[self.swipeViewControllers indexOfObject:controller] animated:YES swipeDirection:direction];
}

-(void)swipeContainerController:(XLSwipeContainerController *)swipeContainerController didShowViewController:(UIViewController *)controller withDirection:(XLSwipeDirection)direction fromViewController:(UIViewController *)previousViewController
{
}


#pragma merk - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel * label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.font = self.swipeBar.labelFont;
    UIViewController<XLSwipeContainerChildItem> * childController =   [self.swipeViewControllers objectAtIndex:indexPath.item];
    [label setText:[childController nameForSwipeContainer:self]];
    CGSize labelSize = [label intrinsicContentSize];
    
    return CGSizeMake(labelSize.width + (self.swipeBar.leftRightMargin * 2), collectionView.frame.size.height);
}

#pragma mark - UICollectionViewDelegate


//-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if([indexPath item] == ((NSIndexPath*)[[self.swipeBar indexPathsForVisibleItems] lastObject]).item){
//        //end of loading
//        //for example [activityIndicator stopAnimating];
//        [self.swipeBar moveToIndex:self.currentIndex animated:NO];
//        
//    }
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.swipeBar moveToIndex:indexPath.item animated:YES swipeDirection:XLSwipeDirectionNone];
    [self moveToViewControllerAtIndex:indexPath.item];
    
}


#pragma merk - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.swipeViewControllers.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell){
        cell = [[XLSwipeButtonBarViewCell alloc] initWithFrame:CGRectMake(0, 0, 50, self.swipeBar.frame.size.height)];
    }
    NSAssert([cell isKindOfClass:[XLSwipeButtonBarViewCell class]], @"UICollectionViewCell should be or extend XLSwipeButtonBarViewCell");
    XLSwipeButtonBarViewCell * swipeCell = (XLSwipeButtonBarViewCell *)cell;
    UIViewController<XLSwipeContainerChildItem> * childController =   [self.swipeViewControllers objectAtIndex:indexPath.item];
    
    [swipeCell.label setText:[childController nameForSwipeContainer:self]];
    
    return swipeCell;
}



@end
