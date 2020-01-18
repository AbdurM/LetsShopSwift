import UIKit

class ItemCell: UITableViewCell
{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var valueInDollarsLabel: UILabel!
    @IBOutlet var dateCreatedLabel: UILabel!
    
    
    func setup(name: String, valueInDollars: String, dateCreated: String, itemBought: Bool)
    {
        nameLabel.text = name
        valueInDollarsLabel.text = valueInDollars
        dateCreatedLabel.text = dateCreated
        
        if itemBought
        {
            backgroundColor = UIColor.green.withAlphaComponent(0.10)
        }
        else
        {
            backgroundColor = UIColor.white
        }
    }
}
