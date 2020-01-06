import UIKit

class Item: NSObject, NSCoding{
   
    //MARK: - Properties
    var name: String
    var valueInDollars: Int?
    let dateCreated: Date
    var bought: Bool
    let itemKey: String
    
    //MARK: - Initialisers
    init(name: String, valueInDollars: Int?)
    {
        self.name = name
        self.valueInDollars = valueInDollars
        self.dateCreated = Date()
        self.bought = false
        self.itemKey = UUID().uuidString
        super.init()
    }
    
    convenience init(name: String)
    {
        self.init(name: name, valueInDollars: nil)
    }
    
    
    //for testing purposes
    // to be removed once the app is ready
    convenience init(random: Bool = false)
    {
        if random {
            let adjectives = ["Fresh", "Nice", "New"]
            
            let nouns = ["Milk","Bread", "Juice"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            
            let randomAdjective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            
            let randomValue = Int(arc4random_uniform(100))
            
            self.init(name: randomName, valueInDollars: randomValue)
        }
        else
        {
            self.init(name: "", valueInDollars: nil)
        }
    }
    
    
    //MARK: - For archiving and unarchiving. NSCoding protocol methods
    
    //func for archiving
    func encode(with coder: NSCoder) {
    
        coder.encode(name, forKey: "name")
        coder.encode(dateCreated, forKey: "dateCreated")
        coder.encode(itemKey, forKey: "itemKey")
        coder.encode(bought, forKey:"bought")
        coder.encode(valueInDollars, forKey: "valueInDollars")
    }
    
    // for unarchiving
    required init( coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(forKey: "name") as! String
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
        bought = aDecoder.decodeBool(forKey: "bought")
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        valueInDollars = (aDecoder.decodeObject(forKey: "valueInDollars") as! Int)
        
        super.init()
    }
    
   
}
