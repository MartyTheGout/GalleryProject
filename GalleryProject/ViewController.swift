//
//  ViewController.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit

class ViewController: UITabBarController {

    let colorUnSelected : UIColor = .lightGray
    let colorSelected : UIColor = .black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarItems()
        configureBarAppearance()
    }
    
    private func configureBarItems() {
        let mainVC = MainViewController()
        let mainVCSymbol = UIImage(systemName: "chart.line.uptrend.xyaxis")?.withTintColor(colorUnSelected)
        let mainVCSymbolSelected = UIImage(systemName: "chart.line.uptrend.xyaxis")?.withTintColor(colorSelected)
        mainVC.tabBarItem = UITabBarItem(title: "", image: mainVCSymbol, selectedImage: mainVCSymbolSelected)
        
        let playableVC = PlayableViewController()
        let playableVCSymbol =  UIImage(systemName: "play.display")?.withTintColor(colorUnSelected)
        let playableVCSymbolSelected =  UIImage(systemName: "play.display")?.withTintColor(colorSelected)
        playableVC.tabBarItem = UITabBarItem(title: "", image: playableVCSymbol, selectedImage: playableVCSymbolSelected)
        
        let searchVC = SearchViewController()
        let searchVCSymbol = UIImage(systemName: "magnifyingglass")?.withTintColor(colorUnSelected)
        let searchVCSymbolSelected = UIImage(systemName: "magnifyingglass")?.withTintColor(colorSelected)
        let searchNC = UINavigationController(rootViewController: searchVC)
        searchNC.tabBarItem = UITabBarItem(title: "", image:searchVCSymbol , selectedImage: searchVCSymbolSelected)
        
        let likeVC = LikeViewController()
        let likeVCSymbol = UIImage(systemName: "heart")?.withTintColor(colorUnSelected)
        let likeVCSymbolSelected = UIImage(systemName: "heart")?.withTintColor(colorSelected)
        likeVC.tabBarItem = UITabBarItem(title: "", image: likeVCSymbol, selectedImage: likeVCSymbolSelected)
        
        let viewControllers = [mainVC, playableVC, searchNC, likeVC]
        setViewControllers(viewControllers, animated: true)
    }
    
    private func configureBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .black
    }
}

// tabBar는 왜 delegate 없이 되는가? 하지만 왜 Delegate Protocol을 채택하는가
extension ViewController: UITabBarControllerDelegate {}
