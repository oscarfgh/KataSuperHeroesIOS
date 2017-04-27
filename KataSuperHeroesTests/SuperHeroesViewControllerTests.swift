//
//  SuperHeroesViewControllerTests.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 13/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
import KIF
import Nimble
import UIKit
@testable import KataSuperHeroes

class SuperHeroesViewControllerTests: AcceptanceTestCase {

    fileprivate let repository = MockSuperHeroesRepository()
    fileprivate let emptyCaseText = "¯\\_(ツ)_/¯"

    func testShowsEmptyCaseIfThereAreNoSuperHeroes() {
        givenThereAreNoSuperHeroes()

        openSuperHeroesViewController()

        tester().waitForView(withAccessibilityLabel: emptyCaseText)
    }
    
    func testShowsIfThereAreSuperHeroes() {
        _ = givenThereAreSomeSuperHeroes()
        
        openSuperHeroesViewController()
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: emptyCaseText)
    }
    
    func testShowsSuperHeroeName() {
        let superHeroes = givenThereAreSomeSuperHeroes(1)
        
        openSuperHeroesViewController()
        
        tester().waitForView(withAccessibilityLabel: superHeroes[0].name)
    }
    
    func testShowsTenSuperHeroesName() {
        let superHeroes = givenThereAreSomeSuperHeroes(10)
        
        openSuperHeroesViewController()
        
        for i in 0..<superHeroes.count {
            let superHeroCell = tester().waitForView(withAccessibilityLabel: superHeroes[i].name)
                as! SuperHeroTableViewCell
            
            expect(superHeroCell.nameLabel.text).to(equal(superHeroes[i].name))
        }
    }
    
    func testShowsAvengersSuperHeroesWithBadge() {
        let superHeroes = givenThereAreSomeSuperHeroes(5, avengers: true)
        
        openSuperHeroesViewController()
        
        for i in 0..<superHeroes.count {
            tester().waitForView(withAccessibilityLabel: "\(superHeroes[i].name) - Avengers Badge")
        }
    }
    
    func testShowsNoAvengersSuperHeroesWithoutBadge() {
        let superHeroes = givenThereAreSomeSuperHeroes(5, avengers: false)
        
        openSuperHeroesViewController()
        
        for i in 0..<superHeroes.count {
            tester().waitForAbsenceOfView(withAccessibilityLabel: "\(superHeroes[i].name) - Avengers Badge")
        }
    }

    fileprivate func givenThereAreNoSuperHeroes() {
        _ = givenThereAreSomeSuperHeroes(0)
    }

    fileprivate func givenThereAreSomeSuperHeroes(_ numberOfSuperHeroes: Int = 10,
        avengers: Bool = false) -> [SuperHero] {
        var superHeroes = [SuperHero]()
        for i in 0..<numberOfSuperHeroes {
            let superHero = SuperHero(name: "SuperHero - \(i)",
                photo: NSURL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg") as URL?,
                isAvenger: avengers, description: "Description - \(i)")
            superHeroes.append(superHero)
        }
        repository.superHeroes = superHeroes
        return superHeroes
    }

    fileprivate func openSuperHeroesViewController() {
        let superHeroesViewController = ServiceLocator()
            .provideSuperHeroesViewController() as! SuperHeroesViewController
        superHeroesViewController.presenter = SuperHeroesPresenter(ui: superHeroesViewController,
                getSuperHeroes: GetSuperHeroes(repository: repository))
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroesViewController]
        present(viewController: rootViewController)
        tester().waitForAnimationsToFinish()
    }
}
