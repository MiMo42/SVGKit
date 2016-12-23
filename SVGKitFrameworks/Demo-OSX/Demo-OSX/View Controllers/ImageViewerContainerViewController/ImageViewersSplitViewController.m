//
//  ImageViewersSplitViewController.m
//  Demo-OSX
//
//  Created by Michael Monscheuer on 20/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

@import SVGKit;

#import "ImageViewersSplitViewController.h"

@interface ImageViewersSplitViewController ()

@property (weak) IBOutlet NSSplitViewItem *mainImageViewerSplitViewItem;
@property (weak) IBOutlet NSSplitViewItem *safariViewerSplitViewItem;

@end

@implementation ImageViewersSplitViewController
{
    ImageFile *_imageFile;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.mainViewerType = MainSVGViewerTypeFast;
}

#pragma mark - Properties

- (ImageFile *)imageFile
{
    @synchronized (self) {
        return _imageFile;
    }
}

- (void)setImageFile:(ImageFile *)imageFile
{
    @synchronized (self) {
        _imageFile = imageFile;
        
        [self _updateViewers];
    }
}

- (MainSVGViewerType)mainViewerType
{
    ImageViewerViewController *viewController = (ImageViewerViewController *)[_mainImageViewerSplitViewItem viewController];
    
    return [viewController mainViewerType];
}

- (void)setMainViewerType:(MainSVGViewerType)mainViewerType
{
    ImageViewerViewController *viewController = (ImageViewerViewController *)[_mainImageViewerSplitViewItem viewController];
    
    [viewController setMainViewerType:mainViewerType];
}

#pragma mark - Private Methods

- (void)_updateViewers
{
    ImageViewerViewController *viewController = (ImageViewerViewController *)[_mainImageViewerSplitViewItem viewController];
    if (![viewController isKindOfClass:[ImageViewerViewController class]])
        return;

    [viewController setImageFile:self.imageFile];
}

@end
