//
//  TBImageService.m
//  FTShareView
//
//  Created by liu zhibin on 13-3-5.
//
//

#import "UIImage+IDPExtension.h"

static inline CGSize swapWidthAndHeight(CGSize size) {
    CGFloat swap = size.width;
    size.width  = size.height;
    size.height = swap;
    return size;
}

static inline CGFloat degreesToRadians(CGFloat degrees) {
    return M_PI * (degrees / 180.0);
}

static int temporaryImageAngle;
static inline CGFloat toRadians (CGFloat degrees) { return degrees * M_PI/180.0f; }

//images on iPhone should be no bigger than 1024, making images bigger than 1024 may cause crashes caused by not enough memory
#define maximumResultImageSize 1024
//indicates how many lines we check, when put 40 in here, 1 line is checked, 40th line, 80th line and so on
//the bigger the number the less concrete the result but faster detection
#define lineCheckingStep 40


@implementation UIImage (IDPExtension)


- (UIImage *)rotate:(UIImageOrientation)orient{
    CGRect bnds = CGRectZero;
    UIImage *copy = nil;
    CGContextRef ctxt = nil;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;
	
    bnds.size = self.size;
    rect.size = self.size;
	
    switch (orient) {
        case UIImageOrientationUp:
			return self;
			
        case UIImageOrientationUpMirrored:
			tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			break;
			
        case UIImageOrientationDown:
			tran = CGAffineTransformMakeTranslation(rect.size.width,
													rect.size.height);
			tran = CGAffineTransformRotate(tran, degreesToRadians(180.0));
			break;
			
        case UIImageOrientationDownMirrored:
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
			tran = CGAffineTransformScale(tran, 1.0, -1.0);
			break;
			
        case UIImageOrientationLeft:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
			tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
			break;
			
        case UIImageOrientationLeftMirrored:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeTranslation(rect.size.height, rect.size.width);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
			break;
			
        case UIImageOrientationRight:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
			tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
			break;
			
        case UIImageOrientationRightMirrored:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeScale(-1.0, 1.0);
			tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
			break;
			
        default:
			// orientation value supplied is invalid
			assert(false);
			return nil;
    }
	
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
	
    switch (orient) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
			CGContextScaleCTM(ctxt, -1.0, 1.0);
			CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
			break;
			
        default:
			CGContextScaleCTM(ctxt, 1.0, -1.0);
			CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
			break;
    }
	
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(ctxt, rect, self.CGImage);
	
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return copy;
}

- (UIImage *)rotateAndScaleFromCameraWithMaxSize:(CGFloat)maxSize{
    UIImage *imag = self;
    imag = [imag rotate:imag.imageOrientation];
    imag = [imag scaleWithMaxSize:maxSize];
    return imag;
}


- (UIImage *)scaleWithMaxSize:(CGFloat)maxSize{
    return [self scaleWithMaxSize:maxSize quality:kCGInterpolationHigh];
}


- (UIImage*)scaleWithMaxSize:(CGFloat)maxSize
quality:(CGInterpolationQuality)quality
{
    CGRect        bnds = CGRectZero;
    UIImage*      copy = nil;
    CGContextRef  ctxt = nil;
    CGRect        orig = CGRectZero;
    CGFloat       rtio = 0.0;
    CGFloat       scal = 1.0;
	
    bnds.size = self.size;
    orig.size = self.size;
    rtio = orig.size.width / orig.size.height;
	
    if ((orig.size.width <= maxSize) && (orig.size.height <= maxSize))
    {
        return self;
    }
	
    if (rtio > 1.0)
    {
        bnds.size.width  = maxSize;
        bnds.size.height = maxSize / rtio;
    }
    else
    {
        bnds.size.width  = maxSize * rtio;
        bnds.size.height = maxSize;
    }
	
    //UIGraphicsBeginImageContext(bnds.size);
    UIGraphicsBeginImageContextWithOptions(bnds.size, NO, 0);
    ctxt = UIGraphicsGetCurrentContext();
	
    scal = bnds.size.width / orig.size.width;
    CGContextSetInterpolationQuality(ctxt, quality);
    CGContextScaleCTM(ctxt, scal, -scal);
    CGContextTranslateCTM(ctxt, 0.0, -orig.size.height);
    CGContextDrawImage(ctxt, orig, self.CGImage);
	
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return copy;
}

- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


#pragma mark -
#pragma mark Rotation
+ (unsigned char) avarageColorOfThe8bppImageBorder:(UIImage *) image {
	NSAssert(image, @"can't find average color of nil image");
	NSInteger bpp = CGImageGetBitsPerPixel(image.CGImage);
	if(bpp != 8){
//		NSLog(@"WARNING: average color of the image border can't be calculated for images having more than 8bpp(yours is %dbpp). Converting to grayscale first.", bpp);
		image = [UIImage convertTo8bppGrayscaleFromImage:image];
	}
	
	CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
	unsigned char *rawData = (unsigned char *) CFDataGetBytePtr(data);
	NSInteger height = image.size.height;
	NSInteger width = image.size.width;
	NSInteger bytesPerRow = CGImageGetBytesPerRow(image.CGImage);
	
	NSInteger avarageColor = 0;
	NSInteger samplesTakenInHorizontal = width  >> 1;
	NSInteger samplesTakenInVertical = height  >> 1;
	
	NSInteger w, h; //random
	unsigned char c;
	for(NSInteger i = 0; i < samplesTakenInHorizontal; i+=2){
		//top line border
		h = 0;
		w = arc4random() % width;
		c = *(rawData + bytesPerRow*h + w);
		avarageColor += c;
		//bottom line
		h = height - 1;
		w = arc4random() % width;
		c = *(rawData + bytesPerRow*h + w);
		avarageColor += c;
	}
	for(NSInteger i = 0; i < samplesTakenInVertical; i += 2){
		//left line
		w = 0;
		h = arc4random() % height;
		c = *(rawData + bytesPerRow*h + w);
		avarageColor += c;
		//right line
		w = width - 1;
		h = arc4random() % height;
		c = *(rawData + bytesPerRow*h + w);
		avarageColor += c;
	}
	avarageColor = avarageColor / (samplesTakenInVertical+samplesTakenInHorizontal);
	if(data != NULL){
		CFRelease(data);
	}
	return avarageColor;
}

//if degrees < 0 than rotation is clockWise, otherwise CounterClockWise
+ (CGPoint) rotatePoint:(CGPoint)point byDegrees:(CGFloat) degrees aroundOriginPoint:(CGPoint) origin {
	CGPoint rotated = CGPointMake(0.0f, 0.0f);
	CGFloat radians = toRadians(degrees);
	rotated.x = cos(radians) * (point.x-origin.x) - sin(radians) * (point.y-origin.y) + origin.x;
	rotated.y = sin(radians) * (point.x-origin.x) + cos(radians) * (point.y-origin.y) + origin.y;
	return rotated;
}


+ (CGPoint) getPointAtIndex:(NSUInteger) index ofRect:(CGRect) rect {
	NSAssert1(index >= 0 && index < 4, @"Rectangle has 4 corners, index should be between [0,3], u passed %lu", (unsigned long)index);
	CGPoint point = rect.origin;
	if(index == 1){
		point.x += CGRectGetWidth(rect);
	} else if(index == 2){
		point.y += CGRectGetHeight(rect);
	} else if(index == 3){
		point.y += CGRectGetHeight(rect);
		point.x += CGRectGetWidth(rect);
	}
	
	return point;
}

+ (CGSize) imageSizeForRect:(CGRect) rect rotatedByDegreees:(CGFloat) degrees {
	CGPoint rotationOrigin = CGPointMake(0.0f, 0.0f);
	CGFloat maxX = 0, minX = INT_MAX, maxY = 0, minY = INT_MAX;
	
	for(NSInteger i = 0; i < 4; ++i){
		CGPoint toRotate = [UIImage getPointAtIndex:i ofRect:rect];
		CGPoint rotated = [UIImage rotatePoint:toRotate byDegrees:degrees aroundOriginPoint:rotationOrigin];
		minX = MIN(minX, rotated.x);
		minY = MIN(minY, rotated.y);
		maxX = MAX(maxX, rotated.x);
		maxY = MAX(maxY, rotated.y);
	}
	CGSize newSize = CGSizeMake(maxX - minX, maxY - minY);
	return newSize;
}

