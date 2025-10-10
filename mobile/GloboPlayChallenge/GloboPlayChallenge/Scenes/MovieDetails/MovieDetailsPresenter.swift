import Foundation

protocol MovieDetailsPresentationLogic {
    func presentMovieDetails(_ response: MovieDetailsModels.Fetch.Response)
}

final class MovieDetailsPresenter: MovieDetailsPresentationLogic {
    weak var viewController: MovieDetailsDisplayLogic?
    
    func presentMovieDetails(_ response: MovieDetailsModels.Fetch.Response) {
        let movie = response.movie
        let details = response.details
        
        let posterURL: URL? = {
            if let path = movie.posterPath {
                return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            }
            return nil
        }()
        
        let detailsText = """
        Ficha Técnica
        Título Original: \(details?.titleOriginal ?? "")
        Gênero: \(details?.genero ?? "")
        País: \(details?.pais ?? "")
        Lançamento: \(details?.dataLancamento ?? "")
        Idioma: \(details?.idioma ?? "")
        Descrição: \(details?.descricao ?? "")
        """
        
        let viewModel = MovieDetailsModels.Fetch.ViewModel(
            title: movie.displayTitle ?? "",
            subtitle: movie.mediaType ?? "",
            overview: movie.overview ?? details?.descricao ?? "Sem descrição disponível.",
            posterURL: posterURL,
            detailsText: detailsText,
            related: response.related
        )
        
        DispatchQueue.main.async {
            self.viewController?.displayMovieDetails(viewModel)
        }
    }
}

