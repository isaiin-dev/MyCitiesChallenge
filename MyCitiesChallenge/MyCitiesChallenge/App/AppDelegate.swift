//
//  AppDelegate.swift
//  MyCitiesChallenge
//
//  Created by Alejandro isai Acosta Martinez on 04/03/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Este método se llama al terminar el lanzamiento de la app
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Aquí puedes hacer configuraciones globales,
        // inicializar librerías analíticas, etc.
        // En iOS 13+ la ventana se configura en SceneDelegate.
        
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Retorna la configuración por defecto para crear una nueva escena
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Este método se llama cuando se descartan escenas (p. ej. en multitasking de iPad).
        // Libera cualquier recurso específico de las escenas descartadas.
    }
}

