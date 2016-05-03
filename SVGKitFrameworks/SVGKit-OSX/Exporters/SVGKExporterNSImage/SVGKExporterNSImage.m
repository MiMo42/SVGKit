
#import "SVGKImage+CGContext.h" // needed for Context calls

#if (!TARGET_OS_IPHONE)

#import "SVGKExporterNSImage.h"
#import "SVGKit-OSX.Globals.h"

@implementation SVGKExporterNSImage

+(NSImage*) exportAsNSImage:(SVGKImage *)image
{
	return [self exportAsNSImage:image antiAliased:TRUE curveFlatnessFactor:1.0 interpolationQuality:kCGInterpolationDefault];
}

+(NSImage*) exportAsNSImage:(SVGKImage*) image antiAliased:(BOOL) shouldAntialias curveFlatnessFactor:(CGFloat) multiplyFlatness interpolationQuality:(CGInterpolationQuality) interpolationQuality
{
	if( [image hasSize] )
	{
		SVGKitLogVerbose(@"[%@] DEBUG: Generating a NSImage using the current root-object's viewport (may have been overridden by user code): {0,0,%2.3f,%2.3f}", [self class], image.size.width, image.size.height);

        NSImage * resultingImage = [[NSImage alloc] initWithSize:image.size];
        [resultingImage lockFocus];
    
        CGContextRef currentContent = [NSGraphicsContext currentContext].graphicsPort;
        
        [image renderToContext:currentContent antiAliased:shouldAntialias curveFlatnessFactor:multiplyFlatness interpolationQuality:interpolationQuality flipYaxis:NO];
        
        [resultingImage unlockFocus];
        
		return resultingImage;
	}
	else
	{
		NSAssert(FALSE, @"You asked to export an SVG to bitmap, but the SVG file has infinite size. Either fix the SVG file, or set an explicit size you want it to be exported at (by calling .size = something on this SVGKImage instance");
		
		return nil;
	}
}

@end

#endif