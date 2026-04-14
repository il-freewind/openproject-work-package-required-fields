# OpenProject Work Package Required Fields

`openproject-work-package-required-fields` is a standalone OpenProject plugin that enforces required work package fields when a work package is moved to a target status.

The plugin adds:

- an admin settings page to enable the feature for selected projects
- a project settings page to define required-field rules
- validation that blocks status changes when configured fields are blank
- support for both standard OpenProject fields and project custom fields

## How It Works

Each rule has three parts:

- work package type
- target status
- required field

When a work package changes status, the plugin looks up matching rules for the current project, type, and target status. If any configured field is blank, the status transition is cancelled and the user sees an error listing the missing fields.

Example:

- `Bug` -> `Closed` requires `Assignee`
- `Task` -> `In progress` requires `Start date`

## Installation

1. Clone this repository next to your OpenProject checkout.
2. Add the plugin to OpenProject's `Gemfile.plugins`.
3. Run `bundle install` in the OpenProject application.
4. Run the plugin migrations in OpenProject.
5. Restart the OpenProject server.

Example `Gemfile.plugins` entry:

```ruby
gem "openproject-work-package-required-fields",
    path: "../openproject-work-package-required-fields",
    require: "open_project/work_package_required_fields"
```

Depending on your OpenProject setup, plugin migrations are usually applied with the standard Rails migration task from the main OpenProject app.

### Docker installation notes

For a Docker-based OpenProject installation, prefer copying a clean plugin archive into `/app/modules/openproject-work-package-required-fields` instead of copying the whole working tree. The archive should contain only the gem files listed by the gemspec and should not include temporary files, local test artifacts, or standalone frontend assets.

Recommended container-side `Gemfile.plugins` entry:

```ruby
gem "openproject-work-package-required-fields",
    path: "modules/openproject-work-package-required-fields",
    require: "open_project/work_package_required_fields"
```

After copying the plugin into the container:

```sh
cd /app
BUNDLE_FROZEN=false bundle install
bundle exec rails db:migrate
```

Then restart the OpenProject container. The plugin does not require rebuilding OpenProject frontend assets.

## Configuration

### 1. Enable the plugin for projects

Open the admin page:

- `Administration` -> `Work packages` -> `Required fields`

Select the projects where the plugin should be active.

### 2. Define project rules

For each enabled project, open:

- `Project settings` -> `Work packages` -> `Required fields`

Add one or more rows with:

- work package type
- target status
- required field

Saving an empty rules table removes all rules for that project.

## Supported Fields

The current field catalog includes common standard work package fields such as:

- subject
- description
- assignee
- accountable
- priority
- start date
- due date
- estimated time
- remaining time
- version
- category
- parent
- percent complete

The plugin also exposes available work package custom fields for the selected project.

## Data Model

The plugin creates two tables:

- `op_wp_required_fields_enabled_projects` - projects where the feature is enabled
- `op_wp_required_fields_rules` - per-project rules keyed by project, type, status, and field

## Current Limitations

- Validation runs only on status transitions, not on every work package save.
- The automated tests currently cover the core helper logic only, not full OpenProject integration flows.
- The project settings UI is server-rendered and uses a small CSP-nonce inline script for adding and removing rows.
- Rule configuration is project-based only; there is no global template or inheritance between projects.

## Development

Key implementation areas:

- plugin registration: `lib/open_project/work_package_required_fields/engine.rb`
- validation: `lib/open_project/work_package_required_fields/validator.rb`
- WorkPackage patch: `lib/open_project/work_package_required_fields/patches/work_package_required_fields_patch.rb`
- project settings UI: `app/controllers/projects/work_package_required_fields_settings_controller.rb`
- field catalog: `lib/open_project/work_package_required_fields/field_catalog.rb`

## Подключение и настройка

1. Склонируйте репозиторий рядом с установкой OpenProject.
2. Добавьте плагин в `Gemfile.plugins` основного приложения.
3. Выполните `bundle install` в OpenProject.
4. Примените миграции плагина из основного приложения OpenProject.
5. Перезапустите сервер.

После установки:

1. В админке включите плагин для нужных проектов.
2. В настройках проекта добавьте правила вида `тип задачи -> целевой статус -> обязательное поле`.
3. При смене статуса OpenProject не даст сохранить work package, если обязательные поля пусты.