//clockwise when degrees < 0
- (UIImage *) rotateImage:(CGFloat) degrees {
	CGSize newImageSize = [UIImage imageSizeForRect:CGRectMake(0.0f, 0.0f, self.size.width, self.size.height) rotatedByDegreees:degrees];
	//if the new ImageSize will be bigger than 1024 then we need to scale the image
	CGFloat maximum = MAX(newImageSize.width, newImageSize.height);
	CGFloat scaleFactor = 1.0f;
	if(maximum > maximumResultImageSize){
		scaleFactor = maximumResultImageSize/maximum;
	}
	
	UIGraphicsBeginImageContext(CGSizeMake(newImageSize.width*scaleFactor, newImageSize.height*scaleFactor));
    CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	CGRect drawingRect = CGRectMake(0.0f, 0.0f, newImageSize.width*scaleFactor, newImageSize.height*scaleFactor);
	
	unsigned char midColor = [UIImage avarageColorOfThe8bppImageBorder:self];
	
	[[UIColor colorWithRed:midColor/255.0 green:midColor/255.0 blue:midColor/255.0 alpha:1.0f] set];
	CGContextFillRect(context, CGRectInset(drawingRect, -2, -2));
	
	CGContextTranslateCTM(context, drawingRect.size.width/2, drawingRect.size.height/2);
	CGContextRotateCTM(context, toRadians(degrees));
	
	[self drawInRect:CGRectMake((-self.size.width*scaleFactor)/2, (-self.size.height*scaleFactor)/2, self.size.width*scaleFactor, self.size.height*scaleFactor)];
	UIGraphicsPopContext();
    UIImage *copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return copy;
}

- (UIImage *)rotateImageandRotateAngle:(UIImageOrientation)orientation {
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, toRadians(90));
    }
	else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, toRadians(-90));
    }
	else if (orientation == UIImageOrientationDown) {
        // NOTHING
    }
	else if (orientation == UIImageOrientationUp) {
		CGContextTranslateCTM(context, self.size.width, 0.0f);
        CGContextRotateCTM (context, toRadians(90));
    }
    [self drawAtPoint:CGPointMake(0, 0)];
	UIGraphicsPopContext();
    return UIGraphicsGetImageFromCurrentImageContext();
}

#pragma mark resize

- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}


- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality {
    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                         interpolationQuality:quality];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                                 round((resizedImage.size.height - thumbnailSize) / 2),
                                 thumbnailSize,
                                 thumbnailSize);
    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
    
    UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;
    
    return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
}

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    CGAffineTransform transform = CGAffineTransformIdentity;
    // In iOS 5 the image is already correctly rotated. See Eran Sandler's
    // addition here: http://eran.sandler.co.il/2011/11/07/uiimage-in-ios-5-orientation-and-resize/
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0 )
    {
        drawTransposed = NO;
    }
    else
    {
        switch ( self.imageOrientation )
        {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                drawTransposed = YES;
                break;
            default:
                drawTransposed = NO;
        }
        
        transform = [self transformForOrientation:newSize];
    }
    
    return [self resizedImage:newSize transform:transform drawTransposed:drawTransposed interpolationQuality:quality];
}


- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:[NSString stringWithFormat:@"Unsupported content mode: %d", (int)contentMode],nil];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self resizedImage:newSize interpolationQuality:quality];
}



- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    // Fix for a colorspace / transparency issue that affects some types of
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap =CGBitmapContextCreate( NULL,
                                               newRect.size.width,
                                               newRect.size.height,
                                               8,
                                               0,
                                               colorSpace,
                                               (CGBitmapInfo)kCGImageAlphaPremultipliedLast );
    CGColorSpaceRelease(colorSpace);
	
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}


- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}


// Returns a copy of the image with a transparent border of the given size added around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    CGRect newRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(self.CGImage),
                                                0,
                                                CGImageGetColorSpace(self.CGImage),
                                                CGImageGetBitmapInfo(self.CGImage));
    
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation, self.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    // Create a mask to make the border transparent, and combine it with the image
    CGImageRef maskImageRef = [self newBorderMask:borderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

// Returns true if the image has an alpha layer
- (BOOL)hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha {
    if ([self hasAlpha]) {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}


// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Build a context that's the same dimensions as the new size
    CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8, // 8-bit grayscale
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));
    
    // Get an image of the context
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    // Clean up
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    
    return maskImageRef;
}


