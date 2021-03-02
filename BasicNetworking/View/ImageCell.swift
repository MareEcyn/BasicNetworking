import UIKit

class ImageCell: UITableViewCell {
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var artImageID: UILabel!
    @IBOutlet weak var artImageDate: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
