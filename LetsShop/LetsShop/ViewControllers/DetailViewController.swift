import UIKit

class DetailViewController: UIViewController
{
    
    //region properties
    var item: Item!
    
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
    
}
