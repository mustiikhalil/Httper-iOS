//
//  AddProjectViewController.swift
//  Httper
//
//  Created by Meng Li on 30/01/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit
import Eureka

class AddProjectViewController: HttperViewController {
    
    private lazy var projectNameTextRow = TextRow() {
        $0.title = "Project Name"
        $0.placeholder = "Your project name"
    }
    
    private lazy var privilegePickerInputRow = PickerInputRow<String>(nil){
        $0.title = "Privilege"
        $0.options = ["Private"]
    }
    
    private lazy var introductionTextAreaRow = TextAreaRow("notes") {
        $0.placeholder = "Introduction"
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 200)
    }
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        barButtonItem.rx.tap.bind { [unowned self] in
            self.viewModel.saveProject()
        }.disposed(by: disposeBag)
        return barButtonItem
    }()
    
    private lazy var section: Section = {
        let section = Section()
        section.append(projectNameTextRow)
        section.append(privilegePickerInputRow)
        section.append(introductionTextAreaRow)
        return section
    }()
    
    private lazy var formViewController: FormViewController = {
        let viewController = FormViewController()
        viewController.form.append(section)
        return viewController
    }()
    
    private let viewModel: AddProjectViewModel
    
    init(viewModel: AddProjectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(formViewController)
        view.addSubview(formViewController.view)
        formViewController.didMove(toParent: self)
        
        navigationItem.rightBarButtonItem = saveBarButtonItem

        viewModel.title.bind(to: rx.title).disposed(by: disposeBag)
        viewModel.validate.bind(to: saveBarButtonItem.rx.isEnabled).disposed(by: disposeBag)
        viewModel.projectName.twoWayBind(to: projectNameTextRow.rx.value).disposed(by: disposeBag)
        viewModel.introduction.twoWayBind(to: introductionTextAreaRow.rx.value).disposed(by: disposeBag)
    }

    // MARK: - Action
    /**
    @IBAction func saveProject(_ sender: Any) {
        if projectNameTextField.text == "" {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.add_project_error())
            return
        }
        
        replaceBarButtonItemWithActivityIndicator()
        _ = dao.projectDao.save(pname: projectNameTextField.text!,
                                privilege: "private",
                                introduction: introudctionTextView.text!)
        SyncManager.shared.pushLocalProjects { (revision) in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
 */
}