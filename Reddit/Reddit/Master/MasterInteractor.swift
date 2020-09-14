//
//  MasterInteractor.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Reddit_api
import Base
import Combine

class MasterInteractor {

    private let redditAPI: RedditAPI
    private var reddits: [Reddit] = []
    private var disposeBag = DisposeBag()

    var viewModel : CurrentValueSubject<MasterViewModel<Reddit>, Never>

    //MARK: - lifecycle
    internal init(redditAPI: RedditAPI = Current.redditAPI) {
        self.redditAPI = redditAPI
        self.viewModel = CurrentValueSubject(MasterViewModel(error: nil, elements: []))
    }

    //MARK: -
    
    func loadReddits() {
        redditAPI.topReddits().call(stub: .now) {[weak self] (result) in
            var error : Error? = nil
            guard let self = self else {return}
            switch result {
            case .failure(let e) :
                error = e
            case .success(let listing):
                self.reddits = listing.children
            }

            self.viewModel.send(MasterViewModel(error: error, elements: self.reddits))
        }
    }

    func reddit(at indexPath: IndexPath) -> Reddit? {
        reddits[safe: indexPath.row]
    }
}

typealias DisposeBag = Set<AnyCancellable>


//In case I want to inject the endpoint
//typealias TopRedditsEndpoint = (Int, String, String?) -> Endpoint<ReddditListing>