// Creates a copy of this image with rounded corners
// If borderSize is non-zero, a transparent border of the given size will also be added
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    // Build a context that's the same dimensions as the new size
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 image.size.width,
                                                 image.size.height,
                                                 CGImageGetBitsPerComponent(image.CGImage),
                                                 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));
    
    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
    [self addRoundedRectToPath:CGRectMake(borderSize, borderSize, image.size.width - borderSize * 2, image.size.height - borderSize * 2)
                       context:context
                     ovalWidth:cornerSize
                    ovalHeight:cornerSize];
    CGContextClosePath(context);
    CGContextClip(context);
    
    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    // Create a UIImage from the CGImage
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}


#pragma mark -
#pragma mark Private helper methods

// Adds a rectangular path to the given context and rounds its corners by the given extents
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight {
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
    CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}



#pragma mark -
#pragma mark Conversion/detection
//converts each UIImage to UIImage with grayscale palette, 8 bits per pixel wide
+ (UIImage *)convertTo8bppGrayscaleFromImage:(UIImage *) uimage {
	return [UIImage convertTo8bppGrayscaleFromImage:uimage scaleToMaximumSize:-1];
}

//if maxSize
+ (UIImage *)convertTo8bppGrayscaleFromImage:(UIImage *) uimage scaleToMaximumSize:(NSInteger) maxSize {
	int iwidth = uimage.size.width;
	int iheight = uimage.size.height;
	int maxFromHeightAndWidth = MAX(iwidth, iheight);
	float scaleFactor = maxSize / (float)maxFromHeightAndWidth;
	if(maxSize == -1){
		scaleFactor = 1.0f;
		if(maxFromHeightAndWidth > maximumResultImageSize){
			scaleFactor = maximumResultImageSize / (float) maxFromHeightAndWidth;
		}
	}
	int newImageWidth = iwidth*scaleFactor;
	int newImageHeight = iheight*scaleFactor;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	uint8_t *pixels = (uint8_t *) malloc(newImageWidth * newImageHeight * sizeof(*pixels));
	
	CGContextRef context = CGBitmapContextCreate(pixels, newImageWidth, newImageHeight, 8, newImageWidth * sizeof(uint8_t), colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaNone);
	CGContextDrawImage(context, CGRectMake(0, 0, newImageWidth, newImageHeight), uimage.CGImage);
	
	CGImageRef image = CGBitmapContextCreateImage(context);
	
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
	
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
	
    // we're done with image now too
    CGImageRelease(image);
	
	size_t bitsPerPixel = CGImageGetBitsPerPixel(resultUIImage.CGImage);
	NSAssert(bitsPerPixel == 8, @"Converted image doesn't have 8 bits per pixel size!");
    return resultUIImage;
}

//gives number of black pixels in skewed line with angle == [array count], for values given by bres array
+ (NSInteger)getBlackPixelsInLine:(NSInteger) lineNumber forImage:(UIImage *) image withBresArray:(int *) array andTreshold:(unsigned char) blackTreshold negativeAngle:(BOOL)negative {
	CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
	NSInteger bytesPerLine = CGImageGetBytesPerRow(image.CGImage);
	unsigned char *rawData = (unsigned char *)CFDataGetBytePtr(data);
	
	NSInteger blacks = 0;
	NSInteger offsetInLine = 0;
	unsigned char *ptrToStartLine = (rawData + bytesPerLine*lineNumber);
	NSInteger linesSkewNumber = temporaryImageAngle;
	for(NSInteger i = 0; i < linesSkewNumber; ++i){ //lines
		NSInteger pixelsToTake = array[i];
		for(NSInteger j = 0; j < pixelsToTake && offsetInLine < CGImageGetWidth(image.CGImage); ++j, ++offsetInLine){
			NSInteger lineOffsetFromStartLine = bytesPerLine*i;
			if(negative){
				lineOffsetFromStartLine = bytesPerLine * (linesSkewNumber-1-i);
			}
			NSAssert(lineOffsetFromStartLine >= 0, @"line offset can't be negative!");
			unsigned char pixelValue = *(ptrToStartLine + lineOffsetFromStartLine + offsetInLine);
			if(pixelValue < blackTreshold){
				++blacks;
			}
		}
	}
	if(data != NULL){
		CFRelease(data);
	}
	return blacks;
}


+ (NSInteger)degrees:(CGFloat)degrees inPixelsForImage:(UIImage *) image {
	return image.size.width * tanf(toRadians(degrees));
}


