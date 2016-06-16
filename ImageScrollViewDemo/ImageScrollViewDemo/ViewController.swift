//
//  ViewController.swift
//  ImageScrollViewDemo
//
//  Created by stu on 16/6/10.
//  Copyright © 2016年 wyq. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var imageScrollView: ImageScrollView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews()
    {
        let images = [UIImage(named: "1.jpg")!, UIImage(named: "2.jpg")!, UIImage(named: "3.jpg")!]
        
        //set images
        imageScrollView.images = images
        
        //init with frame
        let imageScrollView2 = ImageScrollView(frame: CGRectMake(0, 156, self.view.frame.size.width, 128))
        imageScrollView2.images = images
        imageScrollView2.isAutoScroll = true
        imageScrollView2.imageClickedHandler = {(indexOfImage) -> Void in
            print("the index of clicked image: \(indexOfImage)")
        }
        
        self.view.addSubview(imageScrollView2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

