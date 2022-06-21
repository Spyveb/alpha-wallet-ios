//
//  OnboardingVC.swift
//  AlphaWallet
//
//  Created by Ankit on 13/06/22.
//

import UIKit

protocol OnboardingVCDelegate: AnyObject {
    func didTapCreateWallet()
    func didTapWatchWallet()
    func didTapImportWallet()
}

class OnboardingVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var skipView: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var btnSkip: UIButton!
    
    weak var delegate: OnboardingVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        scrollView.isHidden = true
//        skipView.isHidden = true
//        imgLogo.isHidden = false
//        mainThread(0.5) {
//            self.scrollView.isHidden = false
//            self.skipView.isHidden = false
//            self.imgLogo.isHidden = true
//        }
    }
    
    @IBAction func pageControlValueChanged(_ sender: Any) {
        //let nextIndexPath = min(pagecontrol.currentPage + 1, pages.count - 1)
        scrollView?.scrollRectToVisible(CGRect(x: CGFloat(pagecontrol.currentPage) * self.view.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.width), animated: true)
        //pagecontrol.currentPage = nextIndexPath
        btnSkip.isHidden = (pagecontrol.currentPage == 4)
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        let nextIndexPath = 4
        scrollView?.scrollRectToVisible(CGRect(x: CGFloat(nextIndexPath) * self.view.bounds.width, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.width), animated: true)
        pagecontrol.currentPage = nextIndexPath
        btnSkip.isHidden = true
    }
    
    @IBAction func createTapped(_ sender: Any) {
        delegate?.didTapCreateWallet()
    }
    
    @IBAction func watchTapped(_ sender: Any) {
        self.delegate?.didTapWatchWallet()
    }
    
    @IBAction func importTapped(_ sender: Any) {
        self.delegate?.didTapImportWallet()
    }
    
    @IBAction func buyTapped(_ sender: Any) {
        
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pagecontrol.currentPage = Int(scrollView.contentOffset.x / view.frame.width)
        btnSkip.isHidden = (pagecontrol.currentPage == 4)
    }
}

func mainThread(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
