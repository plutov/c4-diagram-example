workspace {

    model {
        customer = person "Customer"
        admin = person "Admin User"

        emailSystem = softwareSystem "Email System" "Mailgun" "External"
        calendarSystem = softwareSystem "Calendar System" "Calendly" "External"

        taskManagementSystem  = softwareSystem "Task Management System"{
            webContainer = container "User Web UI" "Frontend"
            adminContainer = container "Admin Web UI" "Frontend"
            dbContainer = container "Database" "PostgreSQL"
            apiContainer = container "API" "Go" {
                authComp = component "Authentication"
                crudComp = component "CRUD"
            }
        }

        # Relationships between people and software systems
        customer -> webContainer "Manages tasks"
        admin -> adminContainer "Manages users"
        emailSystem -> customer "Delivers emails"
        emailSystem -> admin "Delivers emails"
        calendarSystem -> customer "Creates tasks in customer's Calendar"
        apiContainer -> emailSystem "Sends emails"
        apiContainer -> calendarSystem "Creates tasks in Calendar"

        # Relationships between containers
        webContainer -> apiContainer "Uses"
        adminContainer -> apiContainer "Uses"
        apiContainer -> dbContainer "Persists data"
    }

    views {
        systemContext taskManagementSystem {
            include *
            autolayout
        }

        container taskManagementSystem {
            include *
            autolayout
        }

        # Dynamic diagram can be used to showcase a specific feature or process
        dynamic taskManagementSystem "LoginFlow" {
            webContainer -> apiContainer "Sends login request with username and password"
            apiContainer -> webContainer "Returns JWT token"
            webContainer -> customer "Persists JWT token in local storage"
            autolayout
        }

        styles {
            element "External" {
                background #cccccc
            }
            element "Frontend" {
                shape WebBrowser
            }
        }
    }
}