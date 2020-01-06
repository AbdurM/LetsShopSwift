import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    //MARK: - Properties
    var item: Item!{
        didSet{
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
   
    //MARK: - Formatters
    let numberFormatter: NumberFormatter = {
       
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    
    // MARK: - Outlets
    @IBOutlet var nameField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    
    // MARK: - Actions
    @IBAction func backgroundTapped(_ sender: Any) {
        view.endEditing(true)  //to make keyboard disappear
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        
        // check if camera is available
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            presentUIImagePicker(sourceType: .camera)
        }
        else{
            presentUIImagePicker(sourceType: .photoLibrary)
        }
        
        
    }
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    //MARK - view life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        
        if let valueInDollars = item.valueInDollars
        {
        valueField.text = numberFormatter.string(from: NSNumber(value: valueInDollars ))
        }
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        if let image = imageStore.image(forKey: item.itemKey)
        {
            imageView.image = image
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //to make keyboard disappear
        view.endEditing(true)
        
        item.name = nameField.text ?? ""
        
        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText)
        {
            item.valueInDollars = value.intValue
        }
        else
        {
            item.valueInDollars = 0
        }
    }
    
    //MARK: - TextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    //MARK: - ImagePicker Controller delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // getting picked image from the info dictionary
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //saving the image in Cache
        imageStore.setImage(image, forKey: item.itemKey)
        
        imageView.image = image
        
        //dismissing image picker
        dismiss(animated: true, completion: nil)
    }
    
    
    func presentUIImagePicker(sourceType: UIImagePickerController.SourceType)
    {
         let imagePicker = UIImagePickerController()
         imagePicker.sourceType = sourceType
         imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
}
