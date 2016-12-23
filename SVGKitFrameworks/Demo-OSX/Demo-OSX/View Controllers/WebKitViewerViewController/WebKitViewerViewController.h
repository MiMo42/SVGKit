//
//  WebKitViewerViewController.h
//  Demo-OSX
//
//  Created by Michael Monscheuer on 23/12/2016.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

@import Cocoa;
@import WebKit;

#import "ImageFile.h"

@interface WebKitViewerViewController : NSViewController

@property (strong) ImageFile *imageFile;

@property (readonly, weak) WebView *webView;

@end
