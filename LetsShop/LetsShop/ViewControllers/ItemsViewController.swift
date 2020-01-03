import UIKit

class ItemsViewController: UITableViewController
{
    var itemStore: ItemStore!
    
    //region UIViewController lifecycle callbacks
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //End region UIViewController lifecycle callbacks
    
    //region overriding UITableViewDataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemStore.allItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let item = itemStore.allItems[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        if let valueInDollars = item.valueInDollars
        {
            cell.detailTextLabel?.text = "$\(valueInDollars)"
        }
        
        return cell
    }
    
    //End region overriding UITableViewDataSource methods
}
