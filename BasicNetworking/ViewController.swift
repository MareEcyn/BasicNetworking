// TODO: MVC must fix most of the problems

import UIKit

// MARK: - Controller
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!

    var imagesData: [Image]?
    var images: [UIImage] = [UIImage]()
    var r: AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.bringSubviewToFront(loadIndicator)
        fetch()
    }
}

// MARK: - table view data source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageCell,
              let imagesData = imagesData else { return UITableViewCell() }
        cell.artImageID.text = String(imagesData[indexPath.row].id)
        cell.artImageDate.text = imagesData[indexPath.row].date
        if images.count == imagesData.count {
            cell.artImageView.image = images[indexPath.row]
        }
        return cell
    }
}

// MARK: - Data load functions
extension ViewController {
    func fetch() {
        let request = APIRequest(resource: ImagesResource())
        r = request
        request.load { [weak self] (images) in
            guard let images = images else { return }
            self?.imagesData = images
            if self?.imagesData != nil {
                self?.fetchImage(withIndex: 0)
            }
        }
    }

    func fetchImage(withIndex index: Int) {
        guard index < imagesData!.endIndex else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.loadIndicator.stopAnimating()
                self.loadIndicator.isHidden = true
            }
            return
        }
        let request = ImageRequest(url: URL(string: imagesData![index].URL)!)
        r = request
        request.load { [weak self] (image) in
            guard let image = image else { return }
            self?.images.append(image)
            self?.fetchImage(withIndex: index+1)
        }
    }
}
