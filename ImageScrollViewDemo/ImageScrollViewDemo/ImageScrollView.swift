//
//  ImageScrollView.swift
//
//
//  Created by WangYiqiao on 16/6/10.
//  Copyright © 2016年 wyq. All rights reserved.
//

import UIKit

class ImageScrollView: UIView, UIScrollViewDelegate
{
    //time interval of auto scrolling
    let kAutoScrollInterval: NSTimeInterval = 5.0
    
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    
    var frameWidth: CGFloat!
    var frameHeight: CGFloat!
    var scrollTimer: NSTimer? = nil
    var imageViews: [UIImageView] = []
    
    //image clicked action, parameter: the index of clicked image
    var imageClickedHandler: ((Int) -> Void)?

    var images: [UIImage] = [] {
        didSet
        {
            updateScrollView()
        }
    }
    
    var isAutoScroll = false {
        didSet
        {
            if isAutoScroll
            {
                startAutoScroll()
            }
            else
            {
                stopAutoScroll()
            }
        }
    }
    
    //MARK: - Init
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        frameWidth = frame.size.width
        frameHeight = frame.size.height
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        frameWidth = frame.size.width
        frameHeight = frame.size.height
        
        scrollView.frame = self.bounds
        pageControl.center.x = self.center.x
        pageControl.center.y = self.bounds.size.height - 20
    }
    
    //MARK: - Setup
    
    func setupViews()
    {
        //setup scrollview
        scrollView.frame = self.bounds
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        self.addSubview(scrollView)
        
        
        //setup page controll
        pageControl.center.x = self.center.x
        pageControl.center.y = self.bounds.size.height - 20
        pageControl.defersCurrentPageDisplay = true
        pageControl.hidesForSinglePage = true
        self.addSubview(pageControl)
        
    }
    
    //MARK: - Action
    
    func tapOnImageView(recoginzer: UITapGestureRecognizer)
    {
        if let indexOfImage = recoginzer.view?.tag
        {
            self.imageClickedHandler?(indexOfImage)
        }
    }
    
    //MARK: - Utility
    
    func startAutoScroll()
    {
        if scrollTimer != nil || images.count < 2 || !isAutoScroll
        {
            return
        }
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(kAutoScrollInterval, target: self, selector: #selector(doAutoScroll), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        self.scrollTimer = timer
    }
    
    func doAutoScroll()
    {
        var offset = scrollView.contentOffset.x + frameWidth
        
        //scroll to the first image
        if offset > CGFloat(self.images.count) * frameWidth
        {
            offset = frameWidth
        }
        
        scrollView.setContentOffset(CGPointMake(offset, 0), animated: true)
        
        let page =  abs(Int((offset - frameWidth) / frameWidth))
        pageControl.currentPage = page
    }
    
    func stopAutoScroll()
    {
        self.scrollTimer?.invalidate()
        self.scrollTimer = nil
    }
    
    func updateScrollView()
    {
        layoutIfNeeded()
        
        stopAutoScroll()
        
        pageControl.numberOfPages = images.count
        
        // calculate the contentSize
        if images.count >= 2
        {
            scrollView.contentSize = CGSizeMake(CGFloat(images.count + 2) * frameWidth, 0)
            scrollView.contentOffset.x = frameWidth
        }
        else
        {
            scrollView.contentSize = CGSizeMake(CGFloat(images.count) * frameWidth, 0)
            scrollView.contentOffset.x = 0
        }
        
        updateImageViews()
        
        startAutoScroll()
    }
    
    func clearImageViews()
    {
        for imgView in self.imageViews
        {
            imgView.removeFromSuperview()
        }
        
        self.imageViews = []
    }
    
    func updateImageViews()
    {
        clearImageViews()
        
        //add two more images to make a circle
        //在首尾各多添加一张图片使之形成环
        let numOfImgviews = images.count >= 2 ? images.count + 2 : images.count
        
        for i in 0..<numOfImgviews
        {
            let imageView = UIImageView(frame: CGRectMake(CGFloat(i) * frameWidth, 0, frameWidth, frameHeight))
            imageView.userInteractionEnabled = true
            imageView.contentMode = .ScaleToFill
            
            if i <= 0
            {
                imageView.image = self.images.last
                imageView.tag = numOfImgviews - 1
            }
            else if i >= numOfImgviews - 1
            {
                imageView.image = self.images.first
                imageView.tag = 0
            }
            else
            {
                imageView.image = self.images[i - 1]
                imageView.tag = i - 1
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnImageView))
            imageView.addGestureRecognizer(tapGesture)
            
            self.scrollView.addSubview(imageView)
            self.imageViews.append(imageView)
        }
        
        
    }
    
    //MARK: - UIScrollView delegate
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        var offset = scrollView.contentOffset.x
        
        if self.images.count >= 2
        {
            //scroll to the last imageView
            if offset > CGFloat(self.images.count) * frameWidth
            {
                scrollView.contentOffset.x = frameWidth
                offset = scrollView.contentOffset.x
            }
            
            //scroll to the first imageView
            if offset < frameWidth
            {
                scrollView.contentOffset.x = CGFloat(self.images.count) * frameWidth
                offset = scrollView.contentOffset.x
            }
        }
        
        //calculate page
        let page =  abs(Int((offset - frameWidth) / frameWidth))
        pageControl.currentPage = page
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        startAutoScroll()
    }
    
}

