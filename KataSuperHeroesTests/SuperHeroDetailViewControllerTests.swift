//
//  SuperHeroDetailViewControllerTests.swift
//  KataSuperHeroes
//
//  Created by Óscar García on 27/4/17.
//  Copyright © 2017 GoKarumi. All rights reserved.
//

import Foundation
import KIF
import Nimble
import UIKit

@testable import KataSuperHeroes

class SuperHeroDetailViewControllerTests: AcceptanceTestCase {
    
    fileprivate let repository = MockSuperHeroesRepository()
    
    func testShowsSuperHeroNameAsTitle() {
        let superHero = givenASuperHeroWithName()
        
        openSuperHeroDetailViewController(superHero.name)
        
        tester().waitForView(withAccessibilityLabel: superHero.name)
    }
    
    func testShowsNameSuperHero() {
        let superHero = givenASuperHeroWithName()
        
        openSuperHeroDetailViewController(superHero.name)
        
        tester().waitForView(withAccessibilityLabel: "Name: \(superHero.name)")
    }
    
    func testShowsDescriptionSuperHero() {
        let superHero = givenASuperHeroWithName()
        
        openSuperHeroDetailViewController(superHero.name)
        
        tester().waitForView(withAccessibilityLabel: "Description: \(superHero.name)")
    }
    
    func testShowsIsAvengersSuperHero() {
        let superHero = givenASuperHeroWithName(true)
        
        openSuperHeroDetailViewController(superHero.name)
        
        tester().waitForView(withAccessibilityLabel: "Avengers Badge")
    }
    
    func testShowsDoesNotAvengersSuperHero() {
        let superHero = givenASuperHeroWithName(false)
        
        openSuperHeroDetailViewController(superHero.name)
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Avengers Badge")
    }
    
    fileprivate func givenASuperHeroWithName(_ isAvenger: Bool = false) -> SuperHero {
        let superHero = SuperHero(name: "Mr. Clean",
                                  photo: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg"),
                                  isAvenger: isAvenger, description: "Description")
        repository.superHeroes = [superHero]
        return superHero
    }
    
    fileprivate func openSuperHeroDetailViewController(_ superHeroName: String) {
        let superHeroDetailViewController = ServiceLocator()
            .provideSuperHeroDetailViewController(superHeroName) as! SuperHeroDetailViewController
        superHeroDetailViewController.presenter = SuperHeroDetailPresenter(ui: superHeroDetailViewController,
                                                                           superHeroName: superHeroName,
                                                                           getSuperHeroByName: GetSuperHeroByName(repository: repository))
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroDetailViewController]
        present(viewController: rootViewController)
        tester().waitForAnimationsToFinish()
    }
}
