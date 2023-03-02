//
//  PhotoViewController.swift
//  AiProject
//
//  Created by Alex Misko on 28.02.23.
//

import Foundation
import UIKit
import SnapKit
import OpenAIKit

class PhotoViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate  {
    
    var index = 0
    var images:[ImageInfo] = []
    private var openai = OpenAI(Configuration(organization: "Personal",
                                              apiKey: "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"))
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let promptField: UITextField = {
        let field = UITextField()
        field.backgroundColor = AppColor.white
        field.layer.cornerRadius = 15
        field.layer.borderColor = AppColor.grey.cgColor
        field.layer.borderWidth = 1
        
        let placeHolderAttribited = NSAttributedString(string: "Prompt",
                                                       attributes: [.foregroundColor: AppColor.grey])
        field.font = .systemFont(ofSize: 18.0)
        field.attributedPlaceholder = placeHolderAttribited
        return field
    }()
    
    let promptButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = AppColor.white
        button.layer.cornerRadius = 15
        button.layer.borderColor = AppColor.grey.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(onPromptButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    var photoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let changeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CHANGE", for: .normal)
        button.addTarget(self, action: #selector(onChangeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promptField.delegate = self
        assignBackground()
        setupViews()
        setupConstraints()
        initializeHideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let imageContainer = Manager.shared.loadImageArray()
        self.images = imageContainer
        photoView.image = pickImage(index)
    }
    
    func pickImage(_ index: Int) -> UIImage {
        print(images.count)
        let image = Manager.shared.loadImage(fileName: images[index].name)
        return image!
    }
    
    @objc func onPromptButtonPressed() {
        print("tapped")
        guard let textFieldText = self.promptField.text else { return }
        Task {
            let newImage = await generateImage(prompt: textFieldText)
            if newImage == nil {
                print("fail bro")
            } else {
                guard let image = newImage else { return }
                self.photoView.image = image
            }
        }
    }
    
    @objc func onChangeButtonPressed() {
        print("tapped")
        guard let photo = self.photoView.image else { return }
        let resizedPhoto = resizeImage(image: photo, targetSize: CGSizeMake(326.0, 326.0))
        Task {
            let newImage = await makeVariation(inputPhoto: resizedPhoto)
            if newImage == nil {
                print("fail bro")
            } else {
                guard let image = newImage else { return }
                self.photoView.image = image
            }
        }
    }
    
    func generateImage(prompt: String) async -> UIImage? {
        do {
            let params = ImageParameters(prompt: prompt, resolution: .large, responseFormat: .base64Json)
            let result = try await openai.createImage(parameters: params)
            let data = result.data[0].image
            let image = try openai.decodeBase64Image(data)
            return image
        }
        catch {
            print(String(describing: error))
            return nil
        }
    }
    
    func makeVariation(inputPhoto: UIImage) async -> UIImage? {
        do {
            let params = try ImageVariationParameters(image: inputPhoto,
                                                      numberOfImages: 1,
                                                      resolution: .large,
                                                      responseFormat: .base64Json)
            
            let result = try await openai.generateImageVariations(parameters: params)
            let data = result.data[0].image
            let image = try openai.decodeBase64Image(data)
            
            return image
        }
        catch {
            //TODO: вывести что-то на экран если не получилось
            print(String(describing: error))
            return nil
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    func assignBackground() {
        let background = UIImage(named: "background2")
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
        containerView.addSubview(photoView)
        containerView.addSubview(changeButton)
        containerView.addSubview(promptField)
        containerView.addSubview(promptButton)
    }
    
    func setupConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        promptField.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.top).offset(-85)
            make.left.equalTo(photoView.snp.left)
            make.right.equalTo(photoView.snp.right).offset(-60)
            make.bottom.equalTo(photoView.snp.top).offset(-35)
        }
        
        promptButton.snp.makeConstraints { make in
            make.top.equalTo(promptField.snp.top)
            make.left.equalTo(photoView.snp.right).offset(-55)
            make.right.equalTo(photoView.snp.right)
            make.bottom.equalTo(promptField.snp.bottom)
        }
        
        photoView.snp.makeConstraints { make in
            make.height.width.equalTo(330)
            make.center.equalToSuperview()
        }
        
        changeButton.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.left.equalTo(containerView.snp.left).offset(35)
            make.right.equalTo(containerView.snp.right).offset(-35)
            make.bottom.equalTo(containerView.snp.bottom).offset(-85)
        }
    }
}
