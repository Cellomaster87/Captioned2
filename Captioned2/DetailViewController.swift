//
//  DetailViewController.swift
//  Captioned
//
//  Created by Michele Galvagno on 26/03/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    func detailViewController(_ controller: DetailViewController, didFinishEditing item: Picture)
}

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedPicture: Picture?
    weak var delegate: DetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(editCaption))
        
        if let imageToLoad = selectedPicture?.image {
            let path = getDocumentsDirectory().appendingPathComponent(imageToLoad)
            imageView.image = UIImage(contentsOfFile: path.path)
            print(imageToLoad)
        } else {
            print("Image not found!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
        
        if let picture = selectedPicture {
            delegate?.detailViewController(self, didFinishEditing: picture)
        }
    }
    
    @objc func editCaption() {
        let captionAC = UIAlertController(title: "Add caption!", message: "Describe your picture", preferredStyle: .alert)
        captionAC.addTextField { (textField) in
            textField.placeholder = "Enter caption"
            textField.autocapitalizationType = .sentences
        }
        captionAC.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        captionAC.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self, weak captionAC] _ in
            guard let newCaption = captionAC?.textFields?[0].text else { return }
            
            self?.title = newCaption
            self?.selectedPicture?.caption = newCaption
        }))
        
        present(captionAC, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}
