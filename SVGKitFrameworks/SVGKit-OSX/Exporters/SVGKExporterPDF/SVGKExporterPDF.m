//
//  SVGKExpoerterPDF.m
//  SVGKit-OSX
//
//  Created by Michael Monscheuer on 02/05/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

#import "SVGKExporterPDF.h"

#import "SVGKImage.h"
#import "SVGKImage+CGContext.h" // needed for Context calls

@implementation SVGKExporterPDF

+ (NSData *) exportAsPDFData:(SVGKImage *)image error:(NSError **)outError
{
    if (![image hasSize])
    {
        NSAssert(FALSE, @"You asked to export an SVG to PDF data, but the SVG file has infinite size. Either fix the SVG file, or set an explicit size you want it to be exported at (by calling .size = something on this SVGKImage instance");
		
        return nil;
    }
    
    return [self exportAsPDFData:image withRect:
        (NSRect) {
            .origin=NSZeroPoint,
            .size=image.size
        }
        error:outError];
}

+ (NSData *)exportAsPDFData:(SVGKImage *)image withRect:(NSRect)rect
                      error:(NSError **)error
{
    // store the old context
    NSGraphicsContext * oldGraphicsContext = [NSGraphicsContext currentContext];
    
    // create the data for the PDF
    NSMutableData * data = [[NSMutableData alloc] init];
    
    // assign the data to the consumer
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)data);
    const CGRect box = CGRectMake( rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );

    // create the context
    CGContextRef context = CGPDFContextCreate( dataConsumer, &box, NULL );
    NSGraphicsContext * newContext = [NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:NO];
    
    CGContextSaveGState(context);

    // set it as the current
    [NSGraphicsContext setCurrentContext:newContext];
    CGContextBeginPage( context, &box );

    // the context is currently upside down, doh! flip it...
    CGContextScaleCTM( context, 1, -1 );
    CGContextTranslateCTM( context, 0, -box.size.height);
    
    [image renderInContext:context];
    
    CGContextEndPage(context);
    
    //clean up
    CGPDFContextClose(context);
    CGContextRelease(context);
    CGDataConsumerRelease(dataConsumer);
    
    CGContextRestoreGState(context);
    
    // set the graphics context back to its original
    [NSGraphicsContext setCurrentContext:oldGraphicsContext];
    
    return data;
}

@end
