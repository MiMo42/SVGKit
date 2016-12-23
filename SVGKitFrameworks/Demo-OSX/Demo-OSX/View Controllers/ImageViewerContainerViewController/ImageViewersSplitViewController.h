//
//  ImageViewersSplitViewController.h
//  Demo-OSX
//
//  Created by Michael Monscheuer on 20/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

@import Cocoa;

#import "ImageFile.h"
#import "ImageViewerViewController.h"

@interface ImageViewersSplitViewController : NSSplitViewController

@property (strong) ImageFile *imageFile;

@property (assign) MainSVGViewerType mainViewerType;

@end
