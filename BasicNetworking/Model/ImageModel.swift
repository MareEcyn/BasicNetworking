import Foundation
import UIKit

protocol ModelObserver: class {
    var data: [ImageData]? { get set }
}

struct ImageData {
    let id: Int
    let date: String
    let url: String
    var image: UIImage?
}

class ImageModel {
    private(set) var images: [ImageData] = []
    private weak var observer: ModelObserver?
    private var request: AnyObject?
    private var isLoadingCompleted = false {
        willSet(newValue) {
            if newValue == true {
                observer?.data = images
            }
        }
    }
    
    init(observer: ModelObserver) {
        self.observer = observer
    }
    
    func loadData() {
        let request = APIRequest(resource: ImagesResource())
        self.request = request
        request.load { (data) in
            guard let data = data else { return }
            data.forEach { (image) in
                let image = ImageData(id: image.id, date: image.date, url: image.URL, image: nil)
                self.images.append(image)
            }
            self.loadImage(withIndex: 0)
        }
    }
    
    private func loadImage(withIndex index: Int) {
        guard index < images.endIndex, let url = URL(string: images[index].url) else {
            isLoadingCompleted = true
            return
        }
        let request = ImageRequest(url: url)
        self.request = request
        request.load { [weak self] (data) in
            guard let data = data else { return }
            self?.images[index].image = data
            self?.loadImage(withIndex: index+1)
        }
    }
}
