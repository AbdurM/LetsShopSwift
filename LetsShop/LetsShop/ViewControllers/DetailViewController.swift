import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    //region properties
    var item: Item!{
        didSet{
            navigationItem.title = item.name
        }
    }
    
    //region formatters
    
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

    
    // region Outlets
    @IBOutlet var nameField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    
    // region Actions
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
    
    //region view lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        
        if let valueInDollars = item.valueInDollars
        {
        valueField.text = numberFormatter.string(from: NSNumber(value: valueInDollars ))
        }
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
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
    
    //region textFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    //End region textField Delegate methods
    
    
    func presentUIImagePicker(sourceType: UIImagePickerController.SourceType)
    {
         let imagePicker = UIImagePickerController()
         imagePicker.sourceType = sourceType
         imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}
