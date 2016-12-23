//
//  MainSplitViewController.m
//  Demo-OSX
//
//  Created by Michael Monscheuer on 17/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

#import "MainSplitViewController.h"

#import "ImageCollectionListViewController.h"
#import "ImageListViewController.h"
#import "ImageViewersSplitViewController.h"

#import "ImageCollection.h"
#import "ImageFile.h"

@interface MainSplitViewController ()

@property (weak) IBOutlet NSSplitViewItem *imageCollectionListSplitViewItem;
@property (weak) IBOutlet NSSplitViewItem *imageListSplitViewItem;
@property (weak) IBOutlet NSSplitViewItem *imageViewersContainerSplitViewItem;

@property (weak) IBOutlet NSSplitViewItem *svgInfoSplitViewItem;

@end

@implementation MainSplitViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self _setupImageCollectionListViewController];
    [self _setupImageListViewController];
}

#pragma mark - Actions

- (IBAction)toogleSVGInfo:(id)sender
{
    [_svgInfoSplitViewItem setCollapsed:![_svgInfoSplitViewItem isCollapsed]];
}

- (IBAction)selectSVGKImageView:(id)sender
{
    ImageViewersSplitViewController *splitViewController = (ImageViewersSplitViewController *)_imageViewersContainerSplitViewItem.viewController;
    
    if (splitViewController == nil)
        return;
    
    splitViewController.mainViewerType = [sender selectedSegment];
}

#pragma mark - Private Methods

- (void)_setupImageCollectionListViewController
{
    ImageCollectionListViewController *collectionController = (ImageCollectionListViewController *)[_imageCollectionListSplitViewItem viewController];
    if (collectionController == nil)
        return;

    collectionController.collectionSelectionHandler =
        ^(NSArray <ImageCollection *> *imageCollections){
        
        ImageListViewController *listViewController = (ImageListViewController *)[_imageListSplitViewItem viewController];
        if (listViewController != nil) {
            listViewController.imageCollections = imageCollections;
        }
    };
    
    /*
        Initialize the `imageCollections` to start with collections referencing
        - Pictures directory
    */
    NSURL *pircturesDirectoryURL = [[NSFileManager defaultManager] URLsForDirectory:NSPicturesDirectory inDomains:NSUserDomainMask].firstObject;
    if (pircturesDirectoryURL != nil) {
        ImageCollection *picturesCollection = [[ImageCollection alloc] initWithRootURL:pircturesDirectoryURL];
        picturesCollection.tableViewIcon = [NSImage imageNamed:NSImageNameFolder];
    
        collectionController.imageCollections = @[picturesCollection];
        }
}

- (void)_setupImageListViewController
{
    ImageListViewController *imageListViewController = (ImageListViewController *)[_imageListSplitViewItem viewController];
    if (imageListViewController == nil)
        return;
    
        /*
            When the selected image changes, update our image viewer controller
            to visualize that image.
        */
    imageListViewController.imageSelectionHandler =
        ^(ImageFile *imageFile) {
        
            ImageViewersSplitViewController *wiewerContainerViewController = (ImageViewersSplitViewController *)[_imageViewersContainerSplitViewItem viewController];
            if (wiewerContainerViewController != nil) {
                [wiewerContainerViewController setImageFile:imageFile];
            }
        };
}

@end
