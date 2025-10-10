import Foundation

// MARK: - Protocolo de Negócio
protocol HomeBusinessLogic {
    func fetchHomeSections(_ request: HomeModels.FetchSections.Request)
}

// MARK: - Interactor
final class HomeInteractor: HomeBusinessLogic {

    var presenter: HomePresentationLogic?
    private let worker = HomeWorker()

    func fetchHomeSections(_ request: HomeModels.FetchSections.Request) {
        Task {
            do {
                let novelas = try await worker.fetchNovelas()
                let series = try await worker.fetchSeries()
                let cinema = try await worker.fetchCinema()
                
                let response = HomeModels.FetchSections.Response(
                    novelas: novelas,
                    series: series,
                    cinema: cinema
                )
                
                await presenter?.presentHomeSections(response)
            } catch {
                print("Erro ao buscar conteúdo da Home:", error)
            }
        }
    }
}
