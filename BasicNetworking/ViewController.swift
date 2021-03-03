import UIKit

// MARK: - Controller
class ViewController: UIViewController, ModelObserver {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    var model: ImageModel?
    var data: [ImageData]? = [] {
        didSet {
            DispatchQueue.main.async {
                self.loadIndicator.stopAnimating()
                self.loadIndicator.isHidden = true
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        model = ImageModel(observer: self)
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.bringSubviewToFront(loadIndicator)
        model?.loadData()
    }
}

// MARK: - table view data source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell",
                                                       for: indexPath) as? ImageCell,
              let images = data else { return UITableViewCell() }
        cell.artImageID.text = String(images[indexPath.row].id)
        cell.artImageDate.text = images[indexPath.row].date
        if images.count >= indexPath.row {
            cell.artImageView.image = images[indexPath.row].image
        }
        return cell
    }
}
