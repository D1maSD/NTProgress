//
//  BottomSheetPresentationController.swift
//  TemplateOfDealsViewer
//
//  Created by Мельник Дмитрий on 29.01.2024.
//

import UIKit
//import SnapKit


class BottomSheetPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        let height: CGFloat = containerView.bounds.height / 2
        return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }

        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped)))
        containerView.insertSubview(dimmingView, at: 0)
    }

    override func dismissalTransitionWillBegin() {
        containerView?.subviews.first?.removeFromSuperview()
    }

    @objc func dimmingViewTapped() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}


class BottomSheetViewController: UIViewController {
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var initialPosition: CGPoint = .zero

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = .green
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        if panGestureRecognizer == nil {
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
            view.addGestureRecognizer(panGestureRecognizer)
        }
    }

    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        switch recognizer.state {
        case .began:
            initialPosition = recognizer.translation(in: view)
        case .changed:
            let yTranslation = max(0, translation.y)
            let yPosition = view.superview!.frame.height - yTranslation
            if yPosition >= view.superview!.frame.height - view.frame.height {
                view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
            }
        case .ended:
            if translation.y - initialPosition.y > 100 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view.superview!.frame.height, width: self.view.frame.width, height: self.view.frame.height)
                }, completion: { _ in
                    self.dismiss(animated: false, completion: nil)
                })
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect(x: 0, y: self.view.superview!.frame.height - (self.view.frame.height / 2), width: self.view.frame.width, height: self.view.frame.height)
                }
            }
        default:
            break
        }
    }
}


class PresentingViewController: UIViewController {
    @IBAction func showBottomSheet(_ sender: Any) {
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .custom
        bottomSheetVC.transitioningDelegate = self
        present(bottomSheetVC, animated: true, completion: nil)
    }
}

extension PresentingViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

