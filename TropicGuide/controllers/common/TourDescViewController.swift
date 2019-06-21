import UIKit
import Kingfisher

class TourDescViewController: BaseViewController {

    private var scrollView: UIScrollView?
    private let fullDesc = UILabel()

    var name: String?
    var desc: NSAttributedString?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        if let name = name {
            navigationItem.title = name
        }
        setupViews()
    }

    func setupViews() {
        view.backgroundColor = .white

        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView!.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView!)


        fullDesc.translatesAutoresizingMaskIntoConstraints = false
        fullDesc.attributedText = desc
        fullDesc.numberOfLines = 0
        scrollView!.addSubview(fullDesc)

        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(view.frame.width - 20))]", views: fullDesc)
        scrollView!.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: fullDesc)
    }

}
