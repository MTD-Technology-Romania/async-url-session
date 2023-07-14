# AsyncSession

### The URLSession Wrapper for fester network requests

## Branching Strategy 

We use `main` as the root branch and create your own `feature branch` usng the following templatre `task/some-feature-name`. Always create pull requests against `main`

## Usage 

In order to use this package you should `import AsyncSession`. Please check the examples below in order to get more insights on how you should use our predefined `http` methods.

### Get Request

```swift 

struct ItemsService {
    
    // MARK: - Private
    
    private var api: API
    private var session: AsyncSession
    
    // MARK: - Init
    
    init(api: API = .env, session: AsyncSession = AsyncSession()) {
        self.api = api
        self.session = session
    }
    
    // MARK: - Private Func
    
    private func items() async throws -> [Item] {
        guard let url = URL(string: "\(api.rawValue)/items") else { throw InterfaceError.networkError }
        return try await session.get(
            url: url,
            headers: [
                "Content-Type": "application/json"
            ],
        )
    }
}

```

### Post Request

```swift 

struct SessionService {
    
    // MARK: - Private
    
    private var api: API
    private var session: AsyncSession
    
    // MARK: - Init
    
    init(api: API = .env, session: AsyncSession = AsyncSession()) {
        self.api = api
        self.session = session
    }
    
    // MARK: - Private Func
    
    private func google() throws -> (token: String, user: SessionJWT ) {
        guard let token = GIDSignIn.sharedInstance.currentUser?.idToken?.tokenString  else {
            throw InterfaceError.unknown(message: "User auth is invalid")
        }
        let user = try SessionJWT(token: token)
        return (token: token, user: user)
    }
    
    private func login() async throws -> SessionResponse {
        let google = try google()
        guard let url = URL(string: "\(api.rawValue)/user/login") else { throw InterfaceError.networkError }
        return try await session.post(
            url: url,
            headers: [
                "authorization": google.token,
                "Content-Type": "application/json"
            ],
            body: google.user
        )
    }
}

```
