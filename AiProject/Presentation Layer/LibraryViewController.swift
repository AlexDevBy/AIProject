//
//  ViewController.swift
//  AiProject
//
//  Created by Alex Misko on 28.02.23.
// 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

import Foundation
import UIKit
import SnapKit
import OpenAIKit

class LibraryViewController: UIViewController {
    
    var index = 0
    var array:[ImageInfo] = []
    let openai = OpenAI(Configuration(organization: "Personal",
                                      apiKey: "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"))
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PlusCollectionViewCell.self, forCellWithReuseIdentifier: "Plus")
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "Image")
        collectionView.backgroundColor = .clear
        collectionView.contentMode = .center
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    var pickerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "gallery"), for: .normal)
        //        button.setTitle("picker", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(onPickerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let imageContainer = Manager.shared.loadImageArray()
        self.array = imageContainer
        self.collectionView.reloadData()
    }
    
    @objc func onPickerButtonPressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func didTapCell(gesture: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @objc func deleteTapped(gesture: UILongPressGestureRecognizer) {
    
        let p = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            self.index = indexPath.item - 1
            print("\(self.index)")
            print("\(indexPath.item - 1)")
            let cell = self.collectionView.cellForItem(at: indexPath)
            
        } else {
            print("couldn't find index path")
        }
        
        if self.index == 1 { return  }
        addAlert(title: "ALERT!", message: "Do you realy want to delete this image?", style: .alert, okButtonHandler: { [self] UIAlertAction in
            guard var imageContainer = UserDefaults.standard.value([ImageInfo].self, forKey: Keys.images.rawValue) else { return }
            print(array.count)
            imageContainer.remove(at: self.index)
            array.remove(at: self.index)
            self.collectionView.reloadData()
            UserDefaults.standard.set(encodable: imageContainer, forKey: Keys.images.rawValue)
                 if array.count > 0 {
                     self.index -= 1
                     if index <= 0 {
                         self.index = array.count - 1
                     }
                 }
                 print(array.count)
                
             }) { UIAlertAction in
                 self.dismiss(animated: true, completion: nil)
                 self.collectionView.reloadData()
             }
            
         }
                 
    func assignBackground() {
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
        view.addSubview(containerView)
        containerView.addSubview(collectionView)
        containerView.addSubview(pickerButton)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(10)
            make.left.equalTo(containerView.snp.left).offset(16)
            make.right.equalTo(containerView.snp.right).offset(-16)
            make.bottom.equalTo(containerView.snp.bottom).offset(-75)
        }
        
        pickerButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.left.equalTo(containerView.snp.left).offset(40)
            make.bottom.equalTo(containerView.snp.bottom).offset(-40)
        }
    }
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0  {
            guard let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Plus", for: indexPath) as? PlusCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
            tap.numberOfTapsRequired = 1
            firstCell.addGestureRecognizer(tap)
            
            firstCell.configure(with: Image(name: "Plus"))
            firstCell.layer.shadowColor = UIColor.systemIndigo.cgColor
            firstCell.layer.shadowOpacity = 0.9
            firstCell.layer.shadowRadius = 55
            firstCell.layer.shadowOffset = CGSize.zero
            firstCell.layer.cornerRadius = 22.0
            return firstCell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image", for: indexPath) as? ImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(deleteTapped))
            cell.addGestureRecognizer(longPressRecognizer)
            
            cell.configure(with: array[indexPath.item - 1])
            view.layer.shadowColor = UIColor.systemIndigo.cgColor
            view.layer.shadowOpacity = 0.9
            view.layer.shadowRadius = 21
            view.layer.shadowOffset = CGSize.zero
            view.layer.cornerRadius = 22.0
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 107, height: 107)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let controller = PhotoViewController()
        controller.index = indexPath.item - 1
        self.index = indexPath.item - 1
        print(controller.index)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
