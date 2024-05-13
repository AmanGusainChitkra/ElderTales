//
//  NewPostHomeViewController.swift
//  ElderTales
//
//  Created by student on 01/05/24.
//

import UIKit

class NewPostHomeViewController: UIViewController {
    var scrollTimer:Timer?
    private var displayLink:CADisplayLink?

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello")
        startScrolling()
    }
    
        // Do any additional setup after loading the view.
    private func startScrolling() {
        displayLink = CADisplayLink(target: self, selector: #selector(handleScroll))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func handleScroll() {
        let desiredSpeed: CGFloat = 0.2 // Speed in points per frame, adjust as needed
        let currentOffset = scrollView.contentOffset
        let newOffset = CGPoint(x: currentOffset.x + desiredSpeed, y: currentOffset.y)

        if newOffset.x < scrollView.contentSize.width - scrollView.bounds.width {
            scrollView.contentOffset = newOffset
        } else {
            displayLink?.invalidate()
            displayLink = nil
        }
    }


}
