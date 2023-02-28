//
//  ViewController.swift
//  AiProject
//
//  Created by Alex Misko on 28.02.23.
//

import Foundation
import UIKit
import SnapKit

class LibraryViewController: UIViewController {
    
    var array:[ImageInfo] = []
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(PlusCollectionViewCell.self, forCellWithReuseIdentifier: "PlusCollectionViewCell")
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    var pickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("picker", for: .normal)
        button.addTarget(self, action: #selector(onPickerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //    let onLibraryButton: UIButton = {
    //        let button = UIButton()
    //        button.setTitle("Library", for: .normal)
    //        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
    //        button.setTitleColor(.white, for: .normal)
    //        button.backgroundColor = UIColor(red: 0.28, green: 0.28, blue: 0.28, alpha: 0.7)
    //        button.layer.cornerRadius = 4.0
    //        return button
    //    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //           assignBackground()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //           onLibraryButton.isHidden = true
        let imageContainer = Manager.shared.loadImageArray()
        self.array = imageContainer
        self.collectionView.reloadData()
        //           if array.count > 0 { onLibraryButton.isHidden = false}
    }
    
    func assignBackground(){
        let background = UIImage(named: "background")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    
    func setupViews() {
        view.addSubview(collectionView)
        //          view.addSubview(onLibraryButton)
        collectionView.delegate = self
        collectionView.dataSource = self
        //          onLibraryButton.addTarget(self, action: #selector(onLibraryButtonPressed(_:)), for: .touchUpInside)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-35)
        }
        
        pickerButton.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(30)
            make.left.equalToSuperview().offset(10)
//            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    @objc func onPickerButtonPressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func didTap(gesture: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //    @objc func onLibraryButtonPressed(_ sender: UIButton) {
    //        let controller = PhotoViewController()
    //        controller.images = self.array
    //        self.navigationController?.pushViewController(controller, animated: true )
    //    }
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count + 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0  {
            guard let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlusCollectionViewCell", for: indexPath) as? PlusCollectionViewCell else {
                return UICollectionViewCell()
            }
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
            tap.numberOfTapsRequired = 1
            firstCell.addGestureRecognizer(tap)
            firstCell.configure(with: Image(name: "plus"))
            return firstCell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: array[indexPath.item - 1])
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.size.width - 10)/2
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let controller = PhotoViewController()
        //        controller.index = indexPath.item - 1
        print(controller.index)
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    
}
