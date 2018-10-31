//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    var stackView : UIStackView = UIStackView()
    var heightLayout1 : NSLayoutConstraint!
    var heightLayout2 : NSLayoutConstraint!
    var heightLayout3 : NSLayoutConstraint!
    let view1 : UIView = UIView()
    let view2 : UIView = UIView()
    let view3 : UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    func setup() {
        
        
        view1.backgroundColor = UIColor.red
        view1.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        heightLayout1 = view1.heightAnchor.constraint(equalToConstant: 300)
        heightLayout1.isActive = true
        view2.backgroundColor = UIColor.blue
        view2.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        heightLayout2 = view2.heightAnchor.constraint(equalToConstant: 300)
        heightLayout2.isActive = true
        
        view3.backgroundColor = UIColor.yellow
        view3.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        view3.alpha = 0
        heightLayout3 = view3.heightAnchor.constraint(equalToConstant: 200)
        heightLayout3.isActive = true
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(view1)
        stackView.addArrangedSubview(view2)
        stackView.backgroundColor = UIColor.yellow
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view3.translatesAutoresizingMaskIntoConstraints = false
        self.view1.addSubview(view3)
        view3.topAnchor.constraint(equalTo: self.view1.topAnchor).isActive = true
        view3.leadingAnchor.constraint(equalTo: self.view1.leadingAnchor).isActive = true
        self.view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        print("lol2")
        
        ///Button
        
        let button : UIButton = UIButton(type: .custom)
        button.setTitle("Press me", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 100)
        button.heightAnchor.constraint(equalToConstant: 30)
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.addTarget(self, action: #selector(self.hideShow(target:)), for: .touchUpInside)
        
    }

    @objc func hideShow(target: AnyObject?) {
//        let isHiding : Bool = heightLayout1.constant == 200
        heightLayout1.constant = heightLayout1.constant == 200 ? 300 : 200
        let anim : UIViewPropertyAnimator = UIViewPropertyAnimator(duration: CATransaction.animationDuration() * 10, curve: UIView.AnimationCurve.easeInOut) {
            self.view.layoutIfNeeded()
        }
        
        anim.addAnimations {
            self.view3.alpha = self.view3.alpha == 0 ? 1 : 0
        }
        anim.startAnimation()
//        UIView.animate(withDuration: CATransaction.animationDuration(), delay: 0, options: [.curveEaseInOut], animations: {
//
//        }) { (success) in
//
//        }
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        print("lol1")
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
