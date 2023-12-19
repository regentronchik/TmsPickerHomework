//
//  ViewController.swift
//  TmsPickerHomework
//
//  Created by Алексей Козел on 19.12.2023.
//
// Есть UIImageView и UIPickerView.
// Просим пользователю выбрать несколько фото из галереи (мин 2).
// После выбора пользователем фоток, показываем их в UIPickerView.
// При выборе фотки в UIPickerView, показываем ее в UIImageView

import UIKit
import PhotosUI

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, PHPickerViewControllerDelegate {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!

    var selectedPhotos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        presentAlert()
    }
    
    lazy var pHpicker: PHPickerViewController =  {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 0
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }()
    
    @IBAction func buttonTapped(_ sender: Any) {
        present(pHpicker, animated: true)
    }
    
    // MARK: - PHPickerViewControllerDelegate
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.selectedPhotos.append(image)
                        self.pickerView.reloadAllComponents()
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        pickerImage.image = selectedPhotos[row]
        return pickerImage
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 150
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        imageView.image = selectedPhotos[row]
    }

    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedPhotos.count
    }

    // MARK: - Alert
    
    func presentAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Внимание", message: "Выберите минимум две фотографии", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
