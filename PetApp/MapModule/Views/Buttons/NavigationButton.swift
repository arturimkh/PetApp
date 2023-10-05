//
//  NavigationButton.swift
//  PetApp
//
//  Created by Artur Imanbaev on 27.09.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

final class NavigationButton: UIButton {

    let disposeBag = DisposeBag()
    
    private lazy var navigateImageView = makeNavigateImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 23
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(tap: PublishRelay<Void>) {
        rx.tap
            .bind(to: tap)
            .disposed(by: disposeBag)
    }
}
private extension NavigationButton{
    func setConstraints(){
        addSubview(navigateImageView)
        navigateImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func makeNavigateImageView() -> UIImageView{
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location.fill")
        imageView.contentMode = .center
        imageView.tintColor = UIColor.systemGray
        return imageView
    }
}
