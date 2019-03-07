//
//  DisplaySpinningSquareViewController.swift
//  PlasticTest
//
//  Created by Juan Carlos Samboni Ramirez on 3/6/19.
//  Copyright (c) 2019 Juan Carlos Samboni Ramirez. All rights reserved.
//

import UIKit

protocol DisplaySpinningSquareDisplayLogic: class {
    func displayTime(viewModel: DisplaySpinningSquare.FetchTime.ViewModel)
}

class DisplaySpinningSquareViewController: UIViewController {
    struct AnimationConstants {
        static let squareSpeed = 0.2
        static let squareRotatingSpeed = 0.5
        static let drawerSpeed = 0.5
        static let drawerDampingRation: CGFloat = 0.5
        static let timeLabelFadeInSpeed = 0.5
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var spinningSquareView: UIView!
    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var centerContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightDrawerConstraint: NSLayoutConstraint!
    
    var interactor: DisplaySpinningSquareBusinessLogic?
    
    private var firstLoad = true
    private var originalSquarePosition: CGPoint!
    private var collapsedDrawerHeight: CGFloat!
    private var expandedDrawerHeight: CGFloat = 200
    private var fetchTimer = DispatchSource.makeTimerSource()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchTime()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstLoad {
            setInitialValues()
            firstLoad = false
        }
    }
    
    // MARK: Use Cases Methods
    
    func fetchTime() {
        interactor?.fetchTime()
    }
    
    // MARK: Gestures methods
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            expandDrawer()
            fallthrough
        case .changed, .possible:
            performTranslation(with: recognizer)
        default:
            if squareShouldEnterDrawer() {
                moveSquareToDrawer()
            } else {
                collapseDrawer()
                resetSquarePosition()
            }
        }
    }
}

extension DisplaySpinningSquareViewController: DisplaySpinningSquareDisplayLogic {
    func displayTime(viewModel: DisplaySpinningSquare.FetchTime.ViewModel) {
        fadeInTimeLabelIfNeeded()
        timeLabel.text = viewModel.formattedTime
    }
}

private extension DisplaySpinningSquareViewController {
    func setup() {
        let viewController = self
        let interactor = DisplaySpinningSquareInteractor()
        let presenter = DisplaySpinningSquarePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    func setupUI() {
        setupSquare()
    }
    
    func setupSquare() {
        timeLabel.alpha = 0
        containerView.backgroundColor = .clear
        spinningSquareView.layer.cornerRadius = 4.0
        fetchTimer.schedule(deadline: .now(), repeating: .seconds(1))
        fetchTimer.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.rotateSquare()
            }
        })
        fetchTimer.resume()
    }
    
    func setInitialValues() {
        originalSquarePosition = CGPoint(x: centerContainerViewConstraint.constant,
                                         y: topContainerViewConstraint.constant)
        collapsedDrawerHeight = drawerView.frame.height
    }
    
    func fadeInTimeLabelIfNeeded() {
        if timeLabel.alpha != 1 {
            let animator = UIViewPropertyAnimator(duration: AnimationConstants.timeLabelFadeInSpeed,
                                                  curve: .easeOut) { [weak self] in
                self?.timeLabel.alpha = 1
            }
            animator.startAnimation()
        }
    }
    
    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * .pi / 180.0
    }
    
    func rotateSquare() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = AnimationConstants.squareRotatingSpeed
        animation.isRemovedOnCompletion = true
        animation.fromValue = 0
        animation.toValue = deg2rad(360)
        spinningSquareView.layer.add(animation, forKey: "rotation")
    }
    
    func performTranslation(with recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        centerContainerViewConstraint.constant += translation.x
        topContainerViewConstraint.constant += translation.y
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func resetSquarePosition() {
        centerContainerViewConstraint.constant = originalSquarePosition.x
        topContainerViewConstraint.constant = originalSquarePosition.y
        let animator = UIViewPropertyAnimator(duration: AnimationConstants.squareSpeed,
                                              curve: .easeOut) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    func expandDrawer() {
        heightDrawerConstraint.constant = expandedDrawerHeight
        animateDrawer()
    }
    
    func collapseDrawer() {
        heightDrawerConstraint.constant = collapsedDrawerHeight
        animateDrawer()
    }
    
    func animateDrawer() {
        let animator = UIViewPropertyAnimator(duration: AnimationConstants.drawerSpeed,
                                              dampingRatio: AnimationConstants.drawerDampingRation) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    func squareShouldEnterDrawer() -> Bool {
        let bottomCoordinate = containerView.frame.origin.y + containerView.frame.height
        return (bottomCoordinate - drawerView.frame.origin.y) >= containerView.frame.height * 0.25
    }
    
    func moveSquareToDrawer() {
        centerContainerViewConstraint.constant = 0
        topContainerViewConstraint.constant = drawerView.center.y - (containerView.frame.height / 2.0)
        let animator = UIViewPropertyAnimator(duration: AnimationConstants.squareSpeed,
                                              curve: .easeOut) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
}
