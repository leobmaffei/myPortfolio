//
//  VStack.swift
//  UIKit-Content
//
//  Created by Leonardo Maffei on 08/02/23.
//

import UIKit

class VStack: UIView {
    //MARK: === Subviews ===
    private lazy var contentViewStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = distribution
        content.forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    //MARK: === Properties ===
    private let content: [UIView]
    private let distribution: UIStackView.Distribution

    required init(content: [UIView], distribution: UIStackView.Distribution = .fill) {
        self.content = content
        self.distribution = distribution
        super.init(frame: .zero)
        self.layoutConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutConstraints() {
        self.addSubview(contentViewStack)
        contentViewStack.translatesAutoresizingMaskIntoConstraints = false
        contentViewStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentViewStack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentViewStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentViewStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
