import Vapor
import Fluent
import FluentSQLiteDriver

let app = Application()

// Configure database
app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

// Add migrations
app.migrations.add(CreateUser())

// Run migrations
try app.autoMigrate().wait()

// Configure routes
try routes(app)

// Configure port from environment
if let portString = Environment.get("PORT"), let port = Int(portString) {
    app.http.server.configuration.port = port
}
app.http.server.configuration.hostname = "0.0.0.0"

// Run server
defer { app.shutdown() }
try app.run()
