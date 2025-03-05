//
//  VIPERConfig.swift
//  MyCitiesChallenge
//
//  Created by Alejandro isai Acosta Martinez on 04/03/25.
//

import UIKit

// MARK: - Base Class

open class CleanArchitectureLayer {}

// MARK: - Protocols

public protocol ViewLayer: AnyObject {}
public protocol InteractorToPresenter: AnyObject {}

// MARK: - Final Classes

/// Represents the Presentation layer (base variant).
class Presenter: CleanArchitectureLayer {
    public weak var _view: ViewLayer?
    
    public override init() {
        super.init()
    }
}

/// Represents the Interactor layer (base variant).
class Interactor: CleanArchitectureLayer {
    public var _presenter: Presenter?
    public var _router: Router?
    
    public override init() {
        super.init()
    }
}

/// Represents the Router layer (base variant).
class Router: CleanArchitectureLayer {
    public weak var _view: UIViewController?
    
    public override init() {
        super.init()
    }
}

// MARK: - UIViewController Extension

/// Make UIViewController adopt the 'ViewLayer' protocol.
extension UIViewController: ViewLayer {}

