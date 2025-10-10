import Foundation

// MARK: - Protocolo de Apresentação
protocol HomePresentationLogic: AnyObject {
    func presentHomeSections(_ response: HomeModels.FetchSections.Response) async
}

// MARK: - Presenter
final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?

    func presentHomeSections(_ response: HomeModels.FetchSections.Response) async {
        let sections: [HomeModels.SectionViewModel] = [
            .init(title: "Novelas", items: response.novelas),
            .init(title: "Séries", items: response.series),
            .init(title: "Cinema", items: response.cinema)
        ]

        let viewModel = HomeModels.FetchSections.ViewModel(sections: sections)

        await MainActor.run {
            viewController?.displayHomeSections(viewModel)
        }
    }
}
