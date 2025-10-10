import UIKit

final class FavoriteCollectionReusableView: UICollectionReusableView {

    // MARK: - Identificador
    static let identifier = "FavoriteCollectionReusableView"

    // MARK: - UI Components
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28.0, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    // MARK: - Inicialização
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuração pública
    func setupTitle(_ text: String) {
        headerLabel.text = text
    }

    // MARK: - Configuração visual
    private func setupView() {
        backgroundColor = .clear
        addSubview(headerLabel)
    }

    // MARK: - Layout
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Reuso
    override func prepareForReuse() {
        super.prepareForReuse()
        headerLabel.text = nil
    }
}
