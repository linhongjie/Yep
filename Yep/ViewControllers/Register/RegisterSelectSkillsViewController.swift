//
//  RegisterSelectSkillsViewController.swift
//  Yep
//
//  Created by NIX on 15/4/15.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class RegisterSelectSkillsViewController: UIViewController {

    var annotationText: String = ""
    var selectSkillAction: ((skill: String, selected: Bool) -> Bool)?
    var selectedSkillsSet = Set<String>()

    @IBOutlet weak var annotationLabel: UILabel!

    @IBOutlet weak var skillCategoriesCollectionView: UICollectionView!

    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var skillsCollectionViewBottomConstrain: NSLayoutConstraint!
    
    let skillCategoryCellIdentifier = "SkillCategoryCell"
    let skillSelectionCellIdentifier = "SkillSelectionCell"
    
    lazy var collectionViewWidth: CGFloat = {
        return CGRectGetWidth(self.skillCategoriesCollectionView.bounds)
        }()

    let skillTextAttributes = [NSFontAttributeName: UIFont.skillTextLargeFont()]

    let sectionLeftEdgeInset: CGFloat = registerPickSkillsLayoutLeftEdgeInset
    let sectionRightEdgeInset: CGFloat = 20

    var skillCategories: [[String: AnyObject]] = [
        [
            "categoryName": "Technology",
            "categoryImage": UIImage(named: "icon_skill_tech")!,
        ],
        [
            "categoryName": "Art",
            "categoryImage": UIImage(named: "icon_skill_art")!,
        ],
        [
            "categoryName": "Music",
            "categoryImage": UIImage(named: "icon_skill_music")!,
        ],
        [
            "categoryName": "Life Style",
            "categoryImage": UIImage(named: "icon_skill_life")!,
        ],
        [
            "categoryName": "Love",
            "categoryImage": UIImage(named: "icon_skill_tech")!,
        ],
        [
            "categoryName": "Hate",
            "categoryImage": UIImage(named: "icon_skill_art")!,
        ],
        [
            "categoryName": "Laugh",
            "categoryImage": UIImage(named: "icon_skill_music")!,
        ],
        [
            "categoryName": "Cry",
            "categoryImage": UIImage(named: "icon_skill_life")!,
        ],
    ]

    var skills: [String] = ["Fly", "Say goodbye", "Play hard", "Cry like a baby", "Eat slow", "Run"]

    var currentSkillCategoryButton: SkillCategoryButton?
    var currentSkillCategoryButtonTopConstraintOriginalConstant: CGFloat = 0
    var currentSkillCategoryButtonTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        skillsCollectionView.alpha = 0

        skillCategoriesCollectionView.registerNib(UINib(nibName: skillCategoryCellIdentifier, bundle: nil), forCellWithReuseIdentifier: skillCategoryCellIdentifier)

        skillsCollectionView.registerNib(UINib(nibName: skillSelectionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: skillSelectionCellIdentifier)


    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.skillsCollectionViewBottomConstrain.constant = -CGRectGetHeight(skillsCollectionView.bounds)
    }

    func dismiss() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension RegisterSelectSkillsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader {
            var headerView: AnnoationCollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "annoationLabelView", forIndexPath: indexPath) as! AnnoationCollectionReusableView
            
            headerView.label.text = annotationText
            
            let tap = UITapGestureRecognizer(target: self, action: "dismiss")
            headerView.label.userInteractionEnabled = true
            headerView.label.addGestureRecognizer(tap)
            self.annotationLabel = headerView.label
            
            reusableview = headerView
        }
        
        
        return reusableview
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == skillCategoriesCollectionView {
            return skillCategories.count

        } else if collectionView == skillsCollectionView {
            return skills.count
        }

        return 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if collectionView == skillCategoriesCollectionView {

            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(skillCategoryCellIdentifier, forIndexPath: indexPath) as! SkillCategoryCell

            let skillCategoryInfo = skillCategories[indexPath.item]

            cell.categoryTitle = skillCategoryInfo["categoryName"] as? String
            cell.categoryImage = skillCategoryInfo["categoryImage"] as? UIImage

            cell.toggleSelectionStateAction = { inSelectionState in

                if inSelectionState {

                    let button = cell.skillCategoryButton
                    self.currentSkillCategoryButton = button

                    let frame = cell.convertRect(button.frame, toView: self.view)

                    button.removeFromSuperview()

                    self.view.addSubview(button)

                    button.setTranslatesAutoresizingMaskIntoConstraints(false)

                    let viewsDictionary = [
                        "button": button,
                    ]

                    let widthConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: SkillCategoryCell.skillCategoryButtonWidth)

                    let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: SkillCategoryCell.skillCategoryButtonHeight)

                    let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: frame.origin.y)

                    let centerXConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)

                    NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint, topConstraint, centerXConstraint])

                    self.view.layoutIfNeeded()


                    self.currentSkillCategoryButtonTopConstraint = topConstraint
                    self.currentSkillCategoryButtonTopConstraintOriginalConstant = self.currentSkillCategoryButtonTopConstraint.constant

                    UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in

                        topConstraint.constant = 60

                        self.view.layoutIfNeeded()

                        collectionView.alpha = 0
                        self.annotationLabel.alpha = 0

                    }, completion: { (finished) -> Void in
                    })

                    UIView.animateWithDuration(0.5, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in

                        self.skillsCollectionViewBottomConstrain.constant = -150

                        self.view.layoutIfNeeded()

                        self.skillsCollectionView.alpha = 1

                    }, completion: { (finished) -> Void in
                    })

                } else {
                    if let button = self.currentSkillCategoryButton {
                        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in

                            self.skillsCollectionView.alpha = 0
                            
                        }, completion: { (finished) -> Void in
                        })

                        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in

                            self.currentSkillCategoryButtonTopConstraint.constant = self.currentSkillCategoryButtonTopConstraintOriginalConstant

                            self.skillsCollectionViewBottomConstrain.constant = -CGRectGetHeight(self.skillsCollectionView.bounds)
                            
                            self.view.layoutIfNeeded()

                            collectionView.alpha = 1
                            self.annotationLabel.alpha = 1

                        }, completion: { (_) -> Void in

                            button.removeFromSuperview()

                            cell.contentView.addSubview(button)

                            button.setTranslatesAutoresizingMaskIntoConstraints(false)

                            let widthConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: SkillCategoryCell.skillCategoryButtonWidth)

                            let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: SkillCategoryCell.skillCategoryButtonHeight)

                            let centerXConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: cell.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)

                            let centerYConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: cell.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)

                            NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint, centerXConstraint, centerYConstraint])
                        })
                    }
                }
            }

            return cell
            
        } else { //if collectionView == skillsCollectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(skillSelectionCellIdentifier, forIndexPath: indexPath) as! SkillSelectionCell

            let skill = skills[indexPath.item]

            cell.skillLabel.text = skill

            updateSkillSelectionCell(cell, withSkill: skill)
            
            return cell
        }
    }

    private func updateSkillSelectionCell(skillSelectionCell: SkillSelectionCell, withSkill skill: String) {
        if selectedSkillsSet.contains(skill) {
            skillSelectionCell.tintColor = UIColor.darkGrayColor()
        } else {
            skillSelectionCell.tintColor = UIColor.yepTintColor()
        }
    }

    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {

        if collectionView == skillCategoriesCollectionView {
            return CGSizeMake(collectionViewWidth, SkillCategoryCell.skillCategoryButtonHeight)

        } else if collectionView == skillsCollectionView {

            let skillString = skills[indexPath.item]
            
            let rect = skillString.boundingRectWithSize(CGSize(width: CGFloat(FLT_MAX), height: SkillSelectionCell.height), options: .UsesLineFragmentOrigin | .UsesFontLeading, attributes: skillTextAttributes, context: nil)

            return CGSizeMake(rect.width + 24, SkillSelectionCell.height)
        }

        return CGSizeZero
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {

        if collectionView == skillsCollectionView {
            return UIEdgeInsets(top: 0, left: sectionLeftEdgeInset, bottom: 0, right: sectionRightEdgeInset)
        } else {
            return UIEdgeInsetsZero
        }
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == skillsCollectionView {
            let skill = skills[indexPath.item]

            if let action = selectSkillAction {

                let isInSet = selectedSkillsSet.contains(skill)

                if action(skill: skill, selected: !isInSet) {
                    if isInSet {
                        selectedSkillsSet.remove(skill)
                    } else {
                        selectedSkillsSet.insert(skill)
                    }

                    if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? SkillSelectionCell {
                        updateSkillSelectionCell(cell, withSkill: skill)
                    }
                }
            }
        }
    }

}