-(BOOL)isGifImage {
  NSData *imageData = UIImagePNGRepresentation(self);
  if (!imageData)
    return NO;
	const char* buf = (const char*)[imageData bytes];
  if (buf && buf[0] == 0x47 && buf[1] == 0x49 && buf[2] == 0x46 && buf[3] == 0x38) {
		return YES;
	}
	return NO;
}
-(UIImage*)safeResizableImageWithCapInsets:(UIEdgeInsets)capInsets
{
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (osVersion < 6.0) {
        // for iOS < 6.0 fix crash
        return [self stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
    else
    {
         return  [self resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    }

}

//For SDK
+(UIImage*)imageNamedForSDK:(NSString *)name
{
    NSString* imgPath = [NSString stringWithFormat:@"%@%@%@",@"resBundle.bundle/",name,@".png"];
    return [UIImage imageNamed:imgPath];
}

+(UIImage*)imageNamedNoCache:(NSString *)name
{
    if (!name) {
        return nil;
    }
    NSString *finalName = [NSString stringWithFormat:@"%@@2x",name];
    //for SDK
#ifdef TBCSDK
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"resBundle.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (nil == bundle) {
        return nil;
    }
    //retina 寻找文件
    NSString *filePath = [bundle pathForResource:finalName ofType:@"png"];
    if (!filePath) {
        filePath = [bundle pathForResource:finalName ofType:@"jpg"];
    }
    //如果没有 那寻找正常文件
    if (!filePath) {
        filePath = [bundle pathForResource:name ofType:@"png"];
        if (!filePath) {
            filePath = [bundle pathForResource:name ofType:@"jpg"];
        }
    }
    return [UIImage imageWithContentsOfFile:filePath];
#else
    //retina 寻找文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:finalName ofType:@"png"];
    if (!filePath) {
        filePath = [[NSBundle mainBundle] pathForResource:finalName ofType:@"jpg"];
    }
    //如果没有 那寻找正常文件
    if (!filePath) {
        filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        if (!filePath) {
            filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
        }
    }
    return [UIImage imageWithContentsOfFile:filePath];
#endif

}

- (UIImage *)imageSnipWithRect:(CGRect)rect
{
    CGImageRef resultImageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *resultImage = [UIImage imageWithCGImage:resultImageRef];
    CGImageRelease(resultImageRef);
    
    return resultImage;
}


- (UIColor *)averageColor
{
    CGImageRef rawImageRef = [self CGImage];
    
    //转成CFData
	CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(rawImageRef));
    const UInt8 *rawPixelData = CFDataGetBytePtr(data);
    
    //获取图片属性
    NSUInteger imageHeight = CGImageGetHeight(rawImageRef);
    NSUInteger imageWidth  = CGImageGetWidth(rawImageRef);
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(rawImageRef);
	NSUInteger stride = CGImageGetBitsPerPixel(rawImageRef) / 8;
    
    unsigned int red   = 0;
    unsigned int green = 0;
    unsigned int blue  = 0;
    
    //过滤
    if (stride < 3) {
        CFRelease(data);
        return nil;
    }
    
    //求和
	for (int row = 0; row < imageHeight; row++) {
		const UInt8 *rowPtr = rawPixelData + bytesPerRow * row;
		for (int column = 0; column < imageWidth; column++) {
            red    += rowPtr[0];
            green  += rowPtr[1];
            blue   += rowPtr[2];
			rowPtr += stride;
            
        }
    }
	CFRelease(data);
    
    //平均值
	CGFloat f = 1.0f / (255.0f * imageWidth * imageHeight);
	return [UIColor colorWithRed:f * red  green:f * green blue:f * blue alpha:1];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius iterationsCount:(NSInteger)iterationsCount tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // check pre-conditions
    if (self.size.width < 1 || self.size.height < 1) {
        return nil;
    }
    if (!self.CGImage) {
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        BOOL resultImageAtInputBuffer = YES;
        if (hasBlur) {
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            for (int i = 0; i+1 < iterationsCount; i+=2) {
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            }
            if (iterationsCount % 2) {
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
                resultImageAtInputBuffer = NO;
            }
        }
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur ^ resultImageAtInputBuffer) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!resultImageAtInputBuffer)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (resultImageAtInputBuffer)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // set up output context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // draw base image
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // draw effect image
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // add in color tint
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // output image is ready
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
