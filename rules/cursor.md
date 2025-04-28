# 返信
やりとりはすべて日本語で行うこと


## Code Style & Project Structure
- **Package Names**: all lowercase, no underscores or mixed punctuation (e.g. `userrepo`, `orderprocessor`).  
- **Type Names**: exported types use PascalCase (e.g. `UserService`), unexported types use camelCase (e.g. `userService`).  
- **Function/Method Names**: camelCase for unexported (`calculateSum`), PascalCase for exported (`CalculateTotal`).  
- **Indentation**: use tabs only (run `gofmt` to enforce).  
- **Braces**: opening brace on same line (e.g. `func Foo() {`).  
- **Formatting**: eliminate unnecessary blank lines or comments; always run `gofmt`/`goimports` before commit.

**Example layout:**

myapp/
├── cmd/
│   └── server/
│       └── main.go          ← エントリポイント
├── internal/
│   ├── domain/              ← ドメインモデル／ビジネスロジック
│   │   ├── model/
│   │   └── service/
│   ├── usecase/             ← アプリケーションサービス（ユースケース）
│   ├── interface/           ← ポート（HTTPハンドラ、gRPCサーバ、CLI など）
│   │   └── http/
│   │       ├── handler.go
│   │       └── router.go
│   └── infrastructure/      ← アダプター（DB, 外部API, メッセージング等）
│       ├── persistence/
│       └── external/
├── pkg/                     ← 他プロジェクトでも使える汎用パッケージ
├── configs/                 ← YAML/JSON/TOML などの設定ファイル
├── scripts/                 ← CI/CD やビルド用スクリプト
├── go.mod
└── go.sum

goのバージョンは常に最新を指定すること
またgoバージョンはasdfのgolangプラグインを使って管理すること



## Functions & Methods
- **Single Responsibility**: each function or method should do one thing and remain under ~50 lines.  
- **Naming**: start with a verb (e.g. `FetchUsers`, `PrintReport`).  
- **Parameters**: do not reassign parameters; if you need to mutate, copy into a local var.  
- **Variadic**: use sparingly (e.g. `func Sum(nums ...int) int`).  
- **Documentation**: every exported function/type must have a GoDoc comment.

## Error Handling
- Always return `error`; do **not** panic for ordinary errors.  
- Include context in error messages:  
  ```go
  return fmt.Errorf("failed to load user %d: %w", id, err)

Wrap lower‐level errors with %w and handle or classify them higher up using errors.Is / errors.As.

Define custom error types if callers need to distinguish error cases.


## Logging & Monitoring

Use structured logging for all application logs.

Prefer Go’s built-in slog package for structured, leveled logs.
Best Practices
Follow DRY and KISS relentlessly.

Define interfaces with the minimal method set (e.g. type UserStore interface { Get(id int) (*User, error) }).

Use constructor functions for dependency injection; avoid package‐level globals.

Leverage goroutines + channels or the sync package for concurrency.

Always defer resource.Close() (files, DB connections, etc.) to ensure cleanup.

# Testing Strategy
Unit Tests with the testing package (*_test.go).

Follow Arrange–Act–Assert.

Use table‐driven tests for multiple cases.

Mock dependencies by hand or with minimal libraries (e.g. testify/mock).

Integration Tests with real dependencies in Docker containers.

Aim for at least 80% coverage.

# Documentation
Write GoDoc comments for all exported symbols:

// FetchUsers returns all users in the system.
func FetchUsers(ctx context.Context) ([]*User, error) { … }
Provide a top‐level README with setup, build, run instructions and a summary of major APIs.

# Final Goal
Enable developers to build high-quality, readable, and maintainable Go web servers quickly by following a clear, consistent architecture and disciplined coding practices.
