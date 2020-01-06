
//Note: Because the images tend to get very large, it is a good idea to keep them sepearate from other data. Images will be stored in an instance of this class. It will fetch and cache the images as required. It will also be able to flush the cache if the device runs low on memory.

import UIKit

class ImageStore{
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String)
    {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func image(forKey key: String) -> UIImage?
    {
        return cache.object(forKey: key as NSString)
    }
    
    func deleteImage(forKey key: String)
    {
        cache.removeObject(forKey: key as NSString)
    }
    
     
}
