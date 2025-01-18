//
//  BasePattern.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit
import SnapKit

//MARK: UIEssentialCycle - Protocol
protocol UIEssentialCycle {
    
    func configureViewHierarchy()
    
    func configureViewLayout()
    
    func configureViewDesign()
}

//MARK: BaseUI - Extension
class BaseUI : UIView, UIEssentialCycle {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewHierarchy()
        configureViewLayout()
        configureViewDesign()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViewHierarchy() {}

    func configureViewLayout() {}
    
    func configureViewDesign() {}
}

//MARK: BaseViewController - Extension
class BaseViewController : UIViewController, UIEssentialCycle {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarchy()
        configureViewLayout()
        configureViewDesign()
        configureNavigatorSection()
    }
    
    func configureViewHierarchy() {}

    func configureViewLayout() {}
    
    func configureViewDesign() {}
    
    func configureNavigatorSection() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Arial Rounded MT Bold", size: 25)!]
    }
    
    func showAlert(title: String, message: String, actionMessage: String) {
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionMessage, style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

//MARK: BaseCollecionViewCell - Extension
class BaseCollecionViewCell : UICollectionViewCell, UIEssentialCycle {
    static let identifier = String(describing: self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewHierarchy()
        configureViewLayout()
        configureViewDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViewHierarchy() {}

    func configureViewLayout() {}
    
    func configureViewDesign() {}
}

//MARK: BaseScrollViewController - Extension
class BaseScrollViewController : UIViewController, UIEssentialCycle, UIScrollViewDelegate {
    
    let scrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bouncesZoom = true
        return scrollView
    }()
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        configureScrollToContentHierarchy()
        configureScrollToContentLayout()
        
        configureViewHierarchy()
        configureViewLayout()
        attachingContentViewToBottomElement()
        configureViewDesign()
    }
    
    // Default is vertical setting 
    func configureScrollToContentHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    func configureScrollToContentLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.verticalEdges.equalTo(scrollView) // scrollView.snp.verticalEdge가 아니어도 괜찮은 것인가?
        }
    }
    
    func configureViewHierarchy() {}

    func configureViewLayout() {}
    
    func configureViewDesign() {}
    
    func attachingContentViewToBottomElement() {
        guard let lastTarget = contentView.subviews.last else {
            print("[Ambiguous] There is no element to attach to the bottom of contentView")
            return
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(lastTarget.snp.bottom)
        }
    }
}
