//
//  ImageViewerViewController.h
//  Demo-OSX
//
//  Created by Michael Monscheuer on 31/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

@import Cocoa;

#import "ImageFile.h"

extern NSString * const SVGImageDidChangeNotification;

typedef NS_ENUM(NSUInteger, MainSVGViewerType) {
    MainSVGViewerTypeFast,
    MainSVGViewerTypeLayered
};

@interface ImageViewerViewController : NSViewController

@property (strong) ImageFile *imageFile;

@property (readonly) NSView *documentView;

@property (assign) MainSVGViewerType mainViewerType;

@end
