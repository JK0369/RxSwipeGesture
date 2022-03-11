//
//  ViewController.swift
//  ExPageControl
//
//  Created by Jake.K on 2022/03/11.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class ViewController: UIViewController {
  private let imageList = [
    UIImage(named: "one"),
    UIImage(named: "two"),
    UIImage(named: "three")
  ]

  private lazy var imageView: UIImageView = {
    let view = UIImageView()
    view.image = self.imageList[0]
    view.layer.cornerRadius = 16
    view.clipsToBounds = true
    view.contentMode = .scaleAspectFill
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  private lazy var pageControl: UIPageControl = {
    let control = UIPageControl()
    control.numberOfPages = self.imageList.count
    control.currentPage = 0
    control.pageIndicatorTintColor = .systemGray
    control.currentPageIndicatorTintColor = .white
    control.translatesAutoresizingMaskIntoConstraints = false
    return control
  }()
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(self.imageView)
    self.view.addSubview(self.pageControl)
    
    NSLayoutConstraint.activate([
      self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      
      self.pageControl.topAnchor.constraint(equalTo: self.view.topAnchor),
      self.pageControl.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      self.pageControl.rightAnchor.constraint(equalTo: self.view.rightAnchor)
    ])
    
    Observable
      .merge(
        self.view.rx.gesture(.swipe(direction: .left)).asObservable(),
        self.view.rx.gesture(.swipe(direction: .right)).asObservable()
      )
      .bind { [weak self] gesture in
        guard let ss = self else { return }
        guard let gesture = gesture as? UISwipeGestureRecognizer else { return }
        switch gesture.direction {
        case .left:
          ss.pageControl.currentPage += 1
        case .right:
          ss.pageControl.currentPage -= 1
        default:
          break
        }
        
        UIView.transition(
          with: ss.imageView,
          duration: 0.3,
          options: .transitionCrossDissolve,
          animations: { ss.imageView.image = ss.imageList[ss.pageControl.currentPage] },
          completion: nil
        )
      }
      .disposed(by: self.disposeBag)
    
  }
}
