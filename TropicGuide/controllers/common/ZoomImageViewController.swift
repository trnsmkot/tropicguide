import UIKit
import Kingfisher

class ZoomImageViewController: BaseViewController, UIScrollViewDelegate {
    
    var bigImageUrl: String?
    private var imageView = UIImageView(frame: .zero)
    private let scrollImg: UIScrollView = UIScrollView()
    
//    private let imageRatio: CGFloat = 0.75
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupViews()
    }
    
    func setupViews() {

        let imageWidth = view.frame.width
        let imageHeight = view.frame.height

//        let topOffset = (view.frame.height - imageHeight - 80) / 2

        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        scrollImg.addGestureRecognizer(tap)
        
        scrollImg.delegate = self
        scrollImg.translatesAutoresizingMaskIntoConstraints = false
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        scrollImg.minimumZoomScale = 1
        scrollImg.maximumZoomScale = 6
        
        self.view.addSubview(scrollImg)
        
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollImg)
        if #available(iOS 11.0, *) {
            scrollImg.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            scrollImg.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            self.view.addConstraintsWithFormat(format: "V:|-60-[v0]|", views: scrollImg)
        }
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        imageView.contentMode = .scaleAspectFit
        if let imageUrl = bigImageUrl {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: imageUrl))
        }
        imageView.clipsToBounds = false
        scrollImg.addSubview(imageView)
    }
    
    @objc func doubleTapped() {
        if (scrollImg.zoomScale > 2) {
            scrollImg.setZoomScale(1, animated: true)
        } else {
            scrollImg.setZoomScale(3, animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
