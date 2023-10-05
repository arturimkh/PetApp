//
//  TimeSelectionView.swift
//  PetApp
//
//  Created by Artur Imanbaev on 25.09.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay
import RxDataSources
final class TimeSelectionView: UIView {
    
    private lazy var timeCollectionView = makeCollectionView()
    
    private lazy var onWalkLabel = makeOnWalkLabel()
    
    private lazy var timerLabel = makeTimerLabel()
    
    private let timerActivate = BehaviorRelay<Int>(value: 0)
    
    private let disposeBag = DisposeBag()

    private var timer = Timer()
    
    var mins: Int = 0
    var secs: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 15
        setViews()
        setConstraints()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureCollectionView(){
        timeCollectionView.delegate = self
        timeCollectionView.dataSource = self
    }
    public func bind(timerCellTapped:  PublishRelay<IndexPath>,
                     timerActivated: BehaviorRelay<Int>,
                     walkIsActive: BehaviorRelay<Bool>){
        timeCollectionView
            .rx
            .itemSelected
            .bind(to: timerCellTapped)
            .disposed(by: disposeBag)
        
        timerActivated
            .bind(to: timerActivate)
            .disposed(by: disposeBag)
        
        timerActivate.subscribe { [unowned self] time in
            timer.invalidate()
            secs = 1
            mins = time
            startTimer()
        }
        .disposed(by: disposeBag)
        
        walkIsActive
            .bind { [unowned self] _ in
            mins = 0
            secs = 0
            timer.invalidate()
            timeCollectionView.indexPathsForSelectedItems?.forEach{ self.timeCollectionView.deselectItem(at: $0, animated: false) }
            timerLabel.text = ""
        }
        .disposed(by: disposeBag)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self = self else {return}
            if self.secs > 0 {
                self.secs = self.secs - 1
            }
            else if self.mins > 0 && self.secs == 0 {
                self.mins = self.mins - 1
                self.secs = 59
            }
            self.updateLabel()
        })
    }

    private func updateLabel() {
        if secs < 10{
            timerLabel.text = "\(mins):0\(secs)"
        } else {
            timerLabel.text = "\(mins):\(secs)"
        }
    }
}


private extension TimeSelectionView{
    func setViews(){
        addSubview(timeCollectionView)
        addSubview(onWalkLabel)
        addSubview(timerLabel)
    }
    func setConstraints(){
        onWalkLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.equalToSuperview().offset(15)
        }
        timeCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(39)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        timerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-15)
        }
    }
    func makeCollectionView() -> UICollectionView{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TimeSelectionCollectionViewCell.self, forCellWithReuseIdentifier: TimeSelectionCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    func makeOnWalkLabel() -> UILabel{
        let label = UILabel()
        label.text = "На прогулке еще"
        label.font = .systemFont(ofSize: 16)
        return label
    }
    func makeTimerLabel() -> UILabel{
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 18)
        return label
    }
}

extension TimeSelectionView: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return R.Strings.amountOfMins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeSelectionCollectionViewCell.identifier,for: indexPath) as? TimeSelectionCollectionViewCell
        else {return UICollectionViewCell()}
        
        cell.configure(with: R.Strings.amountOfMins[indexPath.row])
        return cell
    }
}



extension TimeSelectionView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout
                collectionViewLayout: UICollectionViewLayout,
                                minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return R.Numbers.minimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: R.Numbers.cellSizeWidth, height:  R.Numbers.cellSizeHeight)
    }
}
