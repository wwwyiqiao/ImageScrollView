//
//  WDSNBannerView.m
//  WDSPublic_Common
//
//  Created by WangYiqiao on 2018/4/27.
//  Copyright © 2018年 smallsao. All rights reserved.
//

#import "WDSNBannerView.h"
#import "UIImageView+WDSNBanner.h"


@interface WDSNBannerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy) NSArray *images; // UIImage 或者 NSString

@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, strong) NSTimer *scrollTimer;

@end

@implementation WDSNBannerView

- (void)dealloc {
	[self stopAutoScroll];
}

#pragma mark - Getter & Setter

- (BOOL)hidesForSinglePage {
	return self.pageControl.hidesForSinglePage;
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
	self.pageControl.hidesForSinglePage = hidesForSinglePage;
}

#pragma mark - Init

- (instancetype)init {
	return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame]) {
		[self setupData];
		[self setupUI];
	}
	
	return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.scrollView.frame = self.bounds;
	
	CGPoint controlCenter = CGPointMake(self.center.x, self.bounds.size.height - 20);
	self.pageControl.center = controlCenter;
	
	[self updateContentOffset];
	[self updateImageViews];
}

- (void)updateContentOffset
{
	if(self.images.count >= 2 && self.enableLoop) {
		NSInteger count = self.images.count + 2 ;
		self.scrollView.contentSize = CGSizeMake(count * self.frame.size.width, 0);
		CGPoint offset = self.scrollView.contentOffset;
		offset.x = self.frame.size.width;
		self.scrollView.contentOffset = offset;
	} else {
		self.scrollView.contentSize = CGSizeMake(self.frame.size.width * self.images.count, 0);
		CGPoint offset = self.scrollView.contentOffset;
		offset.x = 0;
		self.scrollView.contentOffset = offset;
	}
}

- (void)updateImageViews
{
	NSInteger count = self.imageViews.count;
	
	for (int i = 0; i < count; i++) {
		UIImageView *imageView = self.imageViews[i];

		imageView.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
		
		if(self.enableLoop) {
			
			if (i <= 0) {
				[imageView wds_setImage:self.images.lastObject];
				imageView.tag = count - 1;
			}
			else if (i >= count - 1 ){
				[imageView wds_setImage:self.images.firstObject];
				imageView.tag = 0;
			}
			else {
				[imageView wds_setImage:self.images[i - 1]];
				imageView.tag = i - 1;
			}
		} else {
			[imageView wds_setImage:self.images[i]];
			imageView.tag = i;
		}
	}
	
}

#pragma mark - Setup

- (void)setupUI
{
	_scrollView = [[UIScrollView alloc] init];
	_scrollView.delegate = self;
	_scrollView.pagingEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
	_scrollView.bounces = NO;
	[self addSubview:_scrollView];
	
	_pageControl = [[UIPageControl alloc] init];
	_pageControl.defersCurrentPageDisplay = YES;
	_pageControl.hidesForSinglePage = YES;
	[self addSubview:_pageControl];
}

- (void)setupData
{
	_autoScrollInterval = 5.0;
	_autoScroll = YES;
	_enableLoop = YES;
	_imageContentMode = UIViewContentModeScaleToFill;
	_images = [NSArray array];
	_imageViews = [NSMutableArray array];
}

#pragma mark - Public

- (void)updateImages:(NSArray<UIImage *> *)images
{
	[self.imageViews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
	[self.imageViews removeAllObjects];
	self.images = images;
	self.pageControl.numberOfPages = self.images.count;
	
	NSInteger count = (self.images.count >= 2 && self.enableLoop) ? self.images.count + 2 : self.images.count;
	for(int i = 0; i < count; i++) {
		UIImageView *imageView = [[UIImageView alloc] init];
		imageView.contentMode = self.imageContentMode;
		imageView.userInteractionEnabled = YES;
		UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnImageView:)];
		[imageView addGestureRecognizer:tapGesture];
		[self.scrollView addSubview:imageView];
		[self.imageViews addObject:imageView];
	}
	
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

- (void)updateImageUrls:(NSArray<NSString *> *)imageUrls
{
	[self.imageViews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
	[self.imageViews removeAllObjects];
	self.images = imageUrls;
	self.pageControl.numberOfPages = self.images.count;
	
	NSInteger count = (self.images.count >= 2 && self.enableLoop) ? self.images.count + 2 : self.images.count;
	for(int i = 0; i < count; i++) {
		UIImageView *imageView = [[UIImageView alloc] init];
		imageView.contentMode = self.imageContentMode;
		imageView.userInteractionEnabled = YES;
		UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnImageView:)];
		[imageView addGestureRecognizer:tapGesture];
		[self.scrollView addSubview:imageView];
		[self.imageViews addObject:imageView];
	}
	
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

#pragma mark - Private

- (void)doScroll
{
	CGFloat width = self.frame.size.width;
	CGFloat offset = self.scrollView.contentOffset.x + width;
	
	if(offset > self.images.count * width) {
		offset = width;
	}
	
	[self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
	
	int page = abs((int)((offset - width) / width));
	self.pageControl.currentPage = page;
}

- (void)startAutoScroll
{
	if(self.scrollTimer != nil || self.images.count < 2 || !self.enableLoop) {
		return;
	}
	
	self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollInterval target:self selector:@selector(doScroll) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
}

- (void)stopAutoScroll
{
	if(self.scrollTimer) {
		[self.scrollTimer invalidate];
		self.scrollTimer = nil;
	}
}

#pragma mark - User Intertion

- (void)tappedOnImageView:(UITapGestureRecognizer *)tapGesture
{
	NSInteger index = tapGesture.view.tag;
	if(self.bannerBlock) {
		self.bannerBlock(index);
	}
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(bannerView:tappedAtIndex:)]) {
		[self.delegate bannerView:self tappedAtIndex:index];
	}
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat offset = self.scrollView.contentOffset.x;
	CGFloat frameWidth = self.frame.size.width;
	
	if (self.images.count >= 2 && self.enableLoop) {
		//scroll to the last imageView
		if (offset > self.images.count * frameWidth) {
			CGPoint contentOffset = self.scrollView.contentOffset;
			contentOffset.x = frameWidth;
			self.scrollView.contentOffset = contentOffset;
			offset = self.scrollView.contentOffset.x;
		}
		
		//scroll to the first imageView
		if (offset < frameWidth) {
			CGPoint contentOffset = self.scrollView.contentOffset;
			contentOffset.x =  self.images.count * frameWidth;
			scrollView.contentOffset = contentOffset;
			offset = scrollView.contentOffset.x;
		}
	}
	
	//计算页数
	int page = abs((int)((offset - frameWidth) / frameWidth));
	self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self stopAutoScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if(self.enableLoop) {
		[self startAutoScroll];
	}
}

@end
