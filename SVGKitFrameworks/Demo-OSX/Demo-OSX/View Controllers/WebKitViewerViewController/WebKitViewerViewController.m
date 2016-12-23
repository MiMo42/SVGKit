//
//  WebKitViewerViewController.m
//  Demo-OSX
//
//  Created by Michael Monscheuer on 23/12/2016.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

#import "WebKitViewerViewController.h"

@interface WebKitViewerViewController ()

@property (weak) IBOutlet WebView *webView;

@end

@implementation WebKitViewerViewController
{
    ImageFile *_imageFile;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
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
        
        [self _updateDocument];
    }
}

- (void)_updateDocument
{
    WebView *webView = [self webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.imageFile.URL];
    
    [[webView mainFrame] loadRequest:request];
    
    // [webView loadFileURL:self.imageFile.URL allowingReadAccessToURL:self.imageFile.URL];
/*
    // get image by file path
    if (self.imageFile != nil) {
        self.svgImage = [SVGKImage imageWithContentsOfFile:_imageFile.URL.path];
    }

    // no image? -> use default image
    if (self.svgImage == nil)
        self.svgImage = [self _createDefaultImage];
    
    if ([self.documentView isKindOfClass:[SVGKLayeredImageView class]]) {

        SVGKLayeredImageView *svgImageView = (SVGKLayeredImageView *)self.documentView;
        
        NSSize frameSize = NSMakeSize(self.svgImage.CALayerTree.frame.size.width, self.svgImage.CALayerTree.frame.size.height);
        
        [svgImageView setFrameSize:frameSize];

        svgImageView.image = self.svgImage;
    
        [svgImageView setNeedsLayout:YES];
        
    } else if ([self.documentView isKindOfClass:[SVGKFastImageView class]]) {
        
        SVGKFastImageView *svgImageView = (SVGKFastImageView *)self.documentView;
        
        svgImageView.image = self.svgImage;
        
        [svgImageView setNeedsLayout:YES];
    }
*/
}


@end
