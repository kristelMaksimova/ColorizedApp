//
//  MainViewController.swift
//  ColorizedApp
//
//  Created by Kristel Maximova on 18.01.2022.
//

import UIKit

protocol ColorViewControllerDelegate {
    func setColor(_ color: UIColor)
}

class MainViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let colorVC = segue.destination as? ColorViewController else { return }
        colorVC.delegate = self
        colorVC.viewColor = view.backgroundColor
    }
}

// MARK: - ColorDelegate
extension MainViewController: ColorViewControllerDelegate {
    func setColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
