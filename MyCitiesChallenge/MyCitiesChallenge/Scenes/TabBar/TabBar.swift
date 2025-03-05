//
//  TabBar.swift
//  MyCitiesChallenge
//
//  Created by Alejandro isai Acosta Martinez on 05/03/25.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        
        let cityListVC = CityListBuilder.build()
        cityListVC.tabBarItem = UITabBarItem(
            title: "Cities",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet")
        )
        let cityListNav = UINavigationController(rootViewController: cityListVC)

        
        let favoritesVC = UIViewController()
        favoritesVC.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "star.fill"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)

        
        let settingsVC = UIViewController()
        settingsVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gear")
        )
        let settingsNav = UINavigationController(rootViewController: settingsVC)

        
        viewControllers = [cityListNav, favoritesNav, settingsNav]
    }

    private func setupAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .systemBackground

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
}
