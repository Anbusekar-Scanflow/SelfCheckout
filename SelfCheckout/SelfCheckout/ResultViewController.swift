//
//  ResultViewController.swift
//  ScanFlow
//
//  Created by @Mac-OBS-46 on 13/02/23
//

import Foundation
import UIKit
import Vision
import ScanflowCore

//MARK: Protocol for ResultView
protocol ResultViewProtocol {
    func closeAction()
}

//MARK: Protocol for InputFeed
protocol ResultInputProtocol {
    func feedInput(_ result:[String])
}

//MARK: ResultViewController
class ResultViewController: UIViewController {
    
    
    //MARK: UI elements
    private lazy var barView : UIView = {

        let view = UIView()
        view.backgroundColor = .lightGrayColor
        view.layer.cornerRadius = 3
        return view

    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var tableView : UITableView = {

        let table = customTableView(.group, self, self)
        table.backgroundColor = .clear
        table.isScrollEnabled = true
        return table

    }()
    
    private lazy var scanMoreButton : UIButton = {

        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .primaryColor
        btn.layer.cornerRadius = 22.5
        //btn.setTitle(AppStrings.scanMore, for: .normal)
//        btn.titleLabel?.font = .helveticaNowDisplay_Bold(ofSize: 18)
//        btn.addTarget(self, action: #selector(animateDismissView), for: .touchUpInside)
        return btn

    }()
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    //MARK: variables
    
    public var delegate: ResultViewProtocol?
    
    // Constants - to change visible view height
    private let defaultHeight: CGFloat = 150
    
    // keep current new height, initial is default height
    private let dismissibleHeight: CGFloat = 200
    
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    
    private var currentContainerHeight: CGFloat = 300
    
    public var screenPurpose: ScannerType = .qrcode
    
    private var resultDataSource = [String]()
    
    
    //MARK: ViewController LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
       // setupView()
        setupConstraints()
        self.setupPanGesture()
        tableView.reloadData()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
          return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentContainer()
    }
    
    
    //MARK: Private functions
    @objc private func handleCloseAction() {
        animateDismissView()
    }
    
    
    
    private func setupConstraints() {
        // Add subviews
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        containerView.addSubview(scanMoreButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            containerView.topAnchor.constraint(equalTo: view.topAnchor,constant: 25),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // content stackView
            barView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            barView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            barView.widthAnchor.constraint(equalToConstant: 44),
            barView.heightAnchor.constraint(equalToConstant: 4),
            
            scanMoreButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            scanMoreButton.heightAnchor.constraint(equalToConstant: 44),
            scanMoreButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            scanMoreButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: scanMoreButton.topAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            
        ])
        
        // Set dynamic constraints
        // First, set container to default height
        // after panning, the height can expand
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        // By setting the height to default height, the container will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    private func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Pan gesture handler
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
        print("Pan gesture y offset: \(translation.y)")
        
        // Get drag direction
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    private func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func animateDismissView() {
        // hide blur view
        UIView.animate(
            withDuration: 4,
            delay: 2,
            options: .curveEaseInOut,
            animations: {
                self.delegate?.closeAction()
            }
        )
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            //call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
}


//MARK: View controller Extension for Table View Delegate & DataSource
extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultDataSource.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return UITableViewCell()
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch screenPurpose {
        case .tyre:
            return 150
        default:
            return 60//UITableView.automaticDimension
        }
           
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = resultDataSource[indexPath.row]
        UIPasteboard.general.string = str
        //self.showToastHint(AppStrings.copiedSuccessfullty, true)
    }
}


//MARK: View controller Extension for ResultInputProtocol
extension ResultViewController: ResultInputProtocol {
    
    internal func feedInput(_ result:[String]) {
        self.resultDataSource = result
        self.tableView.reloadData()
    }
    
}
