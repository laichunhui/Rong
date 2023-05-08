import Combine

public extension Publisher where Failure == Never {
    var stream: AsyncStream<Output> {
        .init { continuation in
            let cancellable = self
                .eraseToAnyPublisher()
                .sink { completion in
                    switch completion {
                    case .finished:
                        continuation.finish()
                    case let .failure(never):
                        continuation.yield(with: .failure(never))
                    }
                } receiveValue: { output in
                    continuation.yield(output)
                }

            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }
}

public extension Publisher where Failure == Error {
    var throwingStream: AsyncThrowingStream<Output, Failure> {
        .init { continuation in
            let cancellable = self
                .eraseToAnyPublisher()
                .sink { completion in
                    switch completion {
                    case .finished:
                        continuation.finish()
                    case let .failure(error):
                        continuation.finish(throwing: error)
                    }
                } receiveValue: { output in
                    continuation.yield(output)
                }

            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }
}
