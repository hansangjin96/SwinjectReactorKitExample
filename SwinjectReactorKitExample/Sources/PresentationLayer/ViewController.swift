//
//  ViewController.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/21.
//

import Then
import UIKit
import SnapKit
import RxCocoa
import ReactorKit

final class ViewController: UIViewController {
    
    var disposeBag: DisposeBag = .init()
    
    private let searchIDTextField: UITextField = .init().then {
        $0.placeholder = "Git id 입력"
    }
    
    private let startButton: UIButton = .init(type: .system).then {
        $0.setTitle("startButton", for: UIControl.State())
    }
    
    private let resultText: UILabel = .init()
    private let resultImage: UIImageView = .init()
    private let resultIDText: UILabel = .init()
    
    init(reactor: ViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

extension ViewController {
    private func setUpUI() {
        view.backgroundColor = .white
        
        self.view.addSubview(self.searchIDTextField)
        self.searchIDTextField.snp.makeConstraints { 
            $0.top.equalToSuperview().offset(300)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.startButton)
        self.startButton.snp.makeConstraints {
            $0.top.equalTo(self.searchIDTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.resultText)
        self.resultText.snp.makeConstraints { 
            $0.top.equalTo(self.startButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.resultImage)
        self.resultImage.snp.makeConstraints { 
            $0.top.equalTo(self.resultText.snp.bottom).offset(20)
            $0.size.equalTo(100)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.resultIDText)
        self.resultIDText.snp.makeConstraints { 
            $0.top.equalTo(self.resultImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}

extension ViewController: View {
    func bind(reactor: ViewReactor) {
        startButton.rx.tap
            .map { [weak self] in
//                guard let self = self else { return .none }
                return Reactor.Action.searchUser(id: self?.searchIDTextField.text ?? "")
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.searchResult)
            .bind(to: resultText.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.searchAvartarImageResult)
            .bind(to: resultImage.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.searchIDResult)
            .bind(to: resultIDText.rx.text)
            .disposed(by: disposeBag)
        
        reactor.errorResult
            .subscribe(onNext: {
                print("error: ", $0)
            })
            .disposed(by: disposeBag)
    }
}